// ignore_for_file: constant_identifier_names

import 'dart:math';
import 'package:coursez/utils/recognition.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:image/image.dart' as imageLib;

class Classifier {
  /// Instance of Interpreter
  Interpreter interpreter;

  /// Labels file loaded as List
  List<String> labels;

  /// Shapes of output tensors
  List<List<int>> outputShapes;

  /// Types of output tensors
  List<TfLiteType> outputTypes;

  Classifier({
    required this.interpreter,
    required this.labels,
    this.outputShapes = const [],
    this.outputTypes = const [],
  }) {
    loadModel();
    loadLabels();
  }

  /// Loads interpreter from asset
  /// Loads interpreter from asset
  void loadModel() async {
    try {
      final outputTensors = interpreter.getOutputTensors();
      outputShapes = [];
      outputTypes = [];
      for (final tensor in outputTensors) {
        outputShapes.add(tensor.shape);
        outputTypes.add(tensor.type);
      }
    } catch (e) {
      debugPrint("Error while creating interpreter: $e");
    }
  }

  /// Loads labels from assets
  void loadLabels() async {
    try {
      labels = await FileUtil.loadLabels("assets/labelmap.txt");
    } catch (e) {
      debugPrint("Error while loading labels: $e");
    }
  }

  /// Gets the interpreter instance
  Interpreter get getInterpreter => interpreter;

  /// Input size of image (height = width = 300)
  static const int INPUT_SIZE = 300;

  static const int NUM_RESULTS = 10;

  static const double THRESHOLD = 0.5;

  /// [ImageProcessor] used to pre-process the image
  late ImageProcessor imageProcessor;

  /// Padding the image to transform into square
  late int padSize;

  /// Pre-process the image
  TensorImage getProcessedImage(TensorImage inputImage) {
    final padSize = max(inputImage.height, inputImage.width);

    // create ImageProcessor
    imageProcessor = ImageProcessorBuilder()
        // Padding the image
        .add(ResizeWithCropOrPadOp(padSize, padSize))
        // Resizing to input size
        .add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeMethod.BILINEAR))
        .build();

    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  /// Runs object detection on the input image
  Map<String, dynamic> predict(imageLib.Image image) {
    // Create TensorImage from image
    TensorImage inputImage = TensorImage.fromImage(image);

    // Pre-process TensorImage
    inputImage = getProcessedImage(inputImage);

    // TensorBuffers for output tensors
    final TensorBuffer outputLocations = TensorBufferFloat(outputShapes[0]);
    final TensorBuffer outputClasses = TensorBufferFloat(outputShapes[1]);
    final TensorBuffer outputScores = TensorBufferFloat(outputShapes[2]);
    final TensorBuffer numLocations = TensorBufferFloat(outputShapes[3]);

    // Inputs object for runForMultipleInputs
    // Use [TensorImage.buffer] or [TensorBuffer.buffer] to pass by reference
    final List<Object> inputs = [inputImage.buffer];

    // Outputs map
    final Map<int, Object> outputs = {
      0: outputLocations.buffer,
      1: outputClasses.buffer,
      2: outputScores.buffer,
      3: numLocations.buffer,
    };

    // run inference
    interpreter.runForMultipleInputs(inputs, outputs);

    // Maximum number of results to show
    int resultsCount = min(NUM_RESULTS, numLocations.getIntValue(0));

    // Using labelOffset = 1 as ??? at index 0
    const int labelOffset = 1;

    // Using bounding box utils for easy conversion of tensorbuffer to List<Rect>
    final List<Rect> locations = BoundingBoxUtils.convert(
      tensor: outputLocations,
      valueIndex: [1, 0, 3, 2],
      boundingBoxAxis: 2,
      boundingBoxType: BoundingBoxType.BOUNDARIES,
      coordinateType: CoordinateType.RATIO,
      height: INPUT_SIZE,
      width: INPUT_SIZE,
    );

    final List<Recognition> recognitions = [];

    for (int i = 0; i < resultsCount; i++) {
      // Prediction score
      final score = outputScores.getDoubleValue(i);

      // Label string
      final labelIndex = outputClasses.getIntValue(i) + labelOffset;
      final label = labels.elementAt(labelIndex);

      if (score > THRESHOLD) {
        // inverse of rect
        // [locations] corresponds to the image size 300 X 300
        // inverseTransformRect transforms it our [inputImage]
        final Rect transformedRect = imageProcessor.inverseTransformRect(
            locations[i], image.height, image.width);

        recognitions.add(
          Recognition(i, label, score, transformedRect),
        );
      }
    }

    return {
      "recognitions": recognitions,
    };
  }
}
