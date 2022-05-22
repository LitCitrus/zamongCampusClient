import 'dart:convert';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:zamongcampus/src/business_logic/init/auth_service.dart';
import 'package:zamongcampus/src/business_logic/models/chatMemberInfo.dart';
import 'package:zamongcampus/src/business_logic/models/chatMessage.dart';
import 'package:zamongcampus/src/business_logic/models/chatRoom.dart';
import 'package:zamongcampus/src/business_logic/models/chatRoomMemberInfo.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/chat_detail_from_friendProfile_viewmodel.dart';
import 'package:zamongcampus/src/business_logic/view_models/chat_detail_viewmodel.dart';
import 'package:zamongcampus/src/business_logic/view_models/chat_viewmodel.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/object/firebase_object.dart';
import 'package:zamongcampus/src/object/prefs_object.dart';
import 'package:zamongcampus/src/services/chat/chat_service.dart';

class StompObject {
  static late StompClient _stompClient;

  static StompClient get stompClient => _stompClient;

  static connectStomp() {
    print("stomp init start");
    _stompClient = StompClient(
      config: StompConfig.SockJS(
        url: devServer + '/ws-stomp',
        onConnect: _onConnect,
        beforeConnect: () async {
          print('stomp 연결 중 ...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: AuthService.get_auth_header(),
        webSocketConnectHeaders: AuthService.get_auth_header(),
      ),
    );
    _stompClient.activate(); // 서버 실행
    _stompClient = _stompClient; // stompClient 초기화
  }

  // connect 성공
  static dynamic _onConnect(StompFrame frame) async {
    print('stomp 연결 완료');
    if (AuthService.loginId != null && AuthService.token != null) {
      /// 1. 채팅방 불러오고
      /// 2. 이미 존재한 방들 구독
      /// 3. 내 token에 해당되는 방 구독
      /// 4. 밀린 메세지 불러와서 재세팅
      /// 5. 다시 채팅방 불러오기
      ChatViewModel chatViewModel = serviceLocator<ChatViewModel>();
      await chatViewModel.loadChatRooms();
      for (ChatRoom chatRoom in chatViewModel.chatRooms) {
        subscribeChatRoom(chatRoom.roomId);
      }
      subscribeChatRoom(FirebaseObject.deviceFcmToken);
      await chatViewModel.setChatRoomByNewMessages();
      await chatViewModel.loadChatRooms();
    }
  }

  // roomId로 오는 메세지
  static void subscribeChatRoom(String? roomId) {
    ChatService _chatService = serviceLocator<ChatService>();
    ChatViewModel chatViewModel = serviceLocator<ChatViewModel>();

    ChatDetailViewModel chatDetailViewModel =
        serviceLocator<ChatDetailViewModel>();
    ChatDetailFromFriendProfileViewModel chatDetailFromFriendProfileViewModel =
        serviceLocator<ChatDetailFromFriendProfileViewModel>();
    stompClient.subscribe(
      headers: AuthService.get_auth_header(),
      destination: '/sub/chat/room/$roomId',
      callback: (frame) {
        // ** 메시지 도착 시점
        print("----- 새로운 메세지 도착 -----");
        var res = json.decode(frame.body ?? "");

        if (res["type"] == "talk") {
          /***** TALK ******/
          ChatMessage chatMessage =
              ChatMessage.fromJsonRoomId(res["messageDto"], res["roomId"]);
          // 1. 메세지 저장
          _chatService.insertMessage(chatMessage);
          // 2. local db의 chatroom 내용 변경 => 이미 그 방 안이면 0, 아니면 1 추가
          _chatService.updateChatRoom(
              lastMsg: chatMessage.text,
              lastMsgCreatedAt: chatMessage.createdAt,
              unreadCount:
                  chatMessage.roomId == chatViewModel.insideRoomId ? 0 : 1,
              roomId: chatMessage.roomId);

          // 3. pref에 최근 메시지 시간 저장할 것
          PrefsObject.setTotalLastMsgCreatedAt(
              chatMessage.createdAt.toIso8601String());

          // UI: 현재 위치가 해당방이면 ui 수정(chatdetail)
          if (chatMessage.roomId == chatViewModel.insideRoomId) {
            if (chatViewModel.fromFriendProfile) {
              chatDetailFromFriendProfileViewModel.addChatMessage(chatMessage);
            } else {
              chatDetailViewModel.addChatMessage(chatMessage);
            }
          }
          // ** UI(chatsScreen) 변경
          int index = chatViewModel.getExistRoomIndex(chatMessage.roomId!);
          ChatRoom chatRoom = chatViewModel.chatRooms[index];
          if (index == 0) {
            // 최상단 : 업데이트만 => lastmsg, unreadcount, lastMsgCreatedAt
            chatRoom.lastMessage = chatMessage.text;
            chatRoom.lastMsgCreatedAt = chatMessage.createdAt;
            // 해당 방 안에 아닐 때만 unreadcount 변경
            if (chatMessage.roomId != chatViewModel.insideRoomId) {
              chatRoom.unreadCount = chatRoom.unreadCount + 1;
            }
            chatViewModel.replaceItem(chatRoom, index);
          } else {
            // 최상단 아니면 => 1. 기존 방: 방 지웠다가 새롭게 방 추가  2. 완전 처음 방: 새롭게 방만 추가

            if (index != -1) {
              // 기존에 있는 방: unreadCount, lastMsg, lastMsgCreatedAt 변경
              // 현재 그 방 안이라면 0으로 값 변경
              // 아니면 삭제(removeItem)하면서 unreadcount 반환 (그 값으로 변경)
              int unreadCount =
                  chatViewModel.removeItem(index, chatRoom.roomId);
              if (chatMessage.roomId == chatViewModel.insideRoomId) {
                chatRoom.unreadCount = 0;
              } else {
                chatRoom.unreadCount = unreadCount + 1;
              }
              chatRoom.lastMessage = chatMessage.text;
              chatRoom.lastMsgCreatedAt = chatMessage.createdAt;
            }
            chatViewModel.insertItem(chatRoom);
          }
        } else if (res["type"] == "enter") {
          /***** ENTER ******/
          /* 1. 메세지 저장 */
          ChatMessage chatMessage = ChatMessage(
              roomId: res["roomId"],
              loginId: "",
              text: res["body"],
              type: MessageType.ENTER,
              createdAt: DateTime.parse(res["createdAt"]));
          _chatService.insertMessage(chatMessage);

          /* 2. 멤버 저장 */
          ChatMemberInfo chatMemberInfo = ChatMemberInfo.fromJson(res);
          ChatRoomMemberInfo chatRoomMemberInfo = ChatRoomMemberInfo(
              roomId: res["roomId"], loginId: res["loginId"]);
          _chatService.insertOrUpdateMemberInfoOne(chatMemberInfo);
          _chatService.insertChatRoomMemberInfoOne(chatRoomMemberInfo);

          /* 3. 현재 위치가 해당방이면 ui 수정(chatdetail) */
          if (chatMessage.roomId == chatViewModel.insideRoomId) {
            if (chatViewModel.fromFriendProfile) {
              chatDetailFromFriendProfileViewModel.addChatMessage(chatMessage);
            } else {
              chatDetailViewModel.addChatMessage(chatMessage);
            }
          }

          /* 4. pref에 최근 메시지 시간 저장할 것 */
          PrefsObject.setTotalLastMsgCreatedAt(
              chatMessage.createdAt.toIso8601String());
        } else if (res["type"] == "exit") {
          /***** EXIT ******/
          /* 1. 메세지 저장 */
          ChatMessage chatMessage = ChatMessage(
              roomId: res["roomId"],
              loginId: "",
              text: res["body"],
              type: MessageType.EXIT,
              createdAt: DateTime.parse(res["createdAt"]));
          _chatService.insertMessage(chatMessage);

          /* 2. 멤버 삭제 */
          _chatService.deleteChatRoomMemberInfo(res["roomId"], res["loginId"]);
          if (_chatService.isExistChatRoomMemberInfo(res["loginId"])) {
            _chatService.deleteMemberInfo(res["loginId"]);
          }

          /* 3. 현재 위치가 해당방이면 ui 수정(chatdetail) */
          if (chatMessage.roomId == chatViewModel.insideRoomId) {
            if (chatViewModel.fromFriendProfile) {
              chatDetailFromFriendProfileViewModel.addChatMessage(chatMessage);
            } else {
              chatDetailViewModel.addChatMessage(chatMessage);
            }
          }

          /* 4. pref에 최근 메시지 시간 저장할 것 */
          PrefsObject.setTotalLastMsgCreatedAt(
              chatMessage.createdAt.toIso8601String());
        } else if (res["type"] == "update") {
          /***** UPDATE ******/
          /* 1. 멤버 수정 */
          ChatMemberInfo chatMemberInfo = ChatMemberInfo.fromJson(res);
          _chatService.insertOrUpdateMemberInfoOne(chatMemberInfo);

          /* 2. UI 수정 */
          _changeMemberInfo(chatMemberInfo);
        } else {
          /***** CREATE ******/
          /* 1. 채팅방정보 저장 및 구독 */
          ChatRoom chatRoom = ChatRoom(
              roomId: res["roomInfo"]["roomId"],
              title: res["roomInfo"]["title"],
              type: res["roomInfo"]["type"],
              lastMessage: "대화를 시작해보세요!",
              lastMsgCreatedAt: DateTime(2021, 5, 5),
              imageUrl: res["roomInfo"]["imageUrl"],
              unreadCount: 0);
          _chatService.insertChatRoom(chatRoom);
          subscribeChatRoom(chatRoom.roomId);

          /* 2. 멤버 저장 */
          res["memberInfos"].forEach((memberInfo) {
            ChatMemberInfo chatMemberInfo = ChatMemberInfo.fromJson(memberInfo);
            ChatRoomMemberInfo chatRoomMemberInfo = ChatRoomMemberInfo(
                roomId: chatRoom.roomId, loginId: memberInfo["loginId"]);
            _chatService.insertOrUpdateMemberInfoOne(chatMemberInfo);
            _chatService.insertChatRoomMemberInfoOne(chatRoomMemberInfo);
          });

          // /* 3. chatsScreen 수정 */
          chatViewModel.insertItem(chatRoom);
        }
      },
    );
    print('구독성공: $roomId번 방 ');
  }

  static void deactivateStomp() {
    /// stomp 연결 제거하기 -> 로그아웃 시 활용
    stompClient.deactivate();
  }

  static void sendMessage(
      String roomId, String text, String type, String chatRoomType) {
    print("-----메세지 전송 => 내용: $text, 방번호: ${roomId}");
    stompClient.send(
        destination: '/pub/chat/message',
        body: json.encode({
          'roomId': roomId,
          'loginId': AuthService.loginId,
          'text': text,
          "type": type,
          "chatRoomType": chatRoomType,
        }),
        headers: AuthService.get_auth_header());
  }

  static void _changeMemberInfo(ChatMemberInfo chatMemberInfo) async {
    /* 2. 채팅방 내외부 이미지 및 nickname 변경해줘야함.*/
    // 2-1. chatdetail의 멤버 정보 변경
    // - loginId로 해당 loginId를 가진 모든 채팅방 찾고,
    // - 그 채팅방과 homecontroller의 roomid와 같으면 그 방 안에 있기에 멤버 변경
    // 2-2. chatsScreen의 imageurl 및 닉네임 변경
    // - 채팅방들 중 1:1인 방이 있다면(type =="single"), chatsScreen의 imageUrl, title 변경
    ChatService _chatService = serviceLocator<ChatService>();
    ChatViewModel chatViewModel = serviceLocator<ChatViewModel>();
    ChatDetailViewModel chatDetailViewModel =
        serviceLocator<ChatDetailViewModel>();
    ChatDetailFromFriendProfileViewModel chatDetailFromFriendProfileViewModel =
        serviceLocator<ChatDetailFromFriendProfileViewModel>();
    List<ChatRoom> chatRooms =
        await _chatService.getChatRoomsByMemberLoginId(chatMemberInfo.loginId);

    chatRooms.forEach((chatRoom) {
      if (chatRoom.roomId == chatViewModel.insideRoomId) {
        if (chatViewModel.fromFriendProfile) {
          chatDetailFromFriendProfileViewModel.changeMember(chatMemberInfo);
        } else {
          chatDetailViewModel.changeMember(chatMemberInfo);
        }
      }
      if (chatRoom.type == "single") {
        chatRoom.title = chatMemberInfo.nickname;
        chatRoom.imageUrl = chatMemberInfo.imageUrl;
        int index = chatViewModel.getExistRoomIndex(chatRoom.roomId);
        chatViewModel.replaceItem(chatRoom, index);
      }
    });
  }
}
