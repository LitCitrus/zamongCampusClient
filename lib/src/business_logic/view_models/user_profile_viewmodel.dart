import 'package:flutter/foundation.dart';
import 'package:zamongcampus/src/business_logic/models/friend.dart';
import 'package:zamongcampus/src/business_logic/models/user.dart';
import 'package:zamongcampus/src/business_logic/utils/college_data.dart';
import 'package:zamongcampus/src/business_logic/utils/major_data.dart';
import 'package:zamongcampus/src/business_logic/utils/methods.dart';
import 'package:zamongcampus/src/business_logic/view_models/base_model.dart';
import 'package:zamongcampus/src/business_logic/view_models/profile_viewmodel.dart';
import 'package:zamongcampus/src/config/dummy/interest_dummy.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/services/user/user_service.dart';

class UserProfileViewModel extends BaseModel {
  final UserService _userService = serviceLocator<UserService>();
  UserProfilePresentation _userProfile = defaultUserProfile;
  List<InterestPresentation> _interests = [];

  static final UserProfilePresentation
      defaultUserProfile = //UserProfilePresentation 초기값 설정
      UserProfilePresentation(
          loginId: '',
          nickname: '',
          imageUrl: 'assets/images/user/general_user.png',
          collegeName: '',
          isOnline: false,
          friendRequestStatus: FriendRequestStatus.NONE);

  UserProfilePresentation get userProfile => _userProfile;
  List<InterestPresentation> get interests => _interests;

  void loadUserProfile(String loginId) async {
    setBusy(true);
    await Future.delayed(const Duration(milliseconds: 300)); // 딜레이
    // 여기서에서 유저의 정보 더 가져올 것!
    User recommendUser =
        await _userService.fetchUserProfile(userLoginId: "test");
    _userProfile = UserProfilePresentation(
        loginId: recommendUser.loginId,
        nickname: recommendUser.nickname,
        imageUrl: recommendUser.imageUrls?.first ?? defaultUserProfile.imageUrl,
        collegeName: CollegeData.korNameOf(
            describeEnum(recommendUser.collegeCode ?? College.college0000)),
        majorName: MajorData.korNameOf(
            describeEnum(recommendUser.majorCode ?? Major.major0000)),
        introduction: recommendUser.introduction,
        friendRequestStatus: FriendRequestStatus.NONE);
    _interests = interestDummy;

    setBusy(false);
  }

// void loadInterests() async {
//     _interests = interestDummy;
//   }
  void requestFriend(String userId, String requestId) async {
    //userId: 친구신청 버튼을 누른 유저(본인)  requestId: 친구 신청 당하는 유저
    _userProfile.friendRequestStatus = FriendRequestStatus.UNACCEPTED;
    print(_userProfile.nickname + '님에게 친구를 요청합니다'); //테스트용
    toastMessage('친구 신청 완료!');
    notifyListeners();
  }
}

class UserProfilePresentation {
  final String loginId;
  final String nickname;
  final String imageUrl;
  final String collegeName;
  final String? majorName;
  final String? introduction;
  final bool? isOnline;
  FriendRequestStatus friendRequestStatus;

  UserProfilePresentation(
      {required this.loginId,
      required this.nickname,
      required this.imageUrl,
      required this.collegeName,
      this.majorName,
      this.introduction,
      this.isOnline,
      required this.friendRequestStatus});
}
