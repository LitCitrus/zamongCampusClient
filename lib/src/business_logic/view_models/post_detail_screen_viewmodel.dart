import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/models/comment.dart';
import 'package:zamongcampus/src/business_logic/utils/category_data.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/utils/date_convert.dart';
import 'package:zamongcampus/src/business_logic/utils/methods.dart';
import 'package:zamongcampus/src/business_logic/view_models/base_model.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/services/comment/comment_service.dart';
import 'package:zamongcampus/src/services/post/post_service.dart';
import 'package:zamongcampus/src/business_logic/models/post.dart';

class PostDetailScreenViewModel extends BaseModel {
  final PostService _postService = serviceLocator<PostService>();
  final CommentService _commentService = serviceLocator<CommentService>();

  PostDetailPresentation _postDetail = defaultPostDetail;
  final List<CommentPresentation> _comments = [];
  int _currentPostId = -1;
  int _parentId = -1; //대댓글 생성할 때 쓰는용도
  bool _isliked = false; //좋아요 기능 관련 -> 수정 필요할수도 있음

  final _commentTextController = TextEditingController();
  final _nestedCommentTextController = TextEditingController();
  TextEditingController get commentTextController => _commentTextController;
  TextEditingController get nestedCommentTextController =>
      _nestedCommentTextController;

  OverlayEntry? overlayEntry;
  final LayerLink layerLink = LayerLink();

  static final PostDetailPresentation
      defaultPostDetail = //postDetailPresentation 초기값 설정
      PostDetailPresentation(
          id: 0,
          loginId: '',
          categories: [],
          title: '',
          userNickname: '',
          userImageUrl: 'assets/images/user/general_user.png',
          body: '',
          createdAt: '',
          likedCount: '',
          commentCount: '');

  PostDetailPresentation get postDetail => _postDetail;
  List<CommentPresentation> get comments => _comments;
  bool get isliked => _isliked;

  void loadPostDetail(int postId) async {
    setBusy(true);
    Post postDetailResult = await _postService.fetchPostDetail(postId: postId);

    _comments.addAll(postDetailResult.comments!.map((comment) =>
        CommentPresentation(
            id: comment.id,
            loginId: comment.loginId,
            userNickname: comment.userNickname,
            body: comment.body,
            deleted: comment.deleted,
            parentId: comment.parentId,
            children: comment.children
                    .map((nestedComment) => CommentPresentation(
                        id: nestedComment.id,
                        loginId: nestedComment.loginId,
                        userNickname: nestedComment.userNickname,
                        body: nestedComment.body,
                        deleted: nestedComment.deleted,
                        parentId: nestedComment.parentId,
                        userImageUrl: nestedComment.userImageUrls?.first ??
                            'assets/images/user/general_user.png',
                        createdAt: dateToPastTime(nestedComment.createdAt),
                        children: nestedComment.children))
                    .toList() ??
                [],
            userImageUrl: comment.userImageUrls?.first ??
                'assets/images/user/general_user.png',
            createdAt: dateToPastTime(comment.createdAt))));

    int _commentCount = 0;

    //총 댓글 수 카운트 -> 삭제한거는 제외하고 카운트..
    // for (CommentPresentation comment in _comments) {
    //   if (!comment.deleted) {
    //     _commentCount++;
    //   }
    //   if (comment.children != []) {
    //     for (dynamic nestedComment in comment.children) {
    //       if (!nestedComment.deleted) {
    //         _commentCount += comment.children.length;
    //       }
    //     }
    //   }
    // }

    //총 댓글 수 카운트 -> 삭제한거도 포함
    for (CommentPresentation comment in _comments) {
      _commentCount++;
      _commentCount += comment.children.length;
    }

    _postDetail = PostDetailPresentation(
      id: postDetailResult.id,
      loginId: postDetailResult.loginId,
      categories: postDetailResult.categories
          ?.map((category) =>
              CategoryData.iconOf(category.name) +
              " " +
              CategoryData.korNameOf(category.name))
          .toList(),
      title: postDetailResult.title,
      userNickname: postDetailResult.userNickname,
      userImageUrl:
          postDetailResult.userImageUrls?.first ?? _postDetail.userImageUrl,
      body: postDetailResult.body,
      createdAt: dateToPastTime(postDetailResult.createdAt),
      likedCount: '0',
      commentCount: _commentCount.toString(),
      imageUrls: postDetailResult.imageUrls.toList(),
    );

    _currentPostId = postId;

    setBusy(false);
  }

  void likePost(String loginId, int postId) async {
    setBusy(true);
    _isliked = !_isliked;
    int likecount =
        await _postService.likePost(loginId: loginId, postId: postId);
    _postDetail.likedCount = likecount.toString();
    setBusy(false);
  }

  void changeLikedCount(String likedCount) {
    _postDetail.likedCount = likedCount;
    notifyListeners();
  }

