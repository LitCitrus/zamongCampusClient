import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/view_models/post_detail_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/default_shadow.dart';
import 'package:zamongcampus/src/ui/common_widgets/vertical_spacing.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/comment_input.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/comment_list.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/post_body.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/post_head.dart';

class Body extends StatelessWidget {
  final PostDetailScreenViewModel vm;
  const Body({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
                child: Column(
          children: [
            PostHead(post: vm.postDetail), //카터고리 타이틀 프로필
            PostBody(vm: vm), //본문
            const VerticalSpacing(of: 15),
            CommentList(vm: vm) // 댓글
          ],
        ))),
        CompositedTransformTarget(
          link: vm.layerLink,
          child: DefaultShadowBox(
              child: Padding(
            padding: EdgeInsets.fromLTRB(
                getProportionateScreenWidth(20),
                getProportionateScreenHeight(10),
                getProportionateScreenWidth(20),
                getProportionateScreenHeight(25)),
            child: CommentInput(vm: vm),
          )),
        )
      ],
    );
  }
}
