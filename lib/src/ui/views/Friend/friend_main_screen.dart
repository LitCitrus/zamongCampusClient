import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/friend_list_viewmodel.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/views/Friend/components/friend_list_body.dart';
import 'package:zamongcampus/src/ui/views/Friend/components/request_list_body.dart';

class FriendMainScreen extends StatefulWidget {
  const FriendMainScreen({Key? key}) : super(key: key);

  @override
  _FriendMainScreenState createState() => _FriendMainScreenState();
}

class _FriendMainScreenState extends State<FriendMainScreen> {
  FriendListViewModel vm = serviceLocator<FriendListViewModel>();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      vm.loadFriends();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);

    return ChangeNotifierProvider<FriendListViewModel>.value(
        value: vm,
        child: Consumer<FriendListViewModel>(builder: (context, vm, child) {
          return GestureDetector(
            onTap: () =>
                FocusScope.of(context).unfocus(), //키보드 외부 영역 터치 시 키보드 내려감
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('내 친구',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  centerTitle: false,
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_outlined),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      color: Colors.black,
                      onPressed: () {},
                    )
                  ],
                  bottom: PreferredSize(
                    preferredSize:
                        Size.fromHeight(getProportionateScreenHeight(40)),
                    child: TabBar(
                        indicatorColor: mainColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.black,
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelColor: const Color(0xff7f7f7f),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 15,
                        ),
                        tabs: [
                          SizedBox(
                              height: getProportionateScreenHeight(30),
                              child: const Tab(text: '친구 목록')),
                          SizedBox(
                              height: getProportionateScreenHeight(30),
                              child: const Tab(text: '친구 신청'))
                        ]),
                  ),
                ),
                backgroundColor: Colors.white, //배경색
                body: TabBarView(children: [
                  FriendListBody(
                      vm: vm, friends: vm.friendsIRequestAndAceepted),
                  RequestListBody(vm: vm, friends: vm.friendsIReceived)
                ]),
              ),
            ),
          );
        }));
  }
}
