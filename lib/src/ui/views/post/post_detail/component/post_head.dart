import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/view_models/post_detail_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/vertical_spacing.dart';

class PostHead extends StatelessWidget {
  final PostDetailPresentation post;
  const PostHead({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            //카테고리 나열 -> viewmodel에서 맵핑할때 이렇게까지 작업하고 여기에서는 Text(post.category) 이런식으로만 쓸 수 있게 해야할거같음.
            alignment: WrapAlignment.start,
            spacing: getProportionateScreenWidth(8),
            children: [
              ...?post.categories?.map((category) => Chip(
                    label: Text(category),
                    labelStyle: const TextStyle(fontSize: 12),
                    backgroundColor: const Color(0xfff8f8f8),
                  ))
            ],
          ),

          const VerticalSpacing(of: 5),
          Text(
            post.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          //const VerticalSpacing(of: 10),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            minVerticalPadding: getProportionateScreenHeight(15),
            horizontalTitleGap: getProportionateScreenWidth(5),
            dense: true,
            leading: CircleAvatar(
              radius: getProportionateScreenWidth(15),

              backgroundImage:
                  AssetImage(post.userImageUrl), //이미지만 넣으면 에러남(아마도 해결)
            ),
            title: Text(
              post.userNickname,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              post.createdAt,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
