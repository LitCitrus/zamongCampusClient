import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/models/friend.dart';
import 'package:zamongcampus/src/business_logic/models/user.dart';
import 'package:zamongcampus/src/business_logic/models/voice_room.dart';
import 'package:zamongcampus/src/business_logic/utils/category_data.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/services/friend/friend_service.dart';
import 'package:zamongcampus/src/services/user/user_service.dart';
import 'package:zamongcampus/src/services/voice/voice_service.dart';
import 'package:zamongcampus/src/ui/common_components/select_cateory_dialog_component/select_category_dialog.dart';

import 'base_model.dart';

class VoiceCreateViewModel extends BaseModel {
  final UserService _userService = serviceLocator<UserService>();
  final FriendService _friendService = serviceLocator<FriendService>();
  final VoiceService _voiceService = serviceLocator<VoiceService>();

  final List<UserPresentation> _recentTalkUsers = List.empty(growable: true);
  final List<UserPresentation> _friendUsers = List.empty(growable: true);
  List<UserPresentation> _searchedRecentUsers = List.empty(growable: true);
  List<UserPresentation> _searchedFriendUsers = List.empty(growable: true);

  VoiceRoomType _type = VoiceRoomType.PUBLIC;
  final TextEditingController _titleController = TextEditingController();

  List<Category> _categories = [];
  final List<CategoryPresentation> _selectedCategories = []; //view에서 사용
  final List<dynamic> _categoryResult = []; //서버로 보내는 용도

  bool _collegeOnlyChecked = false;
  bool _majorOnlyChecked = false;

  final TextEditingController _recentTalkSearchController =
      TextEditingController();
  final TextEditingController _friendSearchController = TextEditingController();
  final List<String> _members = [];

  //뷰에서 접근이 필요한 변수
  List<UserPresentation> get recentTalkUsers => _recentTalkUsers;
  List<UserPresentation> get friendUsers => _friendUsers;
  TextEditingController get titleController => _titleController;
  TextEditingController get recentTalkSearchController =>
      _recentTalkSearchController;
  TextEditingController get friendSearchController => _friendSearchController;
  List<UserPresentation> get searchedRecentUsers => _searchedRecentUsers;
  List<UserPresentation> get searchedFriendUsers => _searchedFriendUsers;

  List<CategoryPresentation> get selectedCategories => _selectedCategories;
  bool get collegeOnlyChecked => _collegeOnlyChecked;
  bool get majorOnlyChecked => _majorOnlyChecked;
  List<String> get members => _members;

//최근 대화 유저 로드 함수
  void loadRecentTalkUsers() async {
    setBusy(true);
    List<User> recentTalkUserResult = await _userService.fetchRecentTalkUsers();

    _recentTalkUsers.addAll(recentTalkUserResult.map((recentTalkUser) =>
        UserPresentation(
            loginId: recentTalkUser.loginId,
            userImageUrl: recentTalkUser.imageUrl ??
                "assets/images/user/general_user.png",
            userNickname: recentTalkUser.nickname,
            isChecked: false)));

    setBusy(false);
  }

//친구 로드 함수
  void loadFriendUsers() async {
    setBusy(true);
    List<Friend> friendUserResult =
        await _friendService.fetchAcceptedTypeFriends();

    _friendUsers.addAll(friendUserResult.map((friendUser) => UserPresentation(
        loginId: friendUser.loginId,
        userImageUrl:
            friendUser.imageUrl ?? "assets/images/user/general_user.png",
        userNickname: friendUser.nickname,
        isChecked: false)));
    setBusy(false);
  }

//변수 초기화
  void initializeField() {
    _titleController.clear();
    _selectedCategories.clear();
    _collegeOnlyChecked = false;
    _majorOnlyChecked = false;
    _members.clear();
    for (UserPresentation friendUser in _friendUsers) {
      friendUser.isChecked = false;
    }
    for (UserPresentation recentTalkUser in _recentTalkUsers) {
      recentTalkUser.isChecked = false;
    }
    notifyListeners();
  }

//대화방 타입 설정
  void setPublicVoiceRoom() {
    _type = VoiceRoomType.PUBLIC;
  }

  void setPrivateVoiceRoom() {
    _type = VoiceRoomType.PRIVATE;
  }

//카테고리 설정(수정중)
  void setCategory(BuildContext context) {
    _categories.clear();
    _categories = selectCategoryDialog(context);

    _selectedCategories.addAll(_categories.map((category) =>
        CategoryPresentation(
            title: _categories
                .map((category) =>
                    CategoryData.iconOf(category.name) +
                    " " +
                    CategoryData.korNameOf(category.name))
                .toList())));

    for (Category category in _categories) {
      _categoryResult.add(category.name);
    }

    notifyListeners();
  }

//같은 학교만 만나기
  void setCollegeOption(bool value) {
    _collegeOnlyChecked = value;
    notifyListeners();
  }

//같은 학과만 만나기
  void setMajorOption(bool value) {
    _majorOnlyChecked = value;
    notifyListeners();
  }

  //최근 대화친구 검색
  void searchRecentTalkUsers() {
    List<String> userNames = [];
    for (UserPresentation user in _recentTalkUsers) {
      userNames.add(user.userNickname);
    }
    _searchedRecentUsers = _recentTalkUsers.where((user) {
      return user.userNickname.startsWith(_recentTalkSearchController.text);
    }).toList();

    notifyListeners();
  }

//친구 검색
  void searchFriendUsers() {
    List<String> userNames = [];
    for (UserPresentation user in _friendUsers) {
      userNames.add(user.userNickname);
    }
    _searchedFriendUsers = _friendUsers.where((user) {
      return user.userNickname.startsWith(_friendSearchController.text);
    }).toList();

    notifyListeners();
  }

//대화친구설정
  void setMembers(UserPresentation user, bool value, String loginId) {
    user.isChecked = value;
    user.isChecked ? _members.add(loginId) : _members.remove(loginId);

    notifyListeners();
  }

  //검색텍스트필드 clear
  void clearSearchTextField(TextEditingController controller) {
    controller.clear();
    notifyListeners();
  }

//대화방 만들기

  Future<VoiceRoom> createVoiceRoom() async {
    VoiceRoom voiceRoom = await _voiceService.createVoiceRoom(
        title: titleController.text); //일단은 서버에 title만 보냄
    return voiceRoom;
    // final createVoiceRoomJson = jsonEncode({
    //   "title": titleController.text,
    //   "collegeOnly": _collegeOnlyChecked,
    //   "majorOnly": _majorOnlyChecked,
    //   "categories": _categoryResult,
    //   "type": _type.name,
    //   "members": _members,
    // });
  }
}

class UserPresentation {
  final String loginId;
  final String userImageUrl;
  final String userNickname;
  bool isChecked;

  UserPresentation(
      {required this.loginId,
      required this.userImageUrl,
      required this.userNickname,
      required this.isChecked});
}

class CategoryPresentation {
  dynamic title;
  CategoryPresentation({required this.title});
}
