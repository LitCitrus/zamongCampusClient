import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/init/auth_service.dart';
import 'package:zamongcampus/src/business_logic/view_models/post_detail_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/horizontal_spacing.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/deleted_nested_comment_list_tile.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/nested_comment_list_tile.dart';

class CommentListTile extends StatelessWidget {
  final PostDetailScreenViewModel vm;
  final CommentPresentation comment;
  const CommentListTile({Key? key, required this.comment, required this.vm})
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
            backgroundImage: AssetImage(comment.userImageUrl),
          ),
          const HorizontalSpacing(of: 10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  comment.userNickname,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5), fontSize: 13),
                ),
              ),
              Text(
                comment.body,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13, height: 1.3),
              ),
              Row(
                children: [
                  Text(
                    comment.createdAt,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                  const HorizontalSpacing(of: 10),
                  _replyBtn(context),
                  (comment.loginId == AuthService.loginId)
                      ? _deletedBtn()
                      : _reportBtn()
                ],
              ),
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

  Widget _replyBtn(BuildContext context) {
    return TextButton(
      onPressed: () {
        vm.createNestedCommentOverlay(
            context, comment.userNickname, comment.id);
      },
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        //padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        primary: Colors.black.withOpacity(0.4),
      ),
      child: const Text(
        '답글달기',
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _deletedBtn() {
    return TextButton(
      onPressed: () {
        vm.deleteComment(comment.id);
      },
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        //padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        primary: Colors.black.withOpacity(0.4),
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
        //padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        primary: Colors.black.withOpacity(0.4),
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
