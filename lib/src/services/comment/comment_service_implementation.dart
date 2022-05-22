import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zamongcampus/src/business_logic/init/auth_service.dart';
import 'package:zamongcampus/src/business_logic/models/comment.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/services/comment/comment_service.dart';

class CommentServiceImpl implements CommentService {
  @override
  Future<bool> createComment(
      {required int postId, required String body}) async {
    String commentJson = json.encode({
      "body": body,
    });
    final response = await http.post(
        Uri.parse(devServer + "/api/post/" + postId.toString() + "/comment"),
        headers: AuthService.get_auth_header(),
        body: commentJson);
    if (response.statusCode == 201) {
      print("댓글 생성 성공");
      return true;
    } else {
      throw Exception("댓글 생성 오류");
    }
  }

  @override
  Future<bool> createNestedComment(
      {required int postId,
      required int parentId,
      required String body}) async {
    String nestedCommentJson =
        json.encode({"body": body, "parentId": parentId});

    final response = await http.post(
        Uri.parse(devServer + "/api/post/" + postId.toString() + "/comment"),
        headers: AuthService.get_auth_header(),
        body: nestedCommentJson);

    if (response.statusCode == 201) {
      print("대댓글 생성 성공");
      return true;
    } else {
      print("성공? 응 아니야");
      return false;
    }
  }

  @override
  Future<List<Comment>> fetchComments({required int postId}) async {
    final response = await http.get(
        Uri.parse(devServer + "/api/post/" + postId.toString() + '/comment'),
        headers: AuthService.get_auth_header());

    if (response.statusCode == 200) {
      List<Comment> comments = await jsonDecode(utf8.decode(response.bodyBytes))
          .map<Comment>((json) => Comment.fromJson(json))
          .toList();
      return comments;
    } else {
      throw Exception('댓글 가져오기 실패');
    }
  }

  @override
  Future<bool> deleteComment(
      {required int postId, required int commentId}) async {
    final response = await http.delete(
        Uri.parse(devServer +
            "/api/post/" +
            postId.toString() +
            "/comment/" +
            commentId.toString()),
        headers: AuthService.get_auth_header());

    if (response.statusCode == 204) {
      print('삭제 완료');
      return true;
    } else {
      print('오류: 댓글 삭제 실패');
      return false;
    }
  }
}
