import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/view_models/friend_list_viewmodel.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/views/Friend/components/request_list_tile.dart';

class RequestListBody extends StatelessWidget {
  final FriendListViewModel vm;
  final List<FriendPresentation> friends;
  const RequestListBody({Key? key, required this.vm, required this.friends})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getProportionateScreenHeight(15)),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: friends.length,
          itemBuilder: (BuildContext context, int index) {
            return RequestListTile(vm: vm, friend: friends[index]);
          }),
    );
  }
}
