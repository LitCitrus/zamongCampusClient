import 'package:zamongcampus/src/business_logic/models/interest.dart';
import 'package:zamongcampus/src/business_logic/utils/college_data.dart';
import 'package:zamongcampus/src/business_logic/utils/major_data.dart';

class User {
  final int? id;
  final String loginId;

  final String nickname;
  final String? imageUrl;
  //final String? studentNum;
  final College? collegeCode;
  final Major? majorCode;
  //final String? department;
  final String? name;
  final String? email;
  final String? deviceToken;
  final String? password;
  final bool? isOnline;
  final String? introduction;
  final List<Interest>? interests;

  const User(
      {this.id,
      required this.loginId,
      required this.nickname,
      this.imageUrl,
      this.collegeCode,
      this.majorCode,
      this.name,
      this.email,
      this.deviceToken,
      this.password,
      this.isOnline,
      this.introduction,
      this.interests});

  factory User.fromJosn(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        loginId: json['loginId'],
        nickname: json['nickname'],
        imageUrl: json['imageUrl'],
        collegeCode: json['collegeCode'],
        majorCode: json['majorCode'],
        name: json['name'],
        email: json['email'],
        deviceToken: json['deviceToken'],
        password: json['password'],
        isOnline: json['isOnline'],
        introduction: json['introduction'],
        interests: json['interests']);
  }
}
