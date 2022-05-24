import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/view_models/voice_detail_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/views/voice/voice_detail/components/voice_chat_member_chip.dart';

class VoiceChat extends StatefulWidget {
  final VoiceDetailViewModel vm;
  const VoiceChat({Key? key, required this.vm}) : super(key: key);

  @override
  _VoiceChatState createState() => _VoiceChatState();
}

class _VoiceChatState extends State<VoiceChat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(25)),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: getProportionateScreenWidth(23),
        runSpacing: getProportionateScreenHeight(20),
        children: [
          ...widget.vm.voiceRoom.members.map(
              (member) => VoiceChatMemberChip(vm: widget.vm, member: member))
        ],
      ),
    );
  }
}
