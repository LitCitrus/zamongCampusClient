import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/view_models/signup_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/bottom_fixed_btn_decobox.dart';
import 'package:zamongcampus/src/ui/common_widgets/default_btn.dart';
import 'package:zamongcampus/src/ui/common_widgets/disabled_default_btn.dart';

class Body extends StatelessWidget {
  final SignUpViewModel vm;
  const Body({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenHeight(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          ),
        ),
        SafeArea(
          child: BottomFixedBtnDecoBox(
            child: (true) //여기 바꾸기
                ? DefaultBtn(
                    text: '다음',
                    press: () {
                      Navigator.pushNamed(context, '/signUpRequiredProfile');
                    },
                  )
                : const DisabledDefaultBtn(text: '다음'),
          ),
        ),
      ],
    );
  }
}
