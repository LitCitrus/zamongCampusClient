//screen끼리 인자와 함께 navigate 할 때, 인자를 생성자의 파라미터로 써야할 때 사용
/*
원래는 main.dart의 Material App()에서 다음과 같이 해야하는데 routes.dart처럼 따로 관리
onGenerateRoute: (settings) {
            if (settings.name == PostDetailScreen.routeName) {
              final args = settings.arguments as PostDetailScreenArgs;
              return MaterialPageRoute(builder: (context) {
                return PostDetailScreen(postId: args.postId);
              });
            }
          },

  */

import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/arguments/chat_detail_from_friendProfile_screen_args.dart';
import 'package:zamongcampus/src/business_logic/arguments/chat_detail_screen_args.dart';
import 'package:zamongcampus/src/business_logic/arguments/post_detail_screen_args.dart';
import 'package:zamongcampus/src/business_logic/arguments/voice_detail_screen_args.dart';
import 'package:zamongcampus/src/ui/views/chat/chat_detail/chat_detail_screen.dart';
import 'package:zamongcampus/src/ui/views/chat/chat_detail_from_friendProfile/chat_detail_from_friendProfile_screen.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/post_detail_screen.dart';
import 'package:zamongcampus/src/ui/views/voice/voice_detail/voice_detail_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/postDetail":
        final args = settings.arguments as PostDetailScreenArgs;
        return MaterialPageRoute(
            builder: (_) => PostDetailScreen(
                  postId: args.postId,
                  likedCount: args.likedCount,
                ));
      case "/voiceDetail":
        final args = settings.arguments as VoiceDetailScreenArgs;
        return MaterialPageRoute(
            builder: (_) => VoiceDetailScreen(voiceRoomId: args.voiceRoomId));
      case "/chatDetail":
        final args = settings.arguments as ChatDetailScreenArgs;
        return MaterialPageRoute(
            builder: (_) =>
                ChatDetailScreen(chatRoom: args.chatRoom, index: args.index));
      case "/chatDetailFromFriendProfile":
        final args =
            settings.arguments as ChatDetailFromFriendProfileScreenArgs;
        return MaterialPageRoute(
            builder: (_) => ChatDetailFromFriendProfileScreen(
                  profileLoginId: args.profileLoginId,
                ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              '자몽캠퍼스',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          body: const Center(
            child: Text("ERROR"),
          ));
    });
  }
}
