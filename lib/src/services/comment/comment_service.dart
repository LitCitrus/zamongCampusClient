import 'package:zamongcampus/src/business_logic/models/comment.dart';

abstract class CommentService {
  //댓글 생성
  Future<bool> createComment({required int postId, required String body});

  //대댓글 생성
  Future<bool> createNestedComment(
      {required int postId, required int parentId, required String body});

//댓글들 전부 가져오기
  Future<List<Comment>> fetchComments({required int postId});

  //댓글 삭제
  Future<bool> deleteComment({required int postId, required int commentId});
}
