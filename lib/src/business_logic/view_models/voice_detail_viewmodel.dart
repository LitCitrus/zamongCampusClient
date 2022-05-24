import 'package:zamongcampus/src/business_logic/models/voice_room.dart';
import 'package:zamongcampus/src/business_logic/utils/category_data.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/business_logic/utils/date_convert.dart';
import 'package:zamongcampus/src/business_logic/view_models/base_model.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/services/voice/voice_service.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class VoiceDetailViewModel extends BaseModel {
  final VoiceService _voiceService = serviceLocator<VoiceService>();
  VoiceRoomPresentation _voiceRoom = defaultVoiceRoom;
  static final VoiceRoomPresentation defaultVoiceRoom = VoiceRoomPresentation(
      id: -1,
      title: '',
      members: [],
      categories: [],
      createdAt: '',
      type: VoiceRoomType.PUBLIC);

  late RtcEngine _engine;

  VoiceRoomPresentation get voiceRoom => _voiceRoom;
  RtcEngine get engine => _engine;

  Future<void> initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile
        .Communication); // 이게 정확히 어떤 역할인지는 모르겠음.. 무조건 channel join전에만 설정가능

    await _engine.enableAudioVolumeIndication(200, 3, true); //말하는 사람 구분하기 위함
  }

  void addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      print("error code : $code");
    }, joinChannelSuccess: (String channel, int uid, int elapsed) {
      print('join 성공! uid : $uid');
    }));
  }

  void loadVoiceRoom(int voiceRoomId) async {
    setBusy(true);

    VoiceRoom voiceRoomResult =
        await _voiceService.fetchVoiceRoom(voiceRoomId: voiceRoomId);

    _voiceRoom = VoiceRoomPresentation(
        id: voiceRoomResult.voiceRoomAndTokenInfo.id,
        title: voiceRoomResult.voiceRoomAndTokenInfo.title,
        members: voiceRoomResult.membersInfo
            .map((member) => MemberPresentation(
                loginId: member.loginId,
                nickname: member.nickname,
                imageUrl:
                    member.imageUrl ?? 'assets/images/user/general_user.png',
                isHost: voiceRoomResult.voiceRoomAndTokenInfo.ownerLoginId ==
                        member.loginId
                    ? true
                    : false,
                isSpeaking: false))
            .toList(),
        categories: voiceRoomResult.categories!
            .map((category) =>
                CategoryData.iconOf(category.name) +
                " " +
                CategoryData.korNameOf(category.name))
            .toList(),
        createdAt: dateToPastTime(voiceRoomResult.createdAt),
        type: voiceRoomResult.type ?? defaultVoiceRoom.type);

    setBusy(false);
  }
}

class VoiceRoomPresentation {
  final int id;
  final String title;
  final List<MemberPresentation> members;
  final List<dynamic> categories;
  String createdAt;
  VoiceRoomType type;

  VoiceRoomPresentation(
      {required this.id,
      required this.title,
      required this.members,
      required this.categories,
      required this.createdAt,
      required this.type});
}

class MemberPresentation {
  String loginId;
  String nickname;
  String imageUrl;
  bool isSpeaking;
  bool isHost;

  MemberPresentation(
      {required this.loginId,
      required this.nickname,
      required this.imageUrl,
      required this.isSpeaking,
      required this.isHost});
}

class TextChatPresentation {}
