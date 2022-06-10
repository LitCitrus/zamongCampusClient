import 'package:flutter/material.dart';
import 'package:zamongcampus/src/config/init.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_components/signup_bottom_sheet_component/signup_bottom_sheet.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);
    splashInit(context);
    return Material(
      child: SizedBox(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: Image.asset(
          'assets/images/splash/splash.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> splashInit(BuildContext context) async {
    // await Future.delayed(const Duration(milliseconds: 1000));
    String firstRoute = await Init.initialize();
    print(firstRoute + " 로 이동!");
    if (firstRoute == "/") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(firstRoute, (Route<dynamic> route) => false);
    } else if (firstRoute == "/login") {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) {
            return const SignUpBottomSheet();
          }).whenComplete(() => Navigator.of(
              context)
          .pushNamedAndRemoveUntil(firstRoute, (route) => false));
      //showCustomModalBottomSheet(context, SignUpBottomSheet());
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/error", (Route<dynamic> route) => false);
    }
  }
}
