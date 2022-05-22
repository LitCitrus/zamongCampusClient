import 'package:flutter/material.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/object/prefs_object.dart';
import 'package:zamongcampus/src/object/sqflite_object.dart';
import 'package:zamongcampus/src/services/chat/chat_service.dart';

import '../object/firebase_object.dart';

/// 삭제 예정 (채팅 테스트 용도)
class DummyScreen extends StatelessWidget {
  DummyScreen({Key? key}) : super(key: key);

  ChatService chatService = serviceLocator<ChatService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                var count = 0;
                await chatService.getAllChatRoom().then((chatrooms) => {
                      if (chatrooms.length == 0) print("참여한 방 없음"),
                      chatrooms.forEach((element) {
                        count++;
                        print("채팅방 출력 ${count} ==== " +
                            "roomId: ${element.roomId}, " +
                            "title: ${element.title}, " +
                            "type: ${element.type}, " +
                            "image: ${element.imageUrl}, " +
                            "lastmsg: ${element.lastMessage}, " +
                            "lastmsgcreatedat: ${element.lastMsgCreatedAt.toIso8601String()}, " +
                            "unreadCount: ${element.unreadCount.toString()}, ");
                      })
                    });
              },
              child: Text("chatroom 리스트 출력"),
            ),
            TextButton(
              onPressed: () async {
                chatService.deleteAllChatRoom();
              },
              child: Text("chatroom 리스트 삭제"),
            ),
            TextButton(
              onPressed: () async {
                var count = 0;
                await chatService.getAllChatMessage().then((msgs) => {
                      if (msgs.length == 0) print("메시지 없음"),
                      msgs.forEach((element) {
                        count++;
                        print("메시지 출력 ${count}==== " +
                            "roomId: ${element.roomId}, " +
                            "loginId: ${element.loginId}, " +
                            "text: ${element.text}, " +
                            "type: ${element.type}" +
                            "createdAt : ${element.createdAt.toIso8601String()}");
                      })
                    });
              },
              child: Text("chatmsg 리스트 출력"),
            ),
            TextButton(
              onPressed: () {
                chatService.deleteAllMessage();
              },
              child: Text("chatmsg 리스트 삭제"),
            ),
            TextButton(
              onPressed: () async {
                var count = 0;
                await chatService.getAllMemberInfoes().then((memberInfos) => {
                      if (memberInfos.length == 0) print("멤버 없음"),
                      memberInfos.forEach((element) {
                        count++;
                        print("멤버 출력 ${count}==== " +
                            // "roomId: ${element.roomId}, " +
                            "loginId: ${element.loginId}, " +
                            "nickname: ${element.nickname}, " +
                            "imageUrl: ${element.imageUrl}");
                      })
                    });
              },
              child: Text("memberinfo 리스트 출력"),
            ),
            TextButton(
              onPressed: () {
                chatService.deleteAllMemberInfo();
              },
              child: Text("memberinfo 리스트 삭제"),
            ),
            TextButton(
              onPressed: () async {
                var count = 0;
                await chatService
                    .getAllChatRoomMemberInfos()
                    .then((memberInfos) => {
                          if (memberInfos.length == 0) print("멤버 없음"),
                          memberInfos.forEach((element) {
                            count++;
                            print("멤버 출력 ${count}==== " +
                                // "roomId: ${element.roomId}, " +
                                "loginId: ${element.loginId}, " +
                                "nickname: ${element.roomId}, ");
                          })
                        });
              },
              child: Text("roomMemberinfo 리스트 출력"),
            ),
            TextButton(
              onPressed: () {
                chatService.deleteAllChatRoomMemberInfo();
              },
              child: Text("roomMemberinfo 리스트 삭제"),
            ),
            TextButton(
              onPressed: () async {
                print(await PrefsObject.getTotalLastMsgCreatedAt());
              },
              child: Text("totalLastMsgCreatedAt 출력"),
            ),
            TextButton(
              onPressed: () {
                PrefsObject.setTotalLastMsgCreatedAt(
                    DateTime(2021, 05, 05).toIso8601String());
              },
              child: Text("totalLastMsgCreatedAt 삭제"),
            ),
            TextButton(
              onPressed: () {
                SqfliteObject.dropTableIfExistsThenReCreate();
              },
              child: Text("db 삭제하고 다시 만들기"),
            ),
            TextButton(
              onPressed: () async {
                print(await PrefsObject.getToken());
              },
              child: Text("print token"),
            ),
            TextButton(
              onPressed: () {
                print(FirebaseObject.deviceFcmToken);
              },
              child: Text("print deviceFcmToken"),
            ),
          ],
        ),
      ),
    );
  }
}
