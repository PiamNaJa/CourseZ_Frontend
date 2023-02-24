import 'package:coursez/controllers/level_controller.dart';
import 'package:coursez/model/post.dart';
import 'package:coursez/utils/color.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:coursez/widgets/dropdown/dropdown.dart';
import 'package:coursez/widgets/text/heading2_20px.dart';
import 'package:coursez/widgets/text/title16px.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();
  PostViewModel postViewModel = PostViewModel();
  LevelController levelController = Get.put(LevelController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: const Heading20px(text: 'Community ถาม - ตอบ'),
            backgroundColor: whiteColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
              onPressed: () {
                Get.back();
              },
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Row(
                children: [
                  Dropdown(),
                ],
              ),
            )),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              newPost(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  height: 1,
                  color: greyColor,
                ),
              ),
              FutureBuilder(
                future: postViewModel.loadPost(0, 0),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return postList(snapshot.data![index]);
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )
            ],
          ),
        ));
  }

  Widget postList(Post item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  "https://scontent.fbkk13-1.fna.fbcdn.net/v/t1.15752-9/330666638_865270507870914_8640156952006940951_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=ae9488&_nc_eui2=AeE6rOfzFDrsUIkreRUThDy6yjJ-bcn4UGbKMn5tyfhQZkRdX9OTFmB4QIXcPxbwvBwA2-Na1KytCanykqSXbwFK&_nc_ohc=5cAFrcyIeSsAX_M7kN9&_nc_ht=scontent.fbkk13-1.fna&oh=03_AdSgp9Fmduvp6CJ35kx5RigsUvcS54WJ5JExUHEO0vC47w&oe=641ECF84",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const Title16px(text: 'ต้นข้าวสุดที่รัก'),
              const Expanded(child: Icon(Icons.three_k))
            ],
          )
        ],
      ),
    );
  }

  Widget newPost() {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: ClipOval(
              child: Image.network(
                "https://scontent.fbkk13-1.fna.fbcdn.net/v/t1.15752-9/330666638_865270507870914_8640156952006940951_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=ae9488&_nc_eui2=AeE6rOfzFDrsUIkreRUThDy6yjJ-bcn4UGbKMn5tyfhQZkRdX9OTFmB4QIXcPxbwvBwA2-Na1KytCanykqSXbwFK&_nc_ohc=5cAFrcyIeSsAX_M7kN9&_nc_ht=scontent.fbkk13-1.fna&oh=03_AdSgp9Fmduvp6CJ35kx5RigsUvcS54WJ5JExUHEO0vC47w&oe=641ECF84",
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            title: const Text('kpn.palm'),
            subtitle: const Text('นักเรียน'),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.image),
                color: primaryColor,
              ),
              Form(
                  key: _formKey,
                  child: Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'เขียนโพสต์',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  )),
              IconButton(
                  onPressed: () {
                    // if (_formKey.currentState!.validate()) {
                    //   ScaffoldMessenger.of(context)
                    //       .showSnackBar(const SnackBar(content: Text('Pass')));
                    // }
                  },
                  icon: const Icon(Icons.send),
                  color: primaryColor),
            ],
          )
        ],
      ),
    );
  }
}
