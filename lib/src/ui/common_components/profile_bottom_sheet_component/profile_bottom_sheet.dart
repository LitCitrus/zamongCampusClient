import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamongcampus/src/business_logic/models/friend.dart';
import 'package:zamongcampus/src/business_logic/view_models/profile_viewmodel.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_components/profile_bottom_sheet_component/components/friend_request_btn.dart';
import 'package:zamongcampus/src/ui/common_components/profile_bottom_sheet_component/components/goto_chatroom_btn.dart';
import 'package:zamongcampus/src/ui/common_components/profile_bottom_sheet_component/components/profile_header.dart';
import 'package:zamongcampus/src/ui/common_components/profile_bottom_sheet_component/components/profile_info.dart';
import 'package:zamongcampus/src/ui/common_components/profile_bottom_sheet_component/components/profile_interest.dart';
import 'package:zamongcampus/src/ui/common_components/profile_bottom_sheet_component/components/waiting_friend_request.dart';
import 'package:zamongcampus/src/ui/common_widgets/isLoading.dart';

class ProfileBottomSheet extends StatefulWidget {
  final int friendId;
  const ProfileBottomSheet({Key? key, required this.friendId})
      : super(key: key);

  @override
  State<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  ProfileViewModel vm = serviceLocator<ProfileViewModel>();

  @override
  void initState() {
    vm.loadProfile(widget.friendId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);
    return ChangeNotifierProvider<ProfileViewModel>(
        create: (context) => vm,
        child: Consumer<ProfileViewModel>(builder: (context, vm, child) {
          return makeDismissible(
            child: DraggableScrollableSheet(
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              builder: (BuildContext context,
                      ScrollController scrollController) =>
                  Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      child: vm.busy
                          ? const IsLoading()
                          : Column(
                              children: [
                                const ProfileHeader(),
                                ProfileInfo(
                                  imageUrl: vm.profile.imageUrl,
                                  nickname: vm.profile.nickname,
                                  majorName: vm.profile.majorName,
                                  collegeName: vm.profile.collegeName,
                                  introduction: vm.profile.introduction,
                                ),
                                Expanded(
                                  child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        ListView(
                                          controller: scrollController,
                                          children: [
                                            ProfileInterest(
                                                profileInterests: vm.interests),
                                          ],
                                        ),
                                        _bottomFixedBtn()
                                      ]),
                                ),
                              ],
                            )),
            ),
          );
        }));
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  Widget _bottomFixedBtn() {
    switch (vm.profile.friendRequestStatus) {
      case FriendRequestStatus.ACCEPTED:
        return GoToChatRoomBtn(profileLoginId: vm.profile.loginId);
      case FriendRequestStatus.UNACCEPTED:
        return WaitingFriendRequest();
      default:
        return FriendRequestBtn(
          vm: vm,
          profileLoginId: vm.profile.loginId,
        );
    }
  }
}
