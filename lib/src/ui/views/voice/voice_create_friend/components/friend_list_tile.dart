import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/voice_create_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';

class FriendListTile extends StatefulWidget {
  final VoiceCreateViewModel vm;
  final UserPresentation user;
  const FriendListTile({Key? key, required this.vm, required this.user})
      : super(key: key);

  @override
  State<FriendListTile> createState() => _FriendListTileState();
}

class _FriendListTileState extends State<FriendListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(getProportionateScreenWidth(20), 0,
          getProportionateScreenWidth(20), getProportionateScreenHeight(20)),
      child: CheckboxListTile(
        //체크박스 동그랗게 안됨. -> 패키지 써야함
        title: Text(
          widget.user.userNickname,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        contentPadding: const EdgeInsets.all(0),
        activeColor: mainColor,
        side: BorderSide.none,
        secondary: Stack(
          children: [
            CircleAvatar(
              radius: getProportionateScreenHeight(30),
              backgroundImage: AssetImage(widget.user.userImageUrl),
            ),
            /* isOnlined 추후 개발 */
            // Positioned(
            //   bottom: 1,
            //   right: -1,
            //   child: Container(
            //       width: getProportionateScreenWidth(15),
            //       height: getProportionateScreenHeight(15),
            //       decoration: BoxDecoration(
            //         color: widget.user.isOnline
            //             ? const Color(0xff00FFBA) //온라인 상태일 때 색
            //             : Colors.grey, //오프라인 상태일 떄 색
            //         shape: BoxShape.circle,
            //         border: Border.all(
            //             color: Colors.white,
            //             width: 3.0,
            //             style: BorderStyle.solid),
            //       )),
            // )
          ],
        ),
        value: widget.user.isChecked,
        onChanged: (value) {
          widget.vm.setMembers(widget.user, value!, widget.user.loginId);
        },
      ),
    );
  }
}
