import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/init/auth_service.dart';
import 'package:zamongcampus/src/business_logic/models/friend.dart';
import 'package:zamongcampus/src/business_logic/view_models/base_model.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/services/friend/friend_service.dart';

import '../models/enums/friendRequestStatus.dart';

class FriendListViewModel extends BaseModel {
  final FriendService _friendService = serviceLocator<FriendService>();

  final List<FriendPresentation> _friendsIReceived = List.empty(growable: true);
  final List<FriendPresentation> _friendsIRequestAndAceepted =
      List.empty(growable: true);

  List<FriendPresentation> _searchedFriends = List.empty(growable: true);
  final TextEditingController _friendSearchController = TextEditingController();

  List<FriendPresentation> get friendsIReceived => _friendsIReceived;
  List<FriendPresentation> get friendsIRequestAndAceepted =>
      _friendsIRequestAndAceepted;

  List<FriendPresentation> get searchedFriends => _searchedFriends;
  TextEditingController get friendSearchController => _friendSearchController;

  void loadFriends() async {
    setBusy(true);

    List<Friend> friendResults = await _friendService.fetchFriends();
    List<FriendPresentation> iRequestTemp = [];
    for (var friend in friendResults) {
      FriendPresentation friendPresentation = FriendPresentation(
          id: friend.id,
          loginId: friend.loginId,
          imageUrl: friend.imageUrl ?? "assets/images/user/general_user.png",
          nickname: friend.nickname,
          friendRequestStatus: friend.friendRequestStatus);

      /// unaccepted의 경우 2가지 케이스 존재
      /// 친구신청자가 나(자신)이면 iRequestTemp에 더해놓은다음 나중에 뒤에 한번에 더해준다.
      /// 친구신청자(requestorLoginId)가 내가 아니면 내가받은친구요청리스트(friendsIReceived)
      if (friendPresentation.friendRequestStatus ==
          FriendRequestStatus.ACCEPTED) {
        friendsIRequestAndAceepted.add(friendPresentation);
      } else if (friendPresentation.friendRequestStatus ==
          FriendRequestStatus.UNACCEPTED) {
        if (friend.requestorLoginId == AuthService.loginId) {
          iRequestTemp.add(friendPresentation);
        } else {
          friendsIReceived.add(friendPresentation);
        }
      }
    }
    friendsIRequestAndAceepted.addAll(iRequestTemp);
    setBusy(false);
  }

  void approveRequest(FriendPresentation friendPresentation) async {
    //친구요청 수락
    _friendService.approveFriend(targetLoginId: friendPresentation.loginId);
    _friendsIReceived.remove(friendPresentation); // 이거하기 전에 서버랑 접촉 먼저
    friendPresentation.friendRequestStatus = FriendRequestStatus.ACCEPTED;
    friendsIRequestAndAceepted.add(friendPresentation);
    notifyListeners();
  }

  void refuseRequest(FriendPresentation friendPresentation) async {
    //친구요청 거절
    _friendService.refuseFriend(targetLoginId: friendPresentation.loginId);
    _friendsIReceived.remove(friendPresentation); // 이거하기 전에 서버랑 접촉 먼저
    notifyListeners();
  }

  void gotoChatroom(String loginId) {
    //대화하기
  }

  //친구 검색
  void searchFriends() {
    List<String> friendNames = [];
    for (FriendPresentation friend in _friendsIRequestAndAceepted) {
      friendNames.add(friend.nickname);
    }
    _searchedFriends = _friendsIRequestAndAceepted.where((friend) {
      return friend.nickname.startsWith(_friendSearchController.text);
    }).toList();

    notifyListeners();
  }

  //검색 필드 clear
  void clearSearchTextField(TextEditingController controller) {
    controller.clear();
    notifyListeners();
  }
}

class FriendPresentation {
  final int id;
  final String loginId;
  final String imageUrl;
  final String nickname;
  FriendRequestStatus friendRequestStatus;

  FriendPresentation(
      {required this.id,
      required this.loginId,
      required this.imageUrl,
      required this.nickname,
      required this.friendRequestStatus});
}
