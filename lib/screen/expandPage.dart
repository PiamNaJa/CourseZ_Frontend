import 'package:coursez/utils/color.dart';
import 'package:coursez/widgets/text/heading1_24px.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';

class ExpandPage extends StatefulWidget {
  const ExpandPage({super.key});

  @override
  State<ExpandPage> createState() => _ExpandPageState();
}

class _ExpandPageState extends State<ExpandPage> {
  //Simple List with text and image network
  List<String> image = [
    'https://www.w3schools.com/w3images/lights.jpg',
    'https://www.w3schools.com/w3images/nature.jpg',
    'https://www.w3schools.com/w3images/mountains.jpg',
    'https://www.w3schools.com/w3images/forest.jpg',
    'https://www.w3schools.com/w3images/nature.jpg',
    'https://www.w3schools.com/w3images/lights.jpg',
    'https://www.w3schools.com/w3images/nature.jpg',
    'https://www.w3schools.com/w3images/mountains.jpg',
    'https://www.w3schools.com/w3images/forest.jpg',
    'https://www.w3schools.com/w3images/nature.jpg',
    'https://www.w3schools.com/w3images/lights.jpg',
    'https://www.w3schools.com/w3images/nature.jpg',
    'https://www.w3schools.com/w3images/mountains.jpg',
    'https://www.w3schools.com/w3images/forest.jpg',
    'https://www.w3schools.com/w3images/nature.jpg'
  ];
  List<String> title = [
    'Lights',
    'Nature',
    'Mountains',
    'Forest',
    'Nature',
    'Lights',
    'Nature',
    'Mountains',
    'Forest',
    'Nature',
    'Lights',
    'Nature',
    'Mountains',
    'Forest',
    'Nature'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Heading24px(text: 'Subject List'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: image.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                //onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage())),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10, left: 20, top: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          image: DecorationImage(
                            image: NetworkImage(image[index]),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Heading20px(text: title[index]),
                          const SizedBox(height: 5),
                          const Title16px(text: 'Subtitle', color: secondaryColor,),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],)
    );
  }
}
