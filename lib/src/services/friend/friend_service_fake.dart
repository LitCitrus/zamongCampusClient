import 'package:zamongcampus/src/business_logic/models/friend.dart';
import 'package:zamongcampus/src/business_logic/utils/college_data.dart';
import 'package:zamongcampus/src/business_logic/utils/major_data.dart';
import 'package:zamongcampus/src/services/friend/friend_service.dart';

class FakeFriendService implements FriendService {
  @override
  Future<List<Friend>> fetchFriends() async {
    return friendDummy;
  }

  @override
  Future<List<Friend>> fetchAcceptedTypeFriends() {
    // TODO: implement fetchAcceptedTypeFriends
    throw UnimplementedError();
  }

  @override
  Future<Friend> fetchFriend(int friendId) async {
    // TODO: implement fetchFriend
    return friendDetailDummy;
  }
}

List<Friend> friendDummy = [
  /// 1. 내가 신청
  /// 2. 받아줌
  /// 3. 남이 신청
  Friend(
      id: 2,
      loginId: "hello",
      imageUrl: "assets/images/user/user3.jpg",
      nickname: "hello",
      friendRequestStatus: FriendRequestStatus.UNACCEPTED,
      requestorLoginId: 'test'),
  Friend(
      id: 1,
      loginId: "hello2",
      imageUrl: "assets/images/user/user1.jpg",
      nickname: "hello2",
      friendRequestStatus: FriendRequestStatus.ACCEPTED,
      requestorLoginId: 'test'),
  Friend(
      id: 3,
      loginId: "hello3",
      imageUrl: "assets/images/user/user4.jpg",
      nickname: "hello3",
      friendRequestStatus: FriendRequestStatus.UNACCEPTED,
      requestorLoginId: 'hello3'),
];

List<Friend> acceptedOnlyfriendDummy = [
  Friend(
      id: 1,
      loginId: "hello",
      imageUrl: "assets/images/user/user1.jpg",
      nickname: "hello",
      friendRequestStatus: FriendRequestStatus.ACCEPTED,
      requestorLoginId: 'hello'),
  Friend(
      id: 2,
      loginId: "hello2",
      imageUrl: "assets/images/user/user1.jpg",
      nickname: "hello2",
      friendRequestStatus: FriendRequestStatus.ACCEPTED,
      requestorLoginId: 'hello2'),
];

Friend friendDetailDummy = Friend(
    id: 2,
    loginId: "hello2",
    nickname: "hello2",
    friendRequestStatus: FriendRequestStatus.ACCEPTED,
    requestorLoginId: 'hello2',
    imageUrl: "assets/images/user/user1.jpg",
    collegeCode: College.college0001,
    majorCode: Major.major0001,
    introduction: "자기개발, 꾸준함, 성실한 사람 좋아해요\n저랑 잘 맞는 친구 찾구싶어요!");
