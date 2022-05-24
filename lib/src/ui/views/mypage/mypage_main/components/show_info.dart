import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/init/auth_service.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/mypage_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';

class ShowInfo extends StatelessWidget {
  MypageViewModel vm;
  ShowInfo({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(10),
          horizontal: getProportionateScreenWidth(20)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: getProportionateScreenHeight(15)),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: getProportionateScreenHeight(50),
                  backgroundImage: AssetImage(
                      vm.myInfo.imageUrl), //추후 누르면 전체화면으로 프사볼수있도록 변경하기
                ),
                Positioned(
                  bottom: 1,
                  right: -1,
                  child: _profileEditBtn(context),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: getProportionateScreenHeight(3)),
            child: Text(
              // vm.myInfo.nickname,
              AuthService.loginId ?? "닉넴오류",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          vm.myInfo.majorName == null
              ? Padding(
                  padding:
                      EdgeInsets.only(bottom: getProportionateScreenHeight(20)),
                  child: Text(
                    vm.myInfo.collegeName,
                    style: TextStyle(
                        fontSize: 13, color: Colors.black.withOpacity(0.5)),
                  ),
                )
              : Padding(
                  padding:
                      EdgeInsets.only(bottom: getProportionateScreenHeight(20)),
                  child: Text(
                    vm.myInfo.collegeName + ' / ' + vm.myInfo.majorName!,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withOpacity(0.5),
                        letterSpacing: 0.5),
                  ),
                ),
          _interestEditBtn(context)
        ],
      ),
    );
  }

  Widget _profileEditBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/mypageEditInfo');
      },
      child: Container(
        width: getProportionateScreenWidth(30),
        height: getProportionateScreenHeight(30),
        decoration: BoxDecoration(
          color: mainColor,
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.white, width: 3.0, style: BorderStyle.solid),
        ),
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: getProportionateScreenHeight(15),
        ),
      ),
    );
  }

  Widget _interestEditBtn(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/mypageEditInterest');
        },
        style: TextButton.styleFrom(
            primary: Colors.white,
            minimumSize: Size(getProportionateScreenWidth(335),
                getProportionateScreenHeight(50)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: mainColor,
            textStyle:
                const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                '내 관심사 ' + vm.myInfo.interestCount,
              ),
            ),
            const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.chevron_right_outlined,
                ))
          ],
        ));
  }
}
