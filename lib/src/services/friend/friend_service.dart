import 'package:zamongcampus/src/business_logic/models/friend.dart';

abstract class FriendService {
  Future<List<Friend>> fetchFriends();
  Future<Friend> fetchFriend(int friendId);
  Future<List<Friend>> fetchAcceptedTypeFriends();
}
