import 'package:zamongcampus/src/business_logic/models/chatRoomMemberInfo.dart';

import 'package:zamongcampus/src/business_logic/models/chatRoom.dart';

import 'package:zamongcampus/src/business_logic/models/chatMessage.dart';

import 'package:zamongcampus/src/business_logic/models/chatMemberInfo.dart';

import 'chat_service.dart';

class FakeChatService implements ChatService {
  @override
  createOrGetChatRoom({required String otherLoginId}) {
    // TODO: implement createChatRoom
    throw UnimplementedError();
  }

  @override
  sendMessage(String roomId, String loginId, String text, String type,
      String title, String chatRoomType) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  fetchUnReceivedMessages() {
    // TODO: implement fetchUnReceivedMessages
    throw UnimplementedError();
  }

  @override
  deleteAllChatRoom() {
    // TODO: implement deleteAllChatRoom
    throw UnimplementedError();
  }

  @override
  deleteAllChatRoomMemberInfo() {
    // TODO: implement deleteAllChatRoomMemberInfo
    throw UnimplementedError();
  }

  @override
  deleteAllMemberInfo() {
    // TODO: implement deleteAllMemberInfo
    throw UnimplementedError();
  }

  @override
  deleteAllMessage() {
    // TODO: implement deleteAllMessage
    throw UnimplementedError();
  }

  @override
  deleteChatRoomByRoomId(String roomId) {
    // TODO: implement deleteChatRoomByRoomId
    throw UnimplementedError();
  }

  @override
  deleteChatRoomMemberInfo(String roomId, String loginId) {
    // TODO: implement deleteChatRoomMemberInfo
    throw UnimplementedError();
  }

  @override
  deleteChatRoomMemberInfoByRoomId(String roomId) {
    // TODO: implement deleteChatRoomMemberInfoByRoomId
    throw UnimplementedError();
  }

  @override
  deleteMemberInfo(String loginId) {
    // TODO: implement deleteMemberInfo
    throw UnimplementedError();
  }

  @override
  deleteMessageByRoomId(String roomId) {
    // TODO: implement deleteMessageByRoomId
    throw UnimplementedError();
  }

  @override
  getAllChatMessage() {
    // TODO: implement getAllChatMessage
    throw UnimplementedError();
  }

  @override
  getAllChatRoom() {
    // TODO: implement getAllChatRoom
    throw UnimplementedError();
  }

  @override
  getAllChatRoomMemberInfos() {
    // TODO: implement getAllChatRoomMemberInfos
    throw UnimplementedError();
  }

  @override
  getAllMemberInfoes() {
    // TODO: implement getAllMemberInfoes
    throw UnimplementedError();
  }

  @override
  getChatRoomsByMemberLoginId(String loginId) {
    // TODO: implement getChatRoomsByMemberLoginId
    throw UnimplementedError();
  }

  @override
  getMemberInfoes(String roomId) {
    // TODO: implement getMemberInfoes
    throw UnimplementedError();
  }

  @override
  getMessages(String roomId, int page) {
    // TODO: implement getMessages
    throw UnimplementedError();
  }

  @override
  insertChatRoom(ChatRoom chatRoom) {
    // TODO: implement insertChatRoom
    throw UnimplementedError();
  }

  @override
  insertChatRoomMemberInfo(List<ChatRoomMemberInfo> chatRoomMemberInfos) {
    // TODO: implement insertChatRoomMemberInfo
    throw UnimplementedError();
  }

  @override
  insertChatRoomMemberInfoOne(ChatRoomMemberInfo chatRoomMemberInfo) {
    // TODO: implement insertChatRoomMemberInfoOne
    throw UnimplementedError();
  }

  @override
  insertMessage(ChatMessage chatMessage) {
    // TODO: implement insertMessage
    throw UnimplementedError();
  }

  @override
  insertOrUpdateMemberInfo(List<ChatMemberInfo> chatMemberInfoes) {
    // TODO: implement insertOrUpdateMemberInfo
    throw UnimplementedError();
  }

  @override
  insertOrUpdateMemberInfoOne(ChatMemberInfo chatMemberInfo) {
    // TODO: implement insertOrUpdateMemberInfoOne
    throw UnimplementedError();
  }

  @override
  Future<bool> isExistChatRoomMemberInfo(String loginId) {
    // TODO: implement isExistChatRoomMemberInfo
    throw UnimplementedError();
  }

  @override
  isExistRoom(String roomId) {
    // TODO: implement isExistRoom
    throw UnimplementedError();
  }

  @override
  updateChatRoom(
      {String? lastMsg,
      DateTime? lastMsgCreatedAt,
      int? unreadCount,
      String? roomId}) {
    // TODO: implement updateChatRoom
    throw UnimplementedError();
  }

  @override
  updateUnreadCount(int unreadCount, String roomId) {
    // TODO: implement updateUnreadCount
    throw UnimplementedError();
  }
}
