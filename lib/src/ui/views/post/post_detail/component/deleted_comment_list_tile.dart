import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/view_models/post_detail_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/horizontal_spacing.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/deleted_nested_comment_list_tile.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/nested_comment_list_tile.dart';

class DeletedCommentListTile extends StatelessWidget {
  final PostDetailScreenViewModel vm;
  final CommentPresentation comment;
  const DeletedCommentListTile(
      {Key? key, required this.vm, required this.comment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(5),
          horizontal: getProportionateScreenWidth(5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: getProportionateScreenWidth(15),
            backgroundImage:
                const AssetImage('assets/images/user/general_user.png'),
          ),
          const HorizontalSpacing(of: 10),
          Expanded(
              child: Column(
            children: [
              Align(
                  heightFactor: getProportionateScreenHeight(2),
                  alignment: Alignment.centerLeft,
                  child: const Text('삭제된 댓글입니다')),
              (comment.children.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comment.children.length,
                      itemBuilder: (BuildContext context, int index) {
                        return comment.children[index].deleted
                            ? DeletedNestedCommentListTile(
                                vm: vm, nestedComment: comment.children[index])
                            : NestedCommentListTile(
                                vm: vm, nestedComment: comment.children[index]);
                      })
                  : const SizedBox()
            ],
          ))
        ],
      ),
    );
  }
}
