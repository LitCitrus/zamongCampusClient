import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/init/auth_service.dart';
import 'package:zamongcampus/src/business_logic/view_models/post_detail_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/horizontal_spacing.dart';

class NestedCommentListTile extends StatelessWidget {
  final PostDetailScreenViewModel vm;
  final CommentPresentation nestedComment;
  const NestedCommentListTile(
      {Key? key, required this.vm, required this.nestedComment})
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
            radius: getProportionateScreenWidth(11),
            backgroundImage: AssetImage(nestedComment.userImageUrl),
          ),
          const HorizontalSpacing(of: 5),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(children: [
                  Text(
                    nestedComment.userNickname,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5), fontSize: 13),
                  ),
                  const HorizontalSpacing(of: 10),
                  Text(
                    nestedComment.createdAt,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  const HorizontalSpacing(of: 10),
                  (nestedComment.loginId == AuthService.loginId)
                      ? _deleteBtn()
                      : _reportBtn()
                ]),
              ),
              Text(
                nestedComment.body,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13, height: 1.3),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _deleteBtn() {
    return TextButton(
      onPressed: () {
        vm.deleteComment(nestedComment.id);
      },
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        primary: Colors.black.withOpacity(0.3),
      ),
      child: const Text(
        '삭제',
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _reportBtn() {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        primary: Colors.black.withOpacity(0.3),
      ),
      child: const Text(
        '신고',
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
