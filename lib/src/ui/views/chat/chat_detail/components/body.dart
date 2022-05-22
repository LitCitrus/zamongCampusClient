import 'package:flutter/material.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/view_models/chat_detail_viewmodel.dart';

import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatelessWidget {
  ChatDetailViewModel vm;
  Body({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return vm.busy
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
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 1.5),
                  child: ListView.builder(
                      reverse: true,
                      controller: vm.scrollController,
                      shrinkWrap: true,
                      itemCount: vm.chatMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Message(message: vm.chatMessages[index], vm: vm);
                      }),
                ),
              ),
              ChatInputField(
                roomId: vm.chatRoom.roomId,
                roomType: vm.chatRoom.type,
              )
            ],
          );
  }
}
