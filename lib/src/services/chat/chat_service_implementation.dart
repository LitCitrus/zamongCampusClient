import 'package:zamongcampus/src/business_logic/init/auth_service.dart';
import 'package:zamongcampus/src/business_logic/models/chatMessage.dart';
import 'package:zamongcampus/src/business_logic/models/chatRoomMemberInfo.dart';
import 'package:zamongcampus/src/business_logic/models/chatRoom.dart';
import 'package:zamongcampus/src/business_logic/models/chatMemberInfo.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/object/prefs_object.dart';
import 'package:zamongcampus/src/services/chat/chat_service.dart';
import 'package:http/http.dart' as http;
import 'package:zamongcampus/src/services/chat/sqflite/chatMemberInfo_db_helper.dart';
import 'dart:convert';

import 'package:zamongcampus/src/services/chat/sqflite/chatMessage_db_helper.dart';
import 'package:zamongcampus/src/services/chat/sqflite/chatRoom_db_helper.dart';
import 'package:zamongcampus/src/services/chat/sqflite/chatRoom_memberInfo_db_helper.dart';

class ChatServiceImpl implements ChatService {
  ChatMessageDBHelper chatMessageDBHelper = ChatMessageDBHelper();
  ChatRoomDBHelper chatRoomDBHelper = ChatRoomDBHelper();
  ChatRoomMemberInfoDBHelper chatRoomMemberInfoDBHelper =
      ChatRoomMemberInfoDBHelper();
  ChatMemberInfoDBHelper chatMemberInfoDBHelper = ChatMemberInfoDBHelper();

  @override
  createOrGetChatRoom({required String otherLoginId}) async {
    final jsonBody = jsonEncode({"otherLoginId": otherLoginId});
    final response = await http.post(Uri.parse(devServer + "/api/chat/room"),
        body: jsonBody, headers: AuthService.get_auth_header());
    if (response.statusCode == 201) {
      var res = await jsonDecode(utf8.decode(response.bodyBytes));
      // ChatRoom, MemberInfo, ChatRoomMemberInfo 3가지 만들어서 보내자.
      return res;
    } else {
      throw Exception();
    }
  }

