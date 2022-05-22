import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/arguments/post_detail_screen_args.dart';

import 'package:zamongcampus/src/business_logic/view_models/post_main_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/horizontal_spacing.dart';
import 'package:zamongcampus/src/ui/common_widgets/vertical_spacing.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/post_detail_screen.dart';

class PostListTile extends StatelessWidget {
  final PostPresentation post;
  const PostListTile({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PostDetailScreen.routeName,
            arguments: PostDetailScreenArgs(post.id, post.likedCount));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          //모서리를 둥글게 하기 위해 사용
          borderRadius: BorderRadius.circular(10.0),
        ),
        shadowColor: Colors.grey.shade100,
        elevation: 4.0,
        margin: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(5),
            horizontal: getProportionateScreenWidth(20)),
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenHeight(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                //카테고리 나열 -> viewmodel에서 Row로 정렬되게끔 바꾸기
                children: [
                  ...post.categories.map((category) => Text(
                        category + "  ",
                        style: const TextStyle(fontSize: 12),
                      ))
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(10)),
                child: (post.imageUrl == null) ? _noImg() : _hasImg(),
              ),
              Row(
                children: [
                  Text(
                    "좋아요 " + post.likedCount,
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                  const HorizontalSpacing(of: 10),
                  Text(
                    "조회수 " + post.viewCount,
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                  const HorizontalSpacing(of: 10),
                  Text(
                    "댓글 " + post.commentCount,
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hasImg() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: getProportionateScreenWidth(230),
          height: getProportionateScreenHeight(60),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const VerticalSpacing(of: 5),
                Text(
                  post.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xff818181)),
                )
              ]),
        ),
        const Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            post.imageUrl!,
            width: getProportionateScreenWidth(60),
            height: getProportionateScreenHeight(60),
            fit: BoxFit.cover,
          ),
        )
      ],
    );
  }

  Widget _noImg() {
    return SizedBox(
      height: getProportionateScreenHeight(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const VerticalSpacing(of: 5),
          Text(
            post.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Color(0xff818181)),
          )
        ],
      ),
    );
  }
}
