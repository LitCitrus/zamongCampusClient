import 'package:zamongcampus/src/business_logic/utils/college_data.dart';
import 'package:zamongcampus/src/business_logic/utils/major_data.dart';

class Friend {
  final int id;
  final String loginId;
  final String nickname;
  final String requestorLoginId;
  final FriendRequestStatus friendRequestStatus;
  final String? imageUrl;
  final College? collegeCode;
  final Major? majorCode;
  final String? introduction;

  Friend(
      {required this.id,
      required this.loginId,
      required this.nickname,
      required this.requestorLoginId,
      required this.friendRequestStatus,
      this.imageUrl,
      this.collegeCode,
      this.majorCode,
      this.introduction});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
        id: json['id'],
        loginId: json['loginId'],
        nickname: json['nickname'],
        requestorLoginId: json['requestorLoginId'],
        friendRequestStatus: FriendRequestStatus.values.byName(json['status']),
        imageUrl: json['imageUrl'],
        collegeCode: json['collegeCode'] != null
            ? College.values.byName(json['collegeCode'])
            : null,
        majorCode: json['majorCode'] != null
            ? Major.values.byName(json['majorCode'])
            : null,
        introduction: json['introduction']);
  }
}

enum FriendRequestStatus {
  NONE,
  UNACCEPTED,
  ACCEPTED,
}
