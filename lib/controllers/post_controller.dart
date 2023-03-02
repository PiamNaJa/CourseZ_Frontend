import 'package:coursez/model/post.dart';
import 'package:coursez/view_model/post_view_model.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  final PostViewModel postViewModel = PostViewModel();
  final _post = Post(
          postId: 0,
          subjectId: 0,
          userid: 0,
          caption: '',
          postPicture: '',
          comments: [],
          createdAt: 0)
      .obs;
  Post get post => _post.value;
  void clearPost() {
    _post.value = Post(
        postId: 0,
        subjectId: 0,
        userid: 0,
        caption: '',
        postPicture: '',
        comments: [],
        createdAt: 0);
  }
  Stream<Post> get postStream => _post.stream;

  Future<void> fetchPost(String postId) async {
    Post post = await postViewModel.loadPostById(postId);
    _post.value = post;
  }

  final _postList = <Post>[].obs;
  List<Post> get postList => _postList;
  set postList(List<Post> postList) => _postList.value = postList;
  Future<void> fetchPostList(int subjectId) async =>
      postList = await postViewModel.loadPost(subjectId);

  Stream<List<Post>> get postListStream => _postList.stream;
  final _subjectid = 0.obs;
  int get subjectid => _subjectid.value;
  set subjectid(int id) => _subjectid.value = id;

  final _subjectTitle = 'เลือกระดับชั้น'.obs;
  String get subjectTitle => _subjectTitle.value;
  set subjectTitle(String title) => _subjectTitle.value = title;

  final _classLevelName = ''.obs;
  String get classLevelName => _classLevelName.value;
  set classLevelName(String level) => _classLevelName.value = level;

  final _classLevel = 0.obs;
  int get classLevel => _classLevel.value;
  set classLevel(int level) => _classLevel.value = level;
}
