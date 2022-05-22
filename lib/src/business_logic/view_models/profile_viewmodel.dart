import 'package:flutter/foundation.dart';
import 'package:zamongcampus/src/business_logic/models/friend.dart';
import 'package:zamongcampus/src/business_logic/models/interest.dart';
import 'package:zamongcampus/src/business_logic/utils/college_data.dart';
import 'package:zamongcampus/src/business_logic/utils/interest_data.dart';
import 'package:zamongcampus/src/business_logic/utils/major_data.dart';
import 'package:zamongcampus/src/business_logic/utils/methods.dart';
import 'package:zamongcampus/src/business_logic/view_models/base_model.dart';
import 'package:zamongcampus/src/config/dummy/interest_dummy.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/services/friend/friend_service.dart';

class ProfileViewModel extends BaseModel {
  final FriendService _friendService = serviceLocator<FriendService>();

  ProfilePresentation _profile = defaultProfile;
  List<InterestPresentation> _interests = [];

  static final ProfilePresentation defaultProfile = //ProfilePresentation 초기값 설정
      ProfilePresentation(
          loginId: '',
          nickname: '',
          imageUrl: 'assets/images/user/general_user.png',
          collegeName: '',
          isOnline: false,
          friendRequestStatus: FriendRequestStatus.NONE);

  ProfilePresentation get profile => _profile;
  List<InterestPresentation> get interests => _interests;

  void loadProfile(int friendId) async {
    setBusy(true);
    // await Future.delayed(const Duration(milliseconds: 300)); // 딜레이
    // 여기서에서 유저의 정보 더 가져올 것!
    Friend friend = await _friendService.fetchFriend(friendId);
    _profile = ProfilePresentation(
        loginId: friend.loginId,
        nickname: friend.nickname,
        imageUrl: friend.imageUrl ?? defaultProfile.imageUrl,
        collegeName: CollegeData.korNameOf(
            describeEnum(friend.collegeCode ?? College.college0000)),
        majorName: MajorData.korNameOf(
            describeEnum(friend.majorCode ?? Major.major0000)),
        introduction: friend.introduction,
        friendRequestStatus: friend.friendRequestStatus);
    _interests = interestDummy;

    // _interests= userProfileResult.interests.map((interest)=> )
    /// 전체 관심사 수 만큼 map돌려서 status 지정 상대방과 내가 모두 가지고 있는 관심사는 same, 상대방은 있는데 나는 없으면 different 그외는 none
    setBusy(false);
  }

  void requestFriend(String userId, String requestId) async {
    //userId: 친구신청 버튼을 누른 유저(본인)  requestId: 친구 신청 당하는 유저
    _profile.friendRequestStatus = FriendRequestStatus.UNACCEPTED;
    print(_profile.nickname + '님에게 친구를 요청합니다'); //테스트용
    toastMessage('친구 신청 완료!');
    notifyListeners();
  }
}

class ProfilePresentation {
  final String loginId;
  final String nickname;
  final String imageUrl;
  final String collegeName;
  final String? majorName;
  final String? introduction;
  final bool? isOnline;
  FriendRequestStatus friendRequestStatus;

  ProfilePresentation(
      {required this.loginId,
      required this.nickname,
      required this.imageUrl,
      required this.collegeName,
      this.majorName,
      this.introduction,
      this.isOnline,
      required this.friendRequestStatus});
}

/// user_profile과 일반 profile에서도 쓰임.
class InterestPresentation {
  final String title;
  final InterestStatus status;

  InterestPresentation({required this.title, required this.status});
}

enum InterestStatus { SAME, DIFFERENT, NONE }
