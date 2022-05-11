import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamongcampus/src/business_logic/view_models/voice_detail_viewmodel.dart';
import 'package:zamongcampus/src/config/service_locator.dart';
import 'package:zamongcampus/src/config/size_config.dart';
import 'package:zamongcampus/src/ui/common_widgets/isLoading.dart';
import 'package:zamongcampus/src/ui/views/voice/voice_detail/components/body.dart';
import 'package:zamongcampus/src/business_logic/utils/constants.dart';
import 'package:zamongcampus/src/config/dummy_data.dart';

import 'components/body.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class VoiceDetailScreen extends StatefulWidget {
  static const routeName = '/voiceDetail';
  final int voiceRoomId;
  const VoiceDetailScreen({Key? key, required this.voiceRoomId})
      : super(key: key);

  @override
  _VoiceDetailScreenState createState() => _VoiceDetailScreenState();
}

class _VoiceDetailScreenState extends State<VoiceDetailScreen> {
  VoiceDetailViewModel vm = serviceLocator<VoiceDetailViewModel>();
  late int? _remoteUid = null;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    vm.loadVoiceRoom(widget.voiceRoomId);
    initForAgora();
  }

  void dispose() {
    leaveChannel();
    super.dispose();
  }

  Future<void> initForAgora() async {
    // permissions
    await [Permission.microphone].request();

    // create the engine
    _engine = await RtcEngine.create(appId);

    // await _engine.enableVideo();
    await _engine.enableAudio();
    _engine.enableAudioVolumeIndication(200, 3, true);

    // 2번: register 후 join하기. 이 방식이 1번보다 빠르다.
    //_engine.registerLocalUserAccount(appId, "닉네임인건가?");   //자꾸 에러떠서 일단 주석처리 유효하지 않은 사용자계정이라고 뜨는 거 같음

    _engine.setEventHandler(
      RtcEngineEventHandler(
          joinChannelSuccess: (String channel, int uid, int elapsed) {
        print("내가 join를 성공 => $uid joined");
        // 이때 uid를 넘긴다.
        setState(() {
          _localUserJoined = true;
        });
      }, userJoined: (int uid, int elapsed) {
        // 안 쓸 예정.
        print("remote user $uid joined");
      }, userOffline: (int uid, UserOfflineReason reason) {
        print("remote user $uid left channel");
        // 누가 나감.
        setState(() {
          _remoteUid = null;
        });
      }, audioVolumeIndication: (List<AudioVolumeInfo> speakers, int volume) {
        //print("hi~");  끊임없이 실행됨
        speakers.forEach((speaker) {
          if (speaker.volume > 100) {
            //볼륨 100 이상일때 프린트. 생각보다 감도가 민감함.
            print(
                "Uid ${speaker.uid}번이 Volume ${speaker.volume}크기로 말하고 있음"); //소리는 감지하는데 얼마만큼 자주?연속적으로? 실행되는지를 모르겠음
          }

          if (speaker.uid == 1) {
            // 나 자신인 경우
          }
        });
      }),
    );

    await _engine.joinChannel(
        token, channelId, null, 0); //젤 마지막 0이 본인 uid 설정하는 옵션
    // + server로 참여자 uid 와 loginId 추가. // chatmemberInfo를 줘야할까?
    // 1번: 이 아래걸로만 연결하기.
    //await _engine.joinChannelWithUserAccount(token, "0502zamong", "닉네임으로?");

    _engine.setLocalVoicePitch(1.2); //피치조절가능

    _engine.setLocalVoiceEqualization(
        AudioEqualizationBandFrequency.Band31, -15);
    _engine.setLocalVoiceEqualization(AudioEqualizationBandFrequency.Band62, 3);
    _engine.setLocalVoiceEqualization(
        AudioEqualizationBandFrequency.Band125, -9);
    _engine.setLocalVoiceEqualization(
        AudioEqualizationBandFrequency.Band250, -8);
    _engine.setLocalVoiceEqualization(
        AudioEqualizationBandFrequency.Band500, -6);
    _engine.setLocalVoiceEqualization(
        AudioEqualizationBandFrequency.Band1K, -4);
    _engine.setLocalVoiceEqualization(
        AudioEqualizationBandFrequency.Band2K, -3);
    _engine.setLocalVoiceEqualization(
        AudioEqualizationBandFrequency.Band4K, -2);
    _engine.setLocalVoiceEqualization(
        AudioEqualizationBandFrequency.Band8K, -1);
    _engine.setLocalVoiceEqualization(
        AudioEqualizationBandFrequency.Band16K, 1);

    _engine.setLocalVoiceReverb(AudioReverbType.DryLevel, 10);
    _engine.setLocalVoiceReverb(AudioReverbType.WetLevel, 7);
    _engine.setLocalVoiceReverb(AudioReverbType.RoomSize, 6);
    _engine.setLocalVoiceReverb(AudioReverbType.WetDelay, 124);
    _engine.setLocalVoiceReverb(AudioReverbType.Strength, 78);

    // _engine.setAudioEffectPreset(AudioEffectPreset.VoiceChangerEffectOldMan);
    //_engine.setAudioEffectParameters(preset, param1, param2)
  }

  Future<void> leaveChannel() async {
    print("leave channel");
    _engine.leaveChannel();
  }

  // 내 화면
  Widget _renderLocalPreview() {
    return RtcLocalView.SurfaceView();
  }

  // 상대방 화면
  Widget _renderRemoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(channelId: channelId, uid: _remoteUid!);
    } else {
      return const Text("please wait for remote user to join");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context: context);
    return ChangeNotifierProvider<VoiceDetailViewModel>(
      create: (context) => vm,
      child: Consumer<VoiceDetailViewModel>(builder: ((context, vm, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: PreferredSize(
            preferredSize: Size.fromHeight(getProportionateScreenHeight(30)),
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.expand_more_outlined),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop(); //일단은 뒤로가기로
                  },
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.person_add_outlined),
                    color: Colors.black,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.logout_outlined),
                    color: Colors.black,
                  ),
                ],
                elevation: 0.0,
                backgroundColor: const Color(0xfff8f8f8),
              ),
              backgroundColor: const Color(0xfff8f8f8),

              //body: vm.busy ? const IsLoading() : Body(vm: vm),   //원래부분
            ),
          ),
        );
      })),
    );
  }
}
