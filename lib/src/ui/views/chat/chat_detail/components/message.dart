import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/init/auth_service.dart';
import 'package:zamongcampus/src/business_logic/models/chatMessage.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/utils/date_convert.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/round_chip.dart';

class Message extends StatelessWidget {
  final ChatMessage message;
  final vm;
  const Message({Key? key, required this.message, required this.vm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
      child: (message.type == "ENTER" || message.text == "EXIT")
          ? Container(
              alignment: Alignment.center,
              child: RoundChip(
                text: message.text,
                textColor: Colors.white,
                backgroundColor: Colors.black38,
                horizontalPadding: kDefaultPadding / 2,
                verticalPadding: kDefaultPadding / 6,
                fontsize: 11,
              ))
          : IntrinsicHeight(
              child: Row(
                mainAxisAlignment: message.loginId == AuthService.loginId
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (message.loginId != AuthService.loginId) ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: getProportionateScreenHeight(2)),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                // TODO: aws 적용 부분
                                // Image.network(message.imageUrl).image,
                                // loginIdToImageUrl(message.loginId),
                                loginIdToImageUrl(message.loginId)
                                        .startsWith('https')
                                    ? CachedNetworkImageProvider(
                                            loginIdToImageUrl(message.loginId))
                                        as ImageProvider
                                    : const AssetImage(
                                        'assets/images/user/general_user.png'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: kDefaultPadding / 2),
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 5, bottom: 5),
                              child: Text(
                                // ** nickname으로 변경한 부분
                                loginIdToNickname(message.loginId),
                                style: TextStyle(fontSize: 14),
                              )),
                          Container(
                              width: message.text.length > 27
                                  ? getProportionateScreenWidth(250)
                                  : null,
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(10),
                                vertical: getProportionateScreenWidth(10),
                              ),
                              decoration: const BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          dateToTime(message.createdAt),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                  if (message.loginId == AuthService.loginId) ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          dateToTime(message.createdAt),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: message.text.length > 30
                          ? getProportionateScreenWidth(280)
                          : null,
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(13),
                        vertical: getProportionateScreenWidth(10),
                      ),
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15))),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          this.message.text,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ],
              ),
            ),
    );
  }

  String loginIdToNickname(String loginId) {
    return vm.chatMemberInfos[loginId].nickname;
  }

  String loginIdToImageUrl(String loginId) {
    return vm.chatMemberInfos[loginId].imageUrl;
  }
}
