import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/chat_detail_from_friendProfile_viewmodel.dart';
import 'package:zamongcampus/src/business_logic/view_models/chat_viewmodel.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/config/size_config.dart';

import 'components/body.dart';

class ChatDetailFromFriendProfileScreen extends StatefulWidget {
  static const routeName = '/chatDetailFromFriendProfile';
  final String profileLoginId;
  const ChatDetailFromFriendProfileScreen(
      {Key? key, required this.profileLoginId})
      : super(key: key);

  @override
  State<ChatDetailFromFriendProfileScreen> createState() =>
      _ChatDetailFromFriendProfileScreenState();
}

class _ChatDetailFromFriendProfileScreenState
    extends State<ChatDetailFromFriendProfileScreen> {
  ChatDetailFromFriendProfileViewModel vm =
      serviceLocator<ChatDetailFromFriendProfileViewModel>();
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      vm.chatDetailInit(widget.profileLoginId);
    });
    super.initState();
  }

  @override
  void dispose() {
    ChatViewModel chatViewModel = serviceLocator<ChatViewModel>();
    chatViewModel.changeFromFriendProfile(false);
    vm.resetData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);
    return ChangeNotifierProvider.value(
        value: vm,
        child: Consumer<ChatDetailFromFriendProfileViewModel>(
            builder: (context, vm, child) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            behavior: HitTestBehavior.translucent,
            child: Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [subColor, mainColor],
                      stops: [0.5, 1.0],
                    ),
                  ),
                ),
                leading: const BackButton(),
                centerTitle: true,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      vm.chatRoom.title,
                      style: TextStyle(
                          fontFamily: "SCDream5",
                          fontSize: getProportionateScreenWidth(15)),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.more_horiz_outlined,
                          color: Colors.white),
                      onPressed: () {})
                ],
              ),
              body: Body(vm: vm),
            ),
          );
        }));
  }
}
