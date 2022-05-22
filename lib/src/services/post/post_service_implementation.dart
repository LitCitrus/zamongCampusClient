import 'package:image_picker/image_picker.dart';
import 'package:zamongcampus/src/business_logic/init/auth_service.dart';

import '../../business_logic/models/post.dart';
import '../../business_logic/utils/constants.dart';
import 'post_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostServiceImpl implements PostService {
  @override
  Future<List<Post>> fetchPosts(
      {required String type, required int nextPageToken}) async {
    final response = await http.get(
        Uri.parse(
          devServer +
              "/api/post/" +
              type +
              "?nextPageToken=" +
              nextPageToken.toString(),
        ),
        headers: AuthService.get_auth_header());
    if (response.statusCode == 200) {
      List<Post> posts = await jsonDecode(utf8.decode(response.bodyBytes))
          .map<Post>((json) => Post.fromJson(json))
          .toList();

      return posts;
    } else {
      // 만약 응답이 OK가 아니면, 에러를 던집니다.
      throw Exception(
          '[오류]게시물을 가져오는데 실패했습니다. (Failed to load posts)'); // TODO : 이 오류가 생기면 앱 자체를 새로 load하는 모듈 필요
    }
  }

  @override
  Future<Post> fetchPostDetail({required int postId}) async {
    final response = await http.get(
        Uri.parse(devServer + "/api/post/" + postId.toString()),
        headers: AuthService.get_auth_header());
    if (response.statusCode == 200) {
      Post post =
          Post.fromJson(await jsonDecode(utf8.decode(response.bodyBytes)));
      return post;
    } else {
      throw Exception('게시물 패치 오류');
    }
  }

  @override
  Future<int> likePost({required String loginId, required int postId}) {
    // TODO: implement likePost
    throw UnimplementedError();
  }

  @override
  Future<bool> createPost(
      {required String title,
      required String body,
      List<XFile>? imageFileList}) async {
    var request =
        http.MultipartRequest("POST", Uri.parse(devServer + "/api/post"))
          ..headers.addAll(AuthService.get_auth_header());

    request.fields['body'] = body;
    request.fields['title'] = title;
    if (imageFileList != null) {
      for (var imageFile in imageFileList) {
        request.files
            .add(await http.MultipartFile.fromPath('files', imageFile.path));
      }
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      print("post 생성 성공");
      return true;
    } else {
      return false;
    }
  }
}