  void createComment() async {
    if (_commentTextController.text.isEmpty) {
      toastMessage('댓글을 입력해주세요');
      return;
    }
    bool isCreated = await _commentService.createComment(
        postId: _postDetail.id, body: _commentTextController.text);
    if (isCreated) {
      toastMessage("댓글 생성 성공");
    } else {
      toastMessage("ㄴㄴ 구현 잘못함 다시하셈");
    }
    _commentTextController.clear();
    refreshComments();
  }

  void createNestedComment() async {
    if (_nestedCommentTextController.text.isEmpty) {
      toastMessage('댓글을 입력해주세요');
      return;
    }
    bool isCreated = await _commentService.createNestedComment(
        postId: _postDetail.id,
        parentId: _parentId,
        body: _nestedCommentTextController.text);
    if (isCreated) {
      removeNestedCommentOverlay();
      toastMessage("commentId $_parentId 에게 대댓글 생성 성공");
    } else {
      toastMessage("ㄴㄴ 구현 잘못함 다시하셈");
    }
    _nestedCommentTextController.clear();
    refreshComments();
  }

  void refreshComments() async {
    _comments.clear();
    List<Comment> commentsResult =
        await _commentService.fetchComments(postId: _currentPostId);
    _comments.addAll(commentsResult.map((comment) => CommentPresentation(
        id: comment.id,
        loginId: comment.loginId,
        userNickname: comment.userNickname,
        body: comment.body,
        deleted: comment.deleted,
        parentId: comment.parentId,
        children: comment.children
            .map((nestedComment) => CommentPresentation(
                id: nestedComment.id,
                loginId: nestedComment.loginId,
                userNickname: nestedComment.userNickname,
                body: nestedComment.body,
                deleted: nestedComment.deleted,
                parentId: nestedComment.parentId,
                userImageUrl: nestedComment.userImageUrls?.first ??
                    'assets/images/user/general_user.png',
                createdAt: dateToPastTime(nestedComment.createdAt),
                children: nestedComment.children))
            .toList(),
        userImageUrl: comment.userImageUrls?.first ??
            'assets/images/user/general_user.png',
        createdAt: dateToPastTime(comment.createdAt!))));

    //총 댓글 수 카운트
    int _commentCount = 0;
    //총 댓글 수 카운트 -> 삭제한거도 포함
    for (CommentPresentation comment in _comments) {
      _commentCount++;
      _commentCount += comment.children.length;
    }

    _postDetail.commentCount = _commentCount.toString();

    notifyListeners();
  }

  void deleteComment(int commentId) async {
    bool isDeleted = await _commentService.deleteComment(
        postId: _postDetail.id, commentId: commentId);
    if (isDeleted) {
      toastMessage("댓글 삭제 성공");
      refreshComments();
    } else {
      toastMessage("오류: 삭제 실패");
    }
  }

  // 대댓글 overlay 생성
  void createNestedCommentOverlay(
      BuildContext context, String parentUserNickname, int parentId) {
    _parentId = parentId;
    if (overlayEntry == null) {
      overlayEntry = showNestedCommentInput(parentUserNickname);
      Overlay.of(context)?.insert(overlayEntry!);
      print('createoverlay');
    }
    notifyListeners();
  }

  // 대댓글 overlay 해제
  void removeNestedCommentOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
    print('removeoverlay');
    notifyListeners();
  }

  //댓글창 위에 올라오는 overlay 형태 -> 뷰에서 사용하진 않고 createNestedCommentOverlay에서 사용한다
  OverlayEntry showNestedCommentInput(String targetUserNickname) {
    return OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        width: SizeConfig.screenWidth,
        child: CompositedTransformFollower(
          link: layerLink,
          offset: Offset(0, -getProportionateScreenHeight(40)),
          child: Material(
            child: Container(
                height: getProportionateScreenHeight(40),
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(25)),
                decoration: const BoxDecoration(
                  color: mainColor,
                ),
                child: Row(
                  children: [
                    RichText(
                        text: TextSpan(
                            text: targetUserNickname,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            children: const [
                          TextSpan(
                              text: '님에게 댓글을 다는 중',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300))
                        ])),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        removeNestedCommentOverlay();
                      },
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class PostDetailPresentation {
  final int id;
  final String loginId;
  final List<dynamic>? categories;
  final String title;
  final String userNickname;
  final String userImageUrl;
  final String body;
  String createdAt;
  String likedCount;
  String commentCount;
  List<dynamic>? imageUrls;

  PostDetailPresentation({
    required this.id,
    required this.loginId,
    required this.categories,
    required this.title,
    required this.userNickname,
    required this.userImageUrl,
    required this.body,
    required this.createdAt,
    required this.likedCount,
    required this.commentCount,
    this.imageUrls,
  });
}

class CommentPresentation {
  final int id;
  final String loginId;
  final String userNickname;
  final String body;
  bool deleted;
  final int parentId;
  final String userImageUrl;
  String createdAt;
  List<dynamic> children;

  CommentPresentation({
    required this.id,
    required this.loginId,
    required this.userNickname,
    required this.body,
    required this.deleted,
    required this.parentId,
    required this.userImageUrl,
    required this.createdAt,
    required this.children,
  });
}
