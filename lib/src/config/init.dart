import 'dart:io';

import 'package:zamongcampus/src/business_logic/init/auth_service.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/object/firebase_object.dart';
import 'package:zamongcampus/src/object/prefs_object.dart';
import 'package:zamongcampus/src/object/sqflite_object.dart';
import 'package:zamongcampus/src/object/stomp_object.dart';
import 'package:http/http.dart' as http;

/**
 * config init하는 함수
 * prefs, sqflite, firebase
 */
class Init {
  static Future<String> initialize() async {
    // 여기서는 순서대로 하는 것이 맞다. 그래서 async await 개념으로 해야함. 그 안의 함수들도 다.
    await PrefsObject.init();
    await SqfliteObject.database;
    await FirebaseObject.init();
    String? loginId = await PrefsObject.getLoginId();
    String? token = await PrefsObject.getToken();
    // if (loginId == null || token == null) {
    //   return "/login";
    // } else {
    //   /// 여기 logic
    //   // token의 validation 확인
    //   // 이상 없으면 "/"
    //   // 아니면 loginId, token 삭제 후 "login"으로.
    //   try {
    //     final response = await http.post(
    //         Uri.parse(devServer + "/api/authenticate/checkTokenValidation"),
    //         headers: {
    //           "Content-Type": "application/json",
    //           "Authorization": token,
    //         });
    //     if (response.statusCode == 200) {
    //       AuthService.setGlobalLoginIdTokenAndInitUserData(
    //           token: token, loginId: loginId);
    //       return "/";
    //     } else {
    //       // 지우고, return 재로그인
    //       PrefsObject.removeLoginIdAndToken();
    //       return "/login";
    //     }
    //   } catch (error) {
    //     print(error);
    //     // 서버 꺼진 상태
    //     print("서버 꺼진 상태");
    //     PrefsObject.removeLoginIdAndToken();
    //     return "/login";
    //   }
    // }
    print("서버 꺼진 상태");
    PrefsObject.removeLoginIdAndToken();
    return "/login";
  }
}
