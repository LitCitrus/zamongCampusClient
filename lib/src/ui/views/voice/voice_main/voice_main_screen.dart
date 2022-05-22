import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/voice_main_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/config/size_config.dart';

import 'components/body.dart';

class VoiceMainScreen extends StatefulWidget {
  const VoiceMainScreen({Key? key}) : super(key: key);

  @override
  State<VoiceMainScreen> createState() => _VoiceMainScreenState();
}

class _VoiceMainScreenState extends State<VoiceMainScreen> {
  VoiceMainScreenViewModel vm = serviceLocator<VoiceMainScreenViewModel>();

  // @override
  // void initState() {
  //   vm.loadVoiceRooms();
  //   vm.loadRecommendUsers();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      vm.loadVoiceRooms();
      vm.loadRecommendUsers();
    });
    SizeConfig().init(context: context);
    return ChangeNotifierProvider.value(
        value: vm,
        child:
            Consumer<VoiceMainScreenViewModel>(builder: (context, vm, child) {
          return Scaffold(
              appBar: AppBar(
                  title: const Text("자몽캠퍼스"),
                  centerTitle: false,
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/dummy");
                        },
                        icon: const Icon(Icons.notifications_outlined))
                  ],
                  backgroundColor: mainColor,
                  elevation: 0.0),
              backgroundColor: const Color(0xfff8f8f8),
              body: Body(vm: vm));
        }));
  }
}
