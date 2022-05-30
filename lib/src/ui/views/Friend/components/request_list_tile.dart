import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/utils/methods.dart';
import 'package:zamongcampus/src/business_logic/view_models/friend_list_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_components/profile_bottom_sheet_component/profile_bottom_sheet.dart';

class RequestListTile extends StatelessWidget {
  final FriendListViewModel vm;
  final FriendPresentation user;
  const RequestListTile({Key? key, required this.vm, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(10)),
      child: InkWell(
        onTap: () {
          showCustomModalBottomSheet(
              context, ProfileBottomSheet(userId: user.loginId), true);
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: getProportionateScreenHeight(30),
                backgroundImage: AssetImage(user.userImageUrl),
              ),
              Positioned(
                bottom: 1,
                right: -1,
                child: Container(
                    width: getProportionateScreenWidth(15),
                    height: getProportionateScreenHeight(15),
                    decoration: BoxDecoration(
                      color: user.isOnline
                          ? const Color(0xff00FFBA) //온라인 상태일 때 색
                          : Colors.grey, //오프라인 상태일 떄 색
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white,
                          width: 3.0,
                          style: BorderStyle.solid),
                    )),
              )
            ],
          ),
          title: Text(
            user.userNickname,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Wrap(
            spacing: getProportionateScreenWidth(5),
            children: [
              TextButton(
                onPressed: () {
                  vm.acceptRequest(user);
                },
                child: Text('수락'),
                style: TextButton.styleFrom(
                  backgroundColor: mainColor,
                  primary: Colors.white,
                ),
              ),
              TextButton(
                  onPressed: () {
                    vm.rejectRequest(user);
                  },
                  child: Text('삭제'),
                  style: TextButton.styleFrom(
                      primary: mainColor, side: BorderSide(color: mainColor))),
            ],
          ),
        ),
      ),
    );
  }
}
