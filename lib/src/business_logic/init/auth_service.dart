import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/utils/methods.dart';
import 'package:zamongcampus/src/business_logic/view_models/chat_viewmodel.dart';
import 'package:zamongcampus/src/business_logic/view_models/voice_main_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/object/firebase_object.dart';
import 'package:zamongcampus/src/object/prefs_object.dart';
import 'package:zamongcampus/src/object/stomp_object.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

/// loginId와 token 값의 변화에 따라서 UI가 변경되는가?
/// 그렇지 않다면 ChangeNotifier를 뺴도 될 듯. (22.04.30)
class AuthService extends ChangeNotifier {
  static String? _loginId;
  static String? _token;

  bool get isLogined => _token?.isNotEmpty ?? false;
  static String? get loginId => _loginId;
  static String? get token => _token;

  /// login하면서 loginId(user)에 해당되는 데이터들 불러옴
  /// 1. token,loginId 값 넣기
  /// 2. 밀린 메시지 불러오고, 채팅방 초기화(+채팅방 불러오기)
  /// 3. 추천친구,추천대화방 load (이건 추후 변경할수도. 주석처리)
  static Future<void> setGlobalLoginIdTokenAndInitUserData(
      {required String token, required String loginId}) async {
    _loginId = loginId;
    _token = token;

    /// 아래 2개는 서버 킬 때만 사용 가능.
    // updateUserDeviceToken(); // 추후 삭제될 수도 있음.
    // await StompObject.connectStomp();

    /** 
      * initstate에서 load를 하는게 맞는지,
      * 아님 하단탭 누를 때마다 load하는게 맞는지. 
    VoiceMainScreenViewModel voicemainvm =
        serviceLocator<VoiceMainScreenViewModel>();
    voicemainvm.loadRecommendUsers();
    voicemainvm.loadVoiceRooms();
    */
  }

  static updateUserDeviceToken() async {
    final body = jsonEncode({"deviceToken": FirebaseObject.deviceFcmToken});
    try {
      final response = await http.post(
          Uri.parse(devServer + "/api/user/updateDeviceToken"),
          body: body,
          headers: AuthService.get_auth_header());
      if (response.statusCode == 200) {
        print("서버 user의 devicetoken 변경 완료");
      } else {
        print("실퍠: 서버 user의 devicetoken 변경 못함.");
      }
    } catch (e) {
      // 서버 꺼진 상태
      print("devicetoken변경: 서버 꺼진 상태");
    }
  }

  static Future<void> logout(BuildContext context) async {
    PrefsObject.removeLoginIdAndToken();
    StompObject.deactivateStomp();
    Navigator.pushReplacementNamed(context, "/login");
    toastMessage("로그아웃하셨습니다!");
  }

  static Map<String, String> get_auth_header() {
    return {
      "Content-Type": "application/json",
      "Authorization": _token!,
    };
  }

  @override
  String toString() {
    return 'AuthToken{loginId: $_loginId, token: $_token}';
  }
}
