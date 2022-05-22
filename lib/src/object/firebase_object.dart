import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseObject {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? _deviceFcmToken;
  static String? get deviceFcmToken => _deviceFcmToken;

  static Future<void> init() async {
    print("firebase init start");
    _deviceFcmToken = await _getToken();
    await _initNotification();
    print("firebase init end");
  }

  static Future<String?> _getToken() async {
    try {
      String? token = await _messaging.getToken();
      // TODO: 여기에 vapidKey 필요. => 없어도 token를 가져오긴함.
      print(token);
      print("토큰 값 위치!");
      return token;
    } catch (e) {
      print("getToken error ");
    }
  }

  // getNotificationSettings, requestPermission 차이 확인할 것.
  static Future<void> _initNotification() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // print('User granted permission: ${settings.authorizationStatus}');

    /* 사용하고 있는 상태(Foreground messages) */
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // 눌렀을 떄 navigate하도록
      // 1. local message로 알림을 띄워야한다는 점.
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
