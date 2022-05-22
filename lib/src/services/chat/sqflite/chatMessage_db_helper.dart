import 'package:intl/intl.dart';
import 'package:zamongcampus/src/business_logic/models/chatMessage.dart';
import 'package:zamongcampus/src/object/sqflite_object.dart';

const String tableName = 'ChatMessage';
const String columnrowId = 'rowId';
const String columnroomId = 'roomId';
const String columnloginId = 'loginId';
const String columntext = 'text';
const String columntype = 'type';
const String columncreatedAt = 'createdAt';

class ChatMessageDBHelper {
  Future<int> insertMessage(ChatMessage chatMessage) async {
    final db = await SqfliteObject.database;
    var res = await db!.rawInsert(
        'INSERT INTO $tableName(rowId, roomId, loginId, text, type, createdAt) VALUES(?,?,?,?,?,?)',
        [
          null,
          chatMessage.roomId,
          chatMessage.loginId,
          chatMessage.text,
          chatMessage.type.name,
          chatMessage.createdAt.toString(),
        ]);
    return res;
  }

  // READ: room id에 따른 값 가져오기
  // TODO: roomId별로 table 생성 필요할지도. (22.03.31)
  Future<List<ChatMessage>> getMessages(String roomId, int page) async {
    final db = await SqfliteObject.database;
    List res = await db!.rawQuery(
        'SELECT loginId, text, type, createdAt FROM $tableName WHERE roomId = ? ORDER BY rowId DESC LIMIT ?,? ',
        [roomId, page * 20, 20]);
    List<ChatMessage> messages = [];
    for (var json in res) {
      ChatMessage chatMessage = ChatMessage(
          roomId: roomId,
          loginId: json["loginId"],
          text: json["text"],
          type: MessageType.values.byName(json['type']),
          createdAt:
              DateFormat("yyyy-MM-dd hh:mm:ss").parse(json["createdAt"]));
      messages.add(chatMessage);
    }
    return messages;
  }

  // READ: 모든 채팅방들의 메시지
  Future<List<ChatMessage>> getAllChatMessage() async {
    final db = await SqfliteObject.database;
    List res = await db!.rawQuery(
        'SELECT loginId, text, type, createdAt FROM $tableName ORDER BY rowId');
    List<ChatMessage> chatMessages =
        res.isNotEmpty ? res.map((c) => ChatMessage.fromJson(c)).toList() : [];

    return chatMessages;
  }

  // DELETE: roomId에 해당되는 메시지 삭제
  void deleteMessageByRoomId(String roomId) async {
    final db = await SqfliteObject.database;
    List res =
        await db!.rawQuery('DELETE FROM $tableName WHERE roomId = ?', [roomId]);
    print(res);
  }

  // DELETE: sqflite 안에 있는 모든 메세지 삭제
  // table 자체를 삭제해도 되는가? => 이건 고려필요 (22.04.01)
  void deleteAllMessage() async {
    final db = await SqfliteObject.database;
    db!.delete(tableName);
    print("모든 메세지 삭제");
  }
}
