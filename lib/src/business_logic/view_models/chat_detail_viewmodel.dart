import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zamongcampus/src/business_logic/models/chatMemberInfo.dart';
import 'package:zamongcampus/src/business_logic/models/chatMessage.dart';
import 'package:zamongcampus/src/business_logic/models/chatRoom.dart';
import 'package:zamongcampus/src/business_logic/view_models/chat_viewmodel.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/services/chat/chat_service.dart';

import 'base_model.dart';

class ChatDetailViewModel extends BaseModel {
  ChatService chatService = serviceLocator<ChatService>();
  ChatRoom chatRoom = ChatRoom(
      roomId: "",
      title: "",
      type: "",
      lastMessage: "",
      lastMsgCreatedAt: DateTime(2021, 05, 05),
      imageUrl: "",
      unreadCount: 0);
  final List<ChatMessage> _chatMessages = List.empty(growable: true);
  int nextPageToken = 1;
  Map<String, ChatMemberInfo> chatMemberInfos = <String, ChatMemberInfo>{};
  ScrollController scrollController = ScrollController();

  List<ChatMessage> get chatMessages => _chatMessages;

  // init 시작
  // 1. scroll init 2. chatroom 설정 3. chatmessage,member load
  // 4. unreadCount 0으로 변경 5. chatvm의 roomId 변경
  chatDetailInit(ChatRoom chatRoom) async {
    print('chatDetailInit 시작');
    setBusy(true);
    scrollInit();
    await setChatRoom(chatRoom);
    await loadFirstChatMessagesAndMember(chatRoom.roomId);
    await changeUnreadCount(chatRoom.roomId);
    ChatViewModel chatvm = serviceLocator<ChatViewModel>();
    chatvm.changeInsideRoomId(chatRoom.roomId);
    setBusy(false);
    print('chatDetailInit 끝');
  }

  setChatRoom(ChatRoom chatRoom) {
    this.chatRoom = chatRoom;
  }

  loadFirstChatMessagesAndMember(String roomId) async {
    _chatMessages.addAll(await chatService.getMessages(roomId, 0));
    List<ChatMemberInfo> chatMemberInfos =
        await chatService.getMemberInfoes(roomId);
    for (var element in chatMemberInfos) {
      this.chatMemberInfos.addAll({element.loginId: element});
    }
  }

  changeUnreadCount(String roomId) {
    chatService.updateUnreadCount(0, roomId);
    ChatViewModel chatViewModel = serviceLocator<ChatViewModel>();
    chatViewModel.changeUnreadCountToZero(roomId);

    /// chatroom 찾아서 unread 0으로 변경할 것.
  }
  // init 끝

  Future<void> addChatMessage(ChatMessage chatMessage) async {
    /// 실시간 오는 메세지
    setBusy(true);
    chatMessages.insert(0, chatMessage);
    changeScrollToLowest();
    print("실시간 메세지 더하기 완료");
    setBusy(false);
  }

  changeMember(ChatMemberInfo chatMemberInfo) {
    chatMemberInfos.update(chatMemberInfo.loginId, (value) => chatMemberInfo);
  }

  Future<void> loadMoreChatMessages() async {
    /// local storage에 있는 메세지 더 불러오기
    setBusy(true);
    List<ChatMessage> result =
        await chatService.getMessages(chatRoom.roomId, nextPageToken);
    await Future.delayed(Duration(milliseconds: 500));
    chatMessages.insertAll(chatMessages.length, result); // ** 맨마지막에 더하기
    nextPageToken++;
    setBusy(false);
  }

  void scrollInit() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("위 도착");
        loadMoreChatMessages();
      } else if (scrollController.position.pixels == 0) {
        print("아래 도착 reload");
      } else {
        print(scrollController.position.pixels);
      }
    });
  }

  void changeScrollToLowest() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeOut,
      );
    });
  }

  resetData() {
    _chatMessages.clear();
    chatMemberInfos.clear();
    nextPageToken = 1;
  }
}
