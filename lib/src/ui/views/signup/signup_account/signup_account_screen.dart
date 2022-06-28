import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamongcampus/src/business_logic/constants/color_constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/signup_viewmodel.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_components/sub_appbar_components/sub_appbar.dart';
import 'package:zamongcampus/src/ui/views/signup/signup_account/components/body.dart';

class SignUpAccountScreen extends StatefulWidget {
  const SignUpAccountScreen({Key? key}) : super(key: key);

  @override
  _SignUpAccountScreenState createState() => _SignUpAccountScreenState();
}

class _SignUpAccountScreenState extends State<SignUpAccountScreen> {
  SignUpViewModel vm = serviceLocator<SignUpViewModel>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);
    return ChangeNotifierProvider<SignUpViewModel>.value(
      value: vm,
      child: Consumer<SignUpViewModel>(builder: (context, vm, child) {
        return GestureDetector(
          onTap: () =>
              FocusScope.of(context).unfocus(), //키보드 외부 영역 터치 시 키보드 내려감
          child: Scaffold(
            appBar: SubAppbar(
              titleText: '계정 정보 입력',
              isCenter: true,
              leadingOnPress: () {
                serviceLocator.resetLazySingleton<SignUpViewModel>(
                    instance: vm);
                Navigator.pop(context);
              },
            ),
            backgroundColor: kSubScreenBackgroundColor,
            body: Body(vm: vm),
          ),
        );
      }),
    );
  }
}
