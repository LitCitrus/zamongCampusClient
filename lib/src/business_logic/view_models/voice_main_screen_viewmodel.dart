import 'package:flutter/foundation.dart';
import 'package:zamongcampus/src/business_logic/models/user.dart';
import 'package:zamongcampus/src/business_logic/models/voice_room.dart';
import 'package:zamongcampus/src/business_logic/utils/category_data.dart';
import 'package:zamongcampus/src/business_logic/utils/college_data.dart';
import 'package:zamongcampus/src/business_logic/utils/date_convert.dart';
import 'package:zamongcampus/src/business_logic/utils/major_data.dart';
import 'package:zamongcampus/src/business_logic/view_models/base_model.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/services/user/user_service.dart';
import 'package:zamongcampus/src/services/voice/voice_service.dart';

class VoiceMainScreenViewModel extends BaseModel {
  final VoiceService _voiceService = serviceLocator<VoiceService>();
  final UserService _userService = serviceLocator<UserService>();

  final List<VoiceRoomPresentation> _voiceRooms = [];
  final List<UserPresentation> _recommendUsers = [];
  int _nextPageToken = 0;

  List<VoiceRoomPresentation> get voiceRooms => _voiceRooms;
  List<UserPresentation> get recommendUsers => _recommendUsers;

  void loadVoiceRooms() async {
    setBusy(true);
    await Future.delayed(const Duration(milliseconds: 500)); // 0.5초 딜레이
    List<VoiceRoom> voiceRoomsResult =
        await _voiceService.fetchVoiceRooms(nextPageToken: _nextPageToken);
    _voiceRooms.addAll(voiceRoomsResult.map((voiceRoom) =>
        VoiceRoomPresentation(
            id: voiceRoom.voiceRoomAndTokenInfo.id,
            title: voiceRoom.voiceRoomAndTokenInfo.title,
            membersImgUrl: voiceRoom.membersInfo
                .map((member) =>
                    member.imageUrl ?? "assets/images/user/general_user.png")
                .toList(),
            categories: voiceRoom.categories!
                .map((category) =>
                    CategoryData.iconOf(category.name) +
                    " " +
                    CategoryData.korNameOf(category.name))
                .toList(),
            createdAt: dateToPastTime(voiceRoom.createdAt))));

    _nextPageToken++;
    setBusy(false);
  }

  void loadRecommendUsers() async {
    setBusy(true);
    await Future.delayed(const Duration(milliseconds: 500)); // 0.5초 딜레이
    List<User> userResult =
        await _userService.fetchRecommendUsers(nextPageToken: _nextPageToken);
    recommendUsers.addAll(userResult.map((user) => UserPresentation(
        loginId: user.loginId,
        imageUrl: user.imageUrl ?? "assets/images/user/general_user.png",
        collegeName: CollegeData.korNameOf(
            describeEnum(user.collegeCode ?? College.college0000)),
        majorName: MajorData.korNameOf(
            describeEnum(user.majorCode ?? Major.major0000)),
        isOnline: user.isOnline ?? false)));
    _nextPageToken++;
    setBusy(false);
  }
}

class VoiceRoomPresentation {
  final int id;
  final String title;
  final List<dynamic> membersImgUrl;
  final List<dynamic> categories;
  String createdAt;

  VoiceRoomPresentation(
      {required this.id,
      required this.title,
      required this.membersImgUrl,
      required this.categories,
      required this.createdAt});
}

class UserPresentation {
  String loginId;
  String imageUrl;
  String collegeName;
  String majorName;
  bool isOnline;

  UserPresentation(
      {required this.loginId,
      required this.imageUrl,
      required this.collegeName,
      required this.majorName,
      required this.isOnline});
}
