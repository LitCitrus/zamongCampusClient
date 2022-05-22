import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/post_detail_screen_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/horizontal_spacing.dart';
import 'package:zamongcampus/src/ui/common_widgets/vertical_spacing.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/gallery_photo_view_wrapper.dart';
import 'package:zamongcampus/src/ui/views/post/post_detail/component/post_image_item_thumbnail.dart';

class PostBody extends StatelessWidget {
  final PostDetailScreenViewModel vm;

  const PostBody({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(vm.postDetail.body),
          vm.postDetail.imageUrls == null ? Container() : _hasImage(context),
          Row(
            children: [
              InkWell(
                onTap: () {
                  vm.likePost(vm.postDetail.loginId, vm.postDetail.id);
                },
                child: vm.isliked
                    ? Padding(
                        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                        child: Icon(
                          Icons.favorite,
                          size: getProportionateScreenWidth(22),
                          color: mainColor,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                        child: Icon(Icons.favorite_border,
                            size: getProportionateScreenWidth(22)),
                      ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: Text(
                  vm.postDetail.likedCount,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    size: getProportionateScreenWidth(22),
                  ),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: Text(
                  vm.postDetail.commentCount,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                  child: Icon(
                    Icons.bookmark_outline,
                    size: getProportionateScreenWidth(25),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _hasImage(BuildContext context) {
    Widget widget;
    int restImg = vm.postDetail.imageUrls!.length - 3;

    List<ImageItem> postImageItems = <ImageItem>[];
    for (int i = 0; i < vm.postDetail.imageUrls!.length; i++) {
      postImageItems
          .add(ImageItem(id: "tag${i}", resource: vm.postDetail.imageUrls![i]));
    }

    void open(BuildContext context, final int index) {
      //PostImageItemThumbnail의 onTap 함수
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GalleryPhotoViewWrapper(
            imageItems: postImageItems,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            initialIndex: index,
            scrollDirection: Axis.horizontal,
          ),
        ),
      );
    }

    EdgeInsets margin = EdgeInsets.only(
        top: getProportionateScreenHeight(10),
        bottom: getProportionateScreenHeight(5));
    switch (vm.postDetail.imageUrls!.length) {
      case 0:
        widget = Container();
        break;
      case 1:
        widget = Container(
          margin: margin,
          height: getProportionateScreenHeight(335),
          width: getProportionateScreenWidth(335),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: PostImageItemThumbnail(
              postImageItem: postImageItems[0],
              onTap: () {
                open(context, 0);
              },
            ),
          ),
        );
        break;
      case 2:
        widget = Container(
          margin: margin,
          height: getProportionateScreenHeight(335),
          width: getProportionateScreenWidth(335),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  child: PostImageItemThumbnail(
                    postImageItem: postImageItems[0],
                    onTap: () {
                      open(context, 0);
                    },
                  ),
                ),
              ),
              const VerticalSpacing(of: 5),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  child: PostImageItemThumbnail(
                    postImageItem: postImageItems[1],
                    onTap: () {
                      open(context, 1);
                    },
                  ),
                ),
              )
            ],
          ),
        );
        break;
      case 3:
        widget = Container(
          margin: margin,
          height: getProportionateScreenHeight(335),
          width: getProportionateScreenWidth(335),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  child: PostImageItemThumbnail(
                    postImageItem: postImageItems[0],
                    onTap: () {
                      open(context, 0);
                    },
                  ),
                ),
              ),
              const VerticalSpacing(of: 5),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5)),
                        child: PostImageItemThumbnail(
                          postImageItem: postImageItems[1],
                          onTap: () {
                            open(context, 1);
                          },
                        ),
                      ),
                    ),
                    const HorizontalSpacing(of: 5),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(5)),
                        child: PostImageItemThumbnail(
                          postImageItem: postImageItems[2],
                          onTap: () {
                            open(context, 2);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
        break;
      default: //4개이상일 때 실행
        widget = Container(
          margin: margin,
          height: getProportionateScreenHeight(335),
          width: getProportionateScreenWidth(335),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  child: PostImageItemThumbnail(
                    postImageItem: postImageItems[0],
                    onTap: () {
                      open(context, 0);
                    },
                  ),
                ),
              ),
              const VerticalSpacing(of: 5),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5)),
                        child: PostImageItemThumbnail(
                          postImageItem: postImageItems[1],
                          onTap: () {
                            open(context, 1);
                          },
                        ),
                      ),
                    ),
                    const HorizontalSpacing(of: 5),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(5)),
                        child: PostImageItemThumbnail(
                          hasMoreImg: true,
                          restImg: restImg,
                          postImageItem: postImageItems[2],
                          onTap: () {
                            open(context, 2);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
    }
    return widget;
  }
}
