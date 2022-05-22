import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/models/post.dart';
import 'package:zamongcampus/src/business_logic/utils/category_data.dart';
import 'package:zamongcampus/src/business_logic/utils/date_convert.dart';
import 'package:zamongcampus/src/business_logic/view_models/base_model.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/services/post/post_service.dart';

class PostMainScreenViewModel extends BaseModel {
  final PostService _postService = serviceLocator<PostService>();

  List<PostPresentation> _posts = [];
  String _sortType = "popular";
  ScrollController scrollController = ScrollController();
  int _nextPageToken = 0;

  List<PostPresentation> get posts => _posts;
  String get sortType => _sortType;

  void loadPost() async {
    setBusy(true);
    await Future.delayed(const Duration(milliseconds: 500)); // 0.5초 딜레이
    List<Post> postResult = await _postService.fetchPosts(
        type: _sortType, nextPageToken: _nextPageToken);
    posts.addAll(postResult.map((post) => PostPresentation(
          id: post.id,
          loginId: post.loginId,
          categories: post.categories == null
              ? []
              : post.categories!
                  .map((category) =>
                      CategoryData.iconOf(category.name) +
                      " " +
                      CategoryData.korNameOf(category.name))
                  .toList(),
          title: post.title,
          body: post.body,
          createdAt: dateToPastTime(post.createdAt),
          likedCount: post.likedCount.toString(),
          viewCount: post.viewCount.toString(),
          commentCount: post.commentCount.toString(),
          imageUrl: post.imageUrls.isEmpty ? null : post.imageUrls.first,
        )));
    _nextPageToken++;

    setBusy(false);
  }

  void changePostType(int value) {
    switch (value) {
      case 0:
        _sortType = "popular";
        break;
      case 1:
        _sortType = "recommend";
        break;
      case 2:
        _sortType = "recent";
        break;
      default:
        break;
    }
  }

  void refreshPost(int value) {
    _posts = []; //포스트에 담았던거 다 비움
    _nextPageToken = 0;
    changePostType(value);
    loadPost();
  }
}

/* String 값으로 변환된 viewmodel */
class PostPresentation {
  final int id;
  final String loginId;
  final List<dynamic> categories;
  final String title;
  final String body;
  String createdAt;
  String likedCount;
  String viewCount;
  String commentCount;
  String? imageUrl;

  PostPresentation(
      {required this.id,
      required this.loginId,
      required this.categories,
      required this.title,
      required this.body,
      required this.createdAt,
      required this.likedCount,
      required this.viewCount,
      required this.commentCount,
      this.imageUrl});
}
