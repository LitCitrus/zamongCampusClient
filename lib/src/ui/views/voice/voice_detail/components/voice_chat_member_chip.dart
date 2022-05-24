import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/voice_detail_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';

class VoiceChatMemberChip extends StatefulWidget {
  VoiceDetailViewModel vm;
  MemberPresentation member;
  VoiceChatMemberChip({Key? key, required this.vm, required this.member})
      : super(key: key);

  @override
  _VoiceChatMemberChipState createState() => _VoiceChatMemberChipState();
}

class _VoiceChatMemberChipState extends State<VoiceChatMemberChip> {
  @override
  Widget build(BuildContext context) {
    return widget.member.isHost
        ? Column(
            children: [
              Stack(children: [
                Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(3)),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: widget.member.isSpeaking
                              ? mainColor
                              : Colors.grey.withOpacity(0.5),
                          width: 2.0,
                          style: BorderStyle.solid),
                      shape: BoxShape.circle),
                  child: CircleAvatar(
                    radius: getProportionateScreenWidth(28),
                    backgroundImage: AssetImage(widget.member.imageUrl),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 0,
                  child: Container(
                    width: getProportionateScreenWidth(20),
                    height: getProportionateScreenHeight(20),
                    decoration: const BoxDecoration(
                      color: mainColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: getProportionateScreenWidth(15),
                    ),
                  ),
                )
              ]),
              Container(
                width: getProportionateScreenWidth(60),
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(10)),
                child: Text(
                  //여기서 만약에 본인이면 (나)라고 표기해주는 분기
                  widget.member.nickname,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        : Column(
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(3)),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: widget.member.isSpeaking
                            ? mainColor
                            : Colors.grey.withOpacity(0.5),
                        width: 2.0,
                        style: BorderStyle.solid),
                    shape: BoxShape.circle),
                child: CircleAvatar(
                  radius: getProportionateScreenWidth(28),
                  backgroundImage: AssetImage(widget.member.imageUrl),
                ),
              ),
              Container(
                width: getProportionateScreenWidth(60),
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(10)),
                child: Text(
                  //여기서 만약에 본인이면 (나)라고 표기해주는 분기
                  widget.member.nickname,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
  }
}
