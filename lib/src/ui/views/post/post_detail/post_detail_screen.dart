import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamongcampus/src/business_logic/view_models/post_detail_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/isLoading.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/body.dart';

class PostDetailScreen extends StatefulWidget {
  static const routeName = '/postDetail';
  final int postId;
  final String likedCount;
  const PostDetailScreen(
      {Key? key, required this.postId, required this.likedCount})
      : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostDetailScreenViewModel vm = serviceLocator<PostDetailScreenViewModel>();
  @override
  void initState() {
    vm.loadPostDetail(widget.postId);
    vm.changeLikedCount(widget.likedCount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);
    return ChangeNotifierProvider<PostDetailScreenViewModel>(
      create: (context) => vm,
      child: Consumer<PostDetailScreenViewModel>(
        builder: (context, vm, child) {
          return GestureDetector(
            onTap: () =>
                FocusScope.of(context).unfocus(), //키보드 외부 영역 터치 시 키보드 내려감
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.chevron_left_outlined),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    color: Colors.black,
                    onPressed: () {},
                  ),
                ],
                elevation: 0.0,
                backgroundColor: Colors.transparent,
              ),
              backgroundColor: Colors.white,
              //extendBodyBehindAppBar: true,
              body: vm.busy ? const IsLoading() : Body(vm: vm),
            ),
          );
        },
      ),
    );
  }
}
