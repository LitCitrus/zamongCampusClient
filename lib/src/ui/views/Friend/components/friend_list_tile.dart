import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/models/friend.dart';
import 'package:zamongcampus/src/business_logic/utils/methods.dart';
import 'package:zamongcampus/src/business_logic/view_models/friend_list_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_components/profile_bottom_sheet_component/profile_bottom_sheet.dart';

class FriendListTile extends StatelessWidget {
  final FriendListViewModel vm;
  final FriendPresentation friend;
  const FriendListTile({Key? key, required this.vm, required this.friend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(getProportionateScreenWidth(20), 0,
          getProportionateScreenWidth(20), getProportionateScreenHeight(20)),
      child: InkWell(
        onTap: () {
          showCustomModalBottomSheet(
              context, ProfileBottomSheet(friendId: friend.id));
        },
        child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: getProportionateScreenHeight(30),
                  backgroundImage: friend.userImageUrl.startsWith('https')
                      ? CachedNetworkImageProvider(friend.userImageUrl)
                          as ImageProvider
                      : AssetImage(
                          friend.userImageUrl,
                        ),
                ),
                /* isOnlined 추후 개발 */
                // Positioned(
                //   bottom: 1,
                //   right: -1,
                //   child: Container(
                //       width: getProportionateScreenWidth(15),
                //       height: getProportionateScreenHeight(15),
                //       decoration: BoxDecoration(
                //         color: friend.isOnline
                //             ? const Color(0xff00FFBA) //온라인 상태일 때 색
                //             : Colors.grey, //오프라인 상태일 떄 색
                //         shape: BoxShape.circle,
                //         border: Border.all(
                //             color: Colors.white,
                //             width: 3.0,
                //             style: BorderStyle.solid),
                //       )),
                // )
              ],
            ),
            title: Text(
              friend.userNickname,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            trailing: friend.friendRequestStatus == FriendRequestStatus.ACCEPTED
                ? IconButton(
                    onPressed: () {
                      vm.gotoChatroom(friend.loginId);
                    },
                    icon: Icon(Icons.more_horiz_outlined),
                    color: Colors.black,
                  )
                : TextButton(
                    onPressed: null,
                    child: Text('수락대기'),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.3)))),
      ),
    );
  }
}
