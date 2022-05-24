import 'package:zamongcampus/src/business_logic/models/voice_room_info.dart';
import 'package:zamongcampus/src/business_logic/utils/category_data.dart';

import 'chatMessage.dart';
import 'user.dart';

enum VoiceRoomType { PUBLIC, PRIVATE }

class VoiceRoom {
  final VoiceRoomInfo voiceRoomAndTokenInfo;

  List<dynamic> membersInfo;
  DateTime createdAt;
  VoiceRoomType? type;
  List<ChatMessage>? chatMessages;
  List<Category>? categories;
  bool? collegeOnly;
  bool? majorOnly;

  VoiceRoom(
      {required this.voiceRoomAndTokenInfo,
      required this.membersInfo,
      this.chatMessages,
      required this.categories,
      required this.createdAt,
      this.type,
      this.collegeOnly,
      this.majorOnly});

  factory VoiceRoom.fromJson(Map<String, dynamic> json) {
    return VoiceRoom(
        voiceRoomAndTokenInfo: json['voiceRoomAndTokenInfo']
            .map((item) => VoiceRoomInfo.fromJson(item))
            .toList(),
        membersInfo:
            json['membersInfo'].map((member) => User.fromJosn(member)).toList(),
        chatMessages: json['chatMessages'],
        categories: json['categories'],
        createdAt: DateTime.parse(json['createdAt']),
        type: VoiceRoomType.values.byName(json['type']),
        collegeOnly: json['collegeOnly'],
        majorOnly: json['majorOnly']);
  }
}
