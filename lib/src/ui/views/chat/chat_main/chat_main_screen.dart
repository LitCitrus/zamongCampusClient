import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamongcampus/src/business_logic/view_models/chat_viewmodel.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/common_appbar.dart';

import 'components/body.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({Key? key}) : super(key: key);

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  ChatViewModel vm = serviceLocator<ChatViewModel>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);
    return ChangeNotifierProvider<ChatViewModel>(
        create: (context) => vm,
        child: Consumer<ChatViewModel>(builder: (context, vm, child) {
          return Scaffold(
              appBar: CommonAppbar(
                appBar: AppBar(),
                title: "자몽캠퍼스",
              ),
              backgroundColor: const Color(0xfff8f8f8),
              body: Body(vm: vm));
        }));
  }
}
