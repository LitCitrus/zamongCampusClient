import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/utils/methods.dart';
import 'package:zamongcampus/src/business_logic/view_models/profile_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/default_btn.dart';
import 'package:zamongcampus/src/ui/common_widgets/default_shadow.dart';

class FriendRequestBtn extends StatefulWidget {
  // TODO: userprofile과 일반 profile를 케이스에따라 받기에 var 변수로 뒀다.
  var vm;
  String profileLoginId;
  FriendRequestBtn({Key? key, required this.vm, required this.profileLoginId})
      : super(key: key);

  @override
  _FriendRequestBtnState createState() => _FriendRequestBtnState();
}

class _FriendRequestBtnState extends State<FriendRequestBtn> {
  @override
  Widget build(BuildContext context) {
    return DefaultShadowBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            getProportionateScreenWidth(20),
            getProportionateScreenHeight(10),
            getProportionateScreenWidth(20),
            getProportionateScreenHeight(25)),
        child: DefaultBtn(
          text: '친구 신청',
          press: () {
            widget.vm.requestFriend('userId', widget.profileLoginId);
          },
        ),
      ),
    );
  }
}
