import 'package:coursez/model/post.dart';
import 'package:coursez/utils/fetchData.dart';

class PostViewModel {
  Future<List<Post>> loadPost(int level, int subject) async {
    final p = await fecthData('post');
    final List<Post> post = List.from(p.map((e) => Post.fromJson(e)).toList());
    List<Post> postLevel = [];
    List<Post> postSubject = [];
    List<Post> postLevelSubject = [];
    return post;

    // if (level == 0 && subject == 0) {
    //   return post;
    // } else if (level == 0 && subject != 0) {
    //   for (var i = 0; i < post.length; i++) {
    //     if (post[i].subject == subject) {
    //       postSubject.add(post[i]);
    //     }
    //   }
    //   return postSubject;
    // } else if (level != 0 && subject == 0) {
    //   for (var i = 0; i < post.length; i++) {
    //     if (post[i].level == level) {
    //       postLevel.add(post[i]);
    //     }
    //   }
    //   return postLevel;
    // } else {
    //   for (var i = 0; i < post.length; i++) {
    //     if (post[i].level == level && post[i].subject == subject) {
    //       postLevelSubject.add(post[i]);
    //     }
    //   }
    //   return postLevelSubject;
    // }
  }
}
