class VoiceRoomInfo {
  final int id;
  final String title;
  final String roomId;
  final String token;
  final int uid;
  final String ownerLoginId;

  VoiceRoomInfo(
      {required this.id,
      required this.title,
      required this.roomId,
      required this.token,
      required this.uid,
      required this.ownerLoginId});
  factory VoiceRoomInfo.fromJson(Map<String, dynamic> json) {
    return VoiceRoomInfo(
        id: json['id'],
        title: json['title'],
        roomId: json['roomId'],
        token: json['token'],
        uid: json['uid'],
        ownerLoginId: json['ownerLoginId']);
  }
}
