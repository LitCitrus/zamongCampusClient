import 'package:zamongcampus/src/business_logic/models/comment.dart';
import 'package:zamongcampus/src/services/comment/comment_service.dart';

class FakeCommentService implements CommentService {
  @override
  Future<bool> createComment({required int postId, required String body}) {
    // TODO: implement createComment
    throw UnimplementedError();
  }

  @override
  Future<bool> createNestedComment(
      {required int postId, required int parentId, required String body}) {
    // TODO: implement createNestedComment
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteComment({required int postId, required int commentId}) {
    // TODO: implement deleteComment
    throw UnimplementedError();
  }

  @override
  Future<List<Comment>> fetchComments({required int postId}) {
    // TODO: implement fetchComments
    throw UnimplementedError();
  }
}
