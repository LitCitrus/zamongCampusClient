import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/models/chatMessage.dart';
import 'package:zamongcampus/src/business_logic/models/chatRoomMemberInfo.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/object/prefs_object.dart';
import 'package:zamongcampus/src/object/stomp_object.dart';
import 'package:zamongcampus/src/services/chat/chat_service.dart';
import 'package:zamongcampus/src/ui/views/chat/chat_main/components/chatTile.dart';

import '../models/chatMemberInfo.dart';
import '../models/chatRoom.dart';
import 'base_model.dart';

class ChatViewModel extends BaseModel {
  ChatService chatService = serviceLocator<ChatService>();
  List<ChatRoom> _chatRooms = [];
  String _insideRoomId = "";
  bool _fromFriendProfile = false;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  List<ChatRoom> get chatRooms => _chatRooms;
  String get insideRoomId => _insideRoomId;
  bool get fromFriendProfile => _fromFriendProfile;

  Future<void> loadChatRooms() async {
    _chatRooms = await chatService.getAllChatRoom();
    print("load chatroom 완료");
  }

  Future<bool> setChatRoomByNewMessages() async {
    print("setChatRoom 새로운 메세지들 저장하는 함수 시작");
    var chatBundle = await chatService.fetchUnReceivedMessages();
    // 기반 5월5일 => 서버에서는 무조건 5월5일 이후 값이 오게 되기에 상관없다.
    DateTime totalLastMsgCreatedAt = DateTime(2021, 5, 5);
    /* 1. 멤버 및 채팅방 정보 저장(modifiedInfos) */
    /* ENTER, EXIT, UPDATE, CREATE 다 저장. 따라서 없는 방도 저장하게 됨. + 구독까지 2-(1) 로직 참고 */
    if (chatBundle["modifiedInfos"].length != 0) {
      List<ChatMemberInfo> chatMemberInfos = List.empty(growable: true);
      List<ChatRoomMemberInfo> chatRoomMemberInfos = List.empty(growable: true);
      chatBundle["modifiedInfos"].forEach((modifiedInfo) {
        if (modifiedInfo["memberStatus"] == "ENTER") {
          /* 멤버 저장 */
          chatMemberInfos
              .add(ChatMemberInfo.fromJson(modifiedInfo["systemMessage"]));
          chatRoomMemberInfos.add(ChatRoomMemberInfo(
              roomId: modifiedInfo["systemMessage"]["roomId"],
              loginId: modifiedInfo["systemMessage"]["loginId"]));
        } else if (modifiedInfo["memberStatus"] == "EXIT") {
          /* 더이상 안 쓰는 멤버면 영구삭제 */
          chatService.deleteChatRoomMemberInfo(
              modifiedInfo["systemMessage"]["roomId"],
              modifiedInfo["systemMessage"]["loginId"]);
          chatService
              .isExistChatRoomMemberInfo(
                  modifiedInfo["systemMessage"]["loginId"])
              .then((value) => value
                  ? chatService.deleteMemberInfo(
                      modifiedInfo["systemMessage"]["loginId"])
                  : print("삭제 x"));
        } else if (modifiedInfo["memberStatus"] == "UPDATE") {
          /* 멤버 저장 */
          chatMemberInfos
              .add(ChatMemberInfo.fromJson(modifiedInfo["systemMessage"]));
        } else {
          /* 채팅방정보 저장 */
          if (getExistRoomIndex(
                  modifiedInfo["systemMessage"]["roomInfo"]["roomId"]) ==
              -1) {
            ChatRoom chatRoom = ChatRoom(
                roomId: modifiedInfo["systemMessage"]["roomInfo"]["roomId"],
                title: modifiedInfo["systemMessage"]["roomInfo"]["title"],
                type: modifiedInfo["systemMessage"]["roomInfo"]["type"],
                lastMessage: "대화를 시작해보세요!",
                lastMsgCreatedAt: DateTime(2021, 5, 5),
                imageUrl: modifiedInfo["systemMessage"]["roomInfo"]["imageUrl"],
                unreadCount: 0);
            chatService.insertChatRoom(chatRoom);
            StompObject.subscribeChatRoom(chatRoom.roomId);
          }

          /* chatMember, roomMember 저장 */
          modifiedInfo["systemMessage"]["memberInfos"].forEach((memberInfo) {
            chatMemberInfos.add(ChatMemberInfo.fromJson(memberInfo));
            chatRoomMemberInfos.add(ChatRoomMemberInfo(
                roomId: modifiedInfo["systemMessage"]["roomInfo"]["roomId"],
                loginId: memberInfo["loginId"]));
          });
        }
      });
      chatService.insertOrUpdateMemberInfo(chatMemberInfos);
      chatService.insertChatRoomMemberInfo(chatRoomMemberInfos);
    }
    /* 2. 메세지 저장(roomMessageBundles) */
    chatBundle["roomMessageBundles"].forEach((roomMessageBundle) {
      String lastMessage = "";
      DateTime lastMsgCreatedAt = DateTime(2021, 5, 5); // 5월5일 다음 메세지가 존재해서 변경됨
      int unreadCount = 0;

      /* 2-(1) 메세지들 저장 */
      roomMessageBundle["messages"].forEach((msg) {
        ChatMessage chatMessage = ChatMessage(
            roomId: roomMessageBundle["roomId"],
            loginId: msg["loginId"],
            text: msg["text"],
            type: MessageType.values.byName(msg['type']),
            createdAt: DateTime.parse(msg["createdAt"]));
        chatService.insertMessage(chatMessage);
        print("메시지내용: " + msg["text"] + " => 저장합니다");

        /* lastMsgCreatedAt, lastMessage 변경 */
        if (chatMessage.createdAt.isAfter(lastMsgCreatedAt)) {
          lastMsgCreatedAt = chatMessage.createdAt;
          lastMessage = msg["text"];
        }
        /* unreadCount + 1 , totalLastMsgCreatedAt 변경 */
        unreadCount++;
        totalLastMsgCreatedAt =
            chatMessage.createdAt.isAfter(totalLastMsgCreatedAt)
                ? chatMessage.createdAt
                : totalLastMsgCreatedAt;
      });
      /* 2-(2) chatRoom 정보 변경(마지막메세지, 안읽은 메세지 수) */
      chatService.updateChatRoom(
          lastMsg: lastMessage,
          lastMsgCreatedAt: lastMsgCreatedAt,
          unreadCount: unreadCount,
          roomId: roomMessageBundle["roomId"]);
    });

    // 3. 마지막 totalLastMsgCreatedAt 변경 => 5월5일 기준과 동일하면 변경 x
    if (!totalLastMsgCreatedAt.isAtSameMomentAs(DateTime(2021, 5, 5))) {
      PrefsObject.setTotalLastMsgCreatedAt(
          totalLastMsgCreatedAt.toIso8601String());
    }
    return true;
  }

