import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ratingStar extends StatefulWidget {
  final double rating;

  const ratingStar({super.key, required this.rating});

  @override
  State<ratingStar> createState() => _ratingStarState();
}

// ignore: camel_case_types
class _ratingStarState extends State<ratingStar> {
  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: widget.rating,
      direction: Axis.horizontal,
      itemCount: 5,
      itemSize: 20,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
  }
}
