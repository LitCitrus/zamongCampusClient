import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/view_models/post_main_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/center_sentence.dart';

import 'post_list_tile.dart';

class Body extends StatelessWidget {
  PostMainScreenViewModel model;
  Body({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: model.posts.length,
            itemBuilder: (BuildContext context, int index) {
              return PostListTile(post: model.posts[index]);
            }),
        // TODO : 게시글이 아예 없는 경우, loading되는 상태,
        model.busy
            ? SizedBox(
                height: getProportionateScreenHeight(400),
                child: const Center(
                  child: CircularProgressIndicator(),
                ))
            : (model.posts.isEmpty
                ? const CenterSentence(
                    sentence: "등록된 게시글이 없습니다.",
                    verticalSpace: 50,
                  )
                : Container()),
      ]),
    );
  }
}
