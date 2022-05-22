import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/view_models/friend_list_viewmodel.dart';
import 'package:zamongcampus/src/ui/views/Friend/components/friend_list_tile.dart';
import 'package:zamongcampus/src/ui/views/Friend/components/search_bar.dart';

class FriendListBody extends StatelessWidget {
  final FriendListViewModel vm;
  final List<FriendPresentation> friends;
  const FriendListBody({Key? key, required this.vm, required this.friends})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SearchBar(),
        vm.busy
            ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                    )),
              )
            : Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: friends.length,
                    itemBuilder: (BuildContext context, int index) =>
                        FriendListTile(vm: vm, friend: friends[index])))
      ],
    );
  }
}
