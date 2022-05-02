import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:zamongcampus/src/config/dummy_data.dart';

import '../../business_logic/models/post.dart';
import 'post_service.dart';

class FakePostService implements PostService {
  @override
  Future<List<Post>> fetchPosts(
      {required String type, required int nextPageToken}) async {
    List<Post> list = [];
    list.addAll(postDummy1);

    return list;
  }

  @override
  Future<Post> fetchPostDetail({required int postId}) async {
    Post post;
    post = postDummy1[1];

    return post;
  }

  @override
  Future<int> likePost({required String loginId, required int postId}) async {
    // TODO: implement likePost
    int likecount = Random().nextInt(100);
    return likecount;
  }

  @override
  Future<bool> createPost(
      {required String title,
      required String body,
      List<XFile>? imageFileList}) {
    // TODO: implement createPost
    throw UnimplementedError();
  }
}
