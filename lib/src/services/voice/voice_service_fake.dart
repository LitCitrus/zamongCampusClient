import 'package:zamongcampus/src/business_logic/models/voice_room.dart';
import 'package:zamongcampus/src/config/dummy_data.dart';

import 'voice_service.dart';

class FakeVoiceService implements VoiceService {
  @override
  Future<bool> createVoiceRoom({required String title}) async {
    // TODO: implement createVoiceRoom
    throw UnimplementedError();
  }

  @override
  Future<VoiceRoom> fetchVoiceRoom({required int voiceRoomId}) async {
    return voiceRoomDummy[1];
  }

  @override
  Future<List<VoiceRoom>> fetchVoiceRooms({required int nextPageToken}) async {
    List<VoiceRoom> voiceRooms = [];
    voiceRooms.addAll(voiceRoomDummy);
    return voiceRooms;
  }
}
