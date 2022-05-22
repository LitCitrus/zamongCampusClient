import 'package:zamongcampus/src/business_logic/models/chatMemberInfo.dart';
import 'package:zamongcampus/src/business_logic/models/chatMessage.dart';
import 'package:zamongcampus/src/business_logic/models/chatRoom.dart';
import 'package:zamongcampus/src/business_logic/models/chatRoomMemberInfo.dart';

abstract class ChatService {
  createOrGetChatRoom({required String otherLoginId}) {}
  sendMessage(String roomId, String loginId, String text, String type,
      String title, String chatRoomType) {}
  fetchUnReceivedMessages() {}

  // chatMessageDB 시작
  insertMessage(ChatMessage chatMessage) {}
  getMessages(String roomId, int page) {}
  getAllChatMessage() {}
  deleteMessageByRoomId(String roomId) {}
  deleteAllMessage() {}
  // chatMessageDB 끝

  // chatRoomDB 시작
  insertChatRoom(ChatRoom chatRoom) {}
  getAllChatRoom() async {}
  getChatRoomsByMemberLoginId(String loginId) async {}
  deleteChatRoomByRoomId(String roomId) {}
  deleteAllChatRoom() async {}
  isExistRoom(String roomId) {}
  updateChatRoom(
      {String? lastMsg,
      DateTime? lastMsgCreatedAt,
      int? unreadCount,
      String? roomId}) {}
  updateUnreadCount(int unreadCount, String roomId) {}
  // chatRoomDB 끝

  // chatRoomMemberInfo 시작
  insertChatRoomMemberInfo(List<ChatRoomMemberInfo> chatRoomMemberInfos) {}
  insertChatRoomMemberInfoOne(ChatRoomMemberInfo chatRoomMemberInfo) {}
  deleteChatRoomMemberInfo(String roomId, String loginId) {}
  deleteChatRoomMemberInfoByRoomId(String roomId) {}
  isExistChatRoomMemberInfo(String loginId) {}
  getAllChatRoomMemberInfos() {}
  deleteAllChatRoomMemberInfo() {}
  // chatRoomMemberInfo 끝

  // chatMemberInfoDB 시작
  insertOrUpdateMemberInfo(List<ChatMemberInfo> chatMemberInfoes) {}
  insertOrUpdateMemberInfoOne(ChatMemberInfo chatMemberInfo) {}
  getMemberInfoes(String roomId) {}
  getAllMemberInfoes() {}
  deleteMemberInfo(String loginId) {}
  deleteAllMemberInfo() {}
  // chatMemberInfoDB 끝
}
