import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/view_models/post_detail_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/horizontal_spacing.dart';

class DeletedNestedCommentListTile extends StatelessWidget {
  final PostDetailScreenViewModel vm;
  final CommentPresentation nestedComment;
  const DeletedNestedCommentListTile(
      {Key? key, required this.vm, required this.nestedComment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: getProportionateScreenWidth(11),
            backgroundImage:
                const AssetImage('assets/images/user/general_user.png'),
          ),
          const HorizontalSpacing(of: 10),
          const Expanded(
              child: Align(
            alignment: Alignment.centerLeft,
            child: Text('삭제된 댓글입니다'),
          ))
        ],
      ),
    );
  }
}