  int getExistRoomIndex(String roomId) {
    int len = chatRooms.length;
    int index = -1;
    for (int i = 0; i < len; i++) {
      if (chatRooms[i].roomId == roomId) {
        index = i;
        break;
      }
    }
    return index;
  }

  int removeItem(int index, String roomId) {
    final removeItem = chatRooms[index];
    int unreadCount = removeItem.unreadCount;
    chatRooms.removeAt(index);
    listKey.currentState?.removeItem(
        index,
        (context, animation) => ChatTile(
              chatRoom: removeItem,
              animation: animation,
              onClicked: () {},
              onDeleted: () {},
            ));
    print('삭제 안 쪽');
    return unreadCount;
  }

  // ui: insert
  void insertItem(ChatRoom newChatRoom) {
    const newIndex = 0;
    chatRooms.insert(newIndex, newChatRoom);
    if (listKey.currentState == null) {
      // 원래는 "!" 식이지만, 이 version에선 이렇게 null 처리.
      // additionChatRooms.add(newIndex);
      print("listkey가 null인데??");
    } else {
      listKey.currentState?.insertItem(newIndex);
    }
    print("insert 안 쪽");
  }

  void replaceItem(ChatRoom updatedChatRoom, int index) {
    /* insert 후 remove를 animate 없이 */
    setBusy(true);
    print('replace Item');
    chatRooms[index] = updatedChatRoom;
    print('replace 완료');
    setBusy(false);
  }

  void changeInsideRoomId(String value) {
    _insideRoomId = value;
  }

  void changeFromFriendProfile(bool value) {
    _fromFriendProfile = value;
  }

  void changeUnreadCountToZero(String roomId) {
    setBusy(true);
    int index = getExistRoomIndex(roomId);
    chatRooms[index].unreadCount = 0;
    setBusy(false);
  }
}
