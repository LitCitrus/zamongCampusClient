import 'package:flutter/material.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:provider/provider.dart';

import '../../../../business_logic/view_models/post_main_screen_viewmodel.dart';
import 'components/body.dart';

class PostMainScreen extends StatefulWidget {
  const PostMainScreen({Key? key}) : super(key: key);

  @override
  State<PostMainScreen> createState() => _PostMainScreenState();
}

class _PostMainScreenState extends State<PostMainScreen> {
  PostMainScreenViewModel vm = serviceLocator<PostMainScreenViewModel>();

  @override
  void initState() {
    vm.loadPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);
    return ChangeNotifierProvider<PostMainScreenViewModel>(
        create: (context) => vm,
        child: Consumer<PostMainScreenViewModel>(builder: (context, vm, child) {
          return Scaffold(
              backgroundColor: const Color(0xfff8f8f8),
              body: SafeArea(child: Body(vm: vm)));
        }));
  }
}
