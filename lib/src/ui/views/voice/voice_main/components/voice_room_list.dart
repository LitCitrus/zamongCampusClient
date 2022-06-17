import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/view_models/voice_main_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';

import 'voice_room_list_tile.dart';

class VoiceRoomList extends StatelessWidget {
  VoiceMainScreenViewModel vm;
  VoiceRoomList({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: vm.voiceRooms.length,
        itemBuilder: (BuildContext context, int index) {
          return VoiceRoomListTile(voiceRoom: vm.voiceRooms[index]);
        });
  }
}
