import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/vertical_spacing.dart';

class ProfileInfo extends StatelessWidget {
  String imageUrl;
  String nickname;
  String? majorName;
  String collegeName;
  String? introduction;

  ProfileInfo(
      {Key? key,
      required this.imageUrl,
      required this.nickname,
      required this.majorName,
      required this.collegeName,
      required this.introduction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          //vertical: getProportionateScreenHeight(20),
          horizontal: getProportionateScreenWidth(20)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: getProportionateScreenHeight(40),
                  backgroundImage: imageUrl.startsWith('https')
                      ? CachedNetworkImageProvider(imageUrl) as ImageProvider
                      : AssetImage(
                          imageUrl,
                        ),
                ),
                // Positioned(
                //   bottom: 1,
                //   right: -1,
                //   child: Container(
                //       width: getProportionateScreenWidth(20),
                //       height: getProportionateScreenHeight(20),
                //       decoration: BoxDecoration(
                //         color: userProfile.isOnline
                //             ? const Color(0xff00FFBA) //온라인 상태일 때 색
                //             : Colors.grey, //오프라인 상태일 떄 색
                //         shape: BoxShape.circle,
                //         border: Border.all(
                //             color: Colors.white,
                //             width: 4.0,
                //             style: BorderStyle.solid),
                //       )),
                // )
              ],
            ),
          ),
          Text(
            nickname,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          majorName == null
              ? Text(
                  collegeName,
                  style: TextStyle(
                      fontSize: 13, color: Colors.black.withOpacity(0.5)),
                )
              : Text(
                  collegeName + ' / ' + majorName!,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withOpacity(0.5),
                      letterSpacing: 0.5),
                ),
          introduction == null
              ? const VerticalSpacing(of: 20)
              : Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(20)),
                  child: Text(
                    introduction!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5),
                  ),
                )
        ],
      ),
    );
  }
}
