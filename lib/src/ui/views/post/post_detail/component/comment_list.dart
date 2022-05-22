import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/post_detail_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/vertical_spacing.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/comment_list_tile.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/deleted_comment_list_tile.dart';

class CommentList extends StatelessWidget {
  final PostDetailScreenViewModel vm;
  const CommentList({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(
                  text: vm.postDetail.commentCount,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                      letterSpacing: 1),
                  children: const [
                TextSpan(
                    text: '개의 댓글',
                    style: TextStyle(color: Colors.black, letterSpacing: 1))
              ])),
          const VerticalSpacing(of: 10),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vm.comments.length,
              itemBuilder: (BuildContext context, int index) {
                if (vm.comments[index].deleted) {
                  return DeletedCommentListTile(
                      vm: vm, comment: vm.comments[index]);
                } else {
                  return CommentListTile(vm: vm, comment: vm.comments[index]);
                }
              })
        ],
      ),
    );
  }
}