  @override
  Future<bool> sendMessage(String roomId, String loginId, String text,
      String type, String title, String chatRoomType) async {
    String sendMessageJson = json.encode({
      "subject": "zamongcampus",
      "content": text,
      "data": {
        "roomId": roomId,
        "loginId": loginId,
        "text": text,
        "type": type,
        "chatRoomType": chatRoomType
      },
    });
    final response = await http.post(
        Uri(path: devServer + "/send-notification"),
        headers: {"Content-Type": "application/json"},
        body: sendMessageJson);
    if (response.statusCode == 200) {
      print("Respond: ${response.body.toString()}");
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<dynamic> fetchUnReceivedMessages() async {
    String totalLastMsgCreatedAt =
        await PrefsObject.getTotalLastMsgCreatedAt() ??
            DateTime(2021, 5, 5).toIso8601String();
    String loginId = AuthService.loginId ?? "";
    print("totalLastMsgCreatedAt 날짜; " + totalLastMsgCreatedAt);
    print("loginId: " + loginId);
    final response = await http.get(
        Uri.parse(devServer +
            "/api/chat/message?totalLastMsgCreatedAt=" +
            totalLastMsgCreatedAt),
        headers: AuthService.get_auth_header());
    if (response.statusCode == 200) {
      dynamic newMessages = jsonDecode(utf8.decode(response.bodyBytes));
      // 여기서 json으로 변경 해야해ㅐㅐㅐㅐㅐ!!
      print("fetchUnReceivedMessages!");
      return newMessages;
    } else {
      print("fetchChatrooms 서버 잘못된 경우");
      return {};
      // throw Exception('Failed to load chatRooms');
    }
  }

  // chatMessageDB 시작
  @override
  insertMessage(ChatMessage chatMessage) async {
    return await chatMessageDBHelper.insertMessage(chatMessage);
  }

  @override
  getMessages(String roomId, int page) async {
    return await chatMessageDBHelper.getMessages(roomId, page);
  }

  @override
  getAllChatMessage() async {
    return await chatMessageDBHelper.getAllChatMessage();
  }

  @override
  deleteMessageByRoomId(String roomId) async {
    chatMessageDBHelper.deleteMessageByRoomId(roomId);
  }

  @override
  deleteAllMessage() async {
    chatMessageDBHelper.deleteAllMessage();
  }
  // chatMessageDB 끝

  // chatRoomDB 시작
  @override
  insertChatRoom(ChatRoom chatRoom) async {
    return await chatRoomDBHelper.insertChatRoom(chatRoom);
  }

  @override
  getAllChatRoom() async {
    return await chatRoomDBHelper.getAllChatRooms();
  }

  @override
  getChatRoomsByMemberLoginId(String loginId) async {
    return await chatRoomDBHelper.getChatRoomsByMemberLoginId(loginId);
  }

  @override
  deleteChatRoomByRoomId(String roomId) {
    return chatRoomDBHelper.deleteChatRoomByRoomId(roomId);
  }

  @override
  deleteAllChatRoom() async {
    return chatRoomDBHelper.deleteAllChatRoom();
  }

  @override
  isExistRoom(String roomId) async {
    return await chatRoomDBHelper.isExistRoom(roomId);
  }

  @override
  updateChatRoom(
      {String? lastMsg,
      DateTime? lastMsgCreatedAt,
      int? unreadCount,
      String? roomId}) async {
    return await chatRoomDBHelper.updateChatRoom(
        lastMsg: lastMsg,
        lastMsgCreatedAt: lastMsgCreatedAt,
        unreadCount: unreadCount,
        roomId: roomId);
  }

  @override
  updateUnreadCount(int unreadCount, String roomId) async {
    return await chatRoomDBHelper.updateUnreadCount(unreadCount, roomId);
  }
  // chatRoomDB 끝

  // chatRoomMemberInfo 시작
  @override
  insertChatRoomMemberInfo(List<ChatRoomMemberInfo> chatRoomMemberInfos) async {
    return await chatRoomMemberInfoDBHelper
        .insertChatRoomMemberInfo(chatRoomMemberInfos);
  }

  @override
  insertChatRoomMemberInfoOne(ChatRoomMemberInfo chatRoomMemberInfo) async {
    return await chatRoomMemberInfoDBHelper
        .insertChatRoomMemberInfoOne(chatRoomMemberInfo);
  }

  @override
  deleteChatRoomMemberInfo(String roomId, String loginId) async {
    return await chatRoomMemberInfoDBHelper.deleteChatRoomMemberInfo(
        roomId, loginId);
  }

  @override
  deleteChatRoomMemberInfoByRoomId(String roomId) async {
    return await chatRoomMemberInfoDBHelper
        .deleteChatRoomMemberInfoByRoomId(roomId);
  }

  @override
  Future<bool> isExistChatRoomMemberInfo(String loginId) async {
    return await chatRoomMemberInfoDBHelper.isExistChatRoomMemberInfo(loginId);
  }

  @override
  getAllChatRoomMemberInfos() async {
    return await chatRoomMemberInfoDBHelper.getAllChatRoomMemberInfos();
  }

  @override
  deleteAllChatRoomMemberInfo() async {
    return await chatRoomMemberInfoDBHelper.deleteAllChatRoomMemberInfo();
  }
  // chatRoomMemberInfo 끝

  // chatMemberInfoDB 시작
  @override
  insertOrUpdateMemberInfo(List<ChatMemberInfo> chatMemberInfoes) async {
    return await chatMemberInfoDBHelper
        .insertOrUpdateMemberInfo(chatMemberInfoes);
  }

  @override
  insertOrUpdateMemberInfoOne(ChatMemberInfo chatMemberInfo) async {
    return await chatMemberInfoDBHelper
        .insertOrUpdateMemberInfoOne(chatMemberInfo);
  }

  @override
  getMemberInfoes(String roomId) async {
    return await chatMemberInfoDBHelper.getAllMemberInfoes();
  }

  @override
  getAllMemberInfoes() async {
    return await chatMemberInfoDBHelper.getAllMemberInfoes();
  }

  @override
  deleteMemberInfo(String loginId) async {
    return await chatMemberInfoDBHelper.deleteMemberInfo(loginId);
  }

  @override
  deleteAllMemberInfo() async {
    return await chatMemberInfoDBHelper.deleteAllMemberInfo();
  }

  // chatMemberInfoDB 끝
}
