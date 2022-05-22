import 'package:zamongcampus/src/business_logic/models/user.dart';
import 'package:zamongcampus/src/config/dummy_data.dart';
import 'package:zamongcampus/src/services/user/user_service.dart';

class FakeUserService implements UserService {
  @override
  Future<List<User>> fetchRecommendUsers({required int nextPageToken}) async {
    List<User> list = [];
    list.addAll(userDummy);
    return list;
  }

  @override
  Future<List<User>> fetchRecentTalkUsers() async {
    List<User> list = [];
    list.addAll(userDummy);
    return list;
  }

  @override
  Future<User> fetchUserProfile({required String userLoginId}) async {
    User userProfile;
    userProfile = userDummy.first;

    return userProfile;
  }
}
