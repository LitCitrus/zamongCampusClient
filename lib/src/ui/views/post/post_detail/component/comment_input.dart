import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/post_detail_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';

class CommentInput extends StatefulWidget {
  final PostDetailScreenViewModel vm;
  const CommentInput({Key? key, required this.vm}) : super(key: key);

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  ////대댓글,댓글 확인용
  // @override
  // void initState() {
  //   super.initState();

  //   widget.vm.commentTextController.addListener(() {
  //     print('comment: ' + widget.vm.commentTextController.text);
  //   });
  //   widget.vm.nestedCommentTextController.addListener(() {
  //     print('nestedComment: ' + widget.vm.nestedCommentTextController.text);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenHeight(335),
      height: getProportionateScreenHeight(56),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xfff8f8f8)),
      child: Row(
        children: [
          _commentInputField(),
          _sendBtn(),
        ],
      ),
    );
  }

  Widget _commentInputField() {
    return SizedBox(
        width: getProportionateScreenWidth(275),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: (widget.vm.overlayEntry == null)
              ? widget.vm.commentTextController
              : widget.vm.nestedCommentTextController,
          decoration: InputDecoration(
            hintText: '소중한 댓글을 남겨주세요',
            hintStyle: const TextStyle(color: Color(0xFFADADAD), fontSize: 14),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            contentPadding: EdgeInsets.all(getProportionateScreenHeight(10)),
            isDense: true,
          ),
          cursorColor: mainColor,
        ));
  }

  Widget _sendBtn() {
    return TextButton(
      onPressed: () {
        if (widget.vm.overlayEntry == null) {
          widget.vm.createComment();
        } else {
          widget.vm.createNestedComment();
        }
      },
      child: const Text('전송'),
      style: TextButton.styleFrom(
          minimumSize: Size(getProportionateScreenWidth(44),
              getProportionateScreenHeight(36)),
          backgroundColor: mainColor,
          primary: Colors.white),
    );
  }
}
