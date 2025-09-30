import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:android_pip/android_pip.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../../../utils/helpers/globals.dart';

class MeetingController extends GetxController {
  final String appId = "765f3d5b39b44a76a233793493384fd1";
  final String token = "007eJxTYKjo33VM1nbphKQpAbPLjeoMyw/+iXXNs10f9OT+vrUCAYcVGMzNTNOMU0yTjC2TTEwSzc0SjYyNzS2NTSyNjS1M0lIMxW/dzmgIZGTI3PyNiZEBAkF8bobkjMS8vNQcv8TcVAYGAFY1Isg=";  ///ull if no token
  final String channelName = "google_meet_test";

  late RtcEngine engine;
  RxBool isMuted = false.obs;
  RxBool isVideoDisabled = false.obs;
  RxBool isSharing = false.obs;
  RxBool isJoined = false.obs;
  RxBool isLoading = false.obs;

  RxList<int> remoteUids = <int>[].obs;

  @override
  void onInit() {
    isLoading.value=false;
    update();
    super.onInit();
    initAgora();
  }

  Future<void> initAgora() async {
    isLoading.value=true;
    update();
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));


    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print("local user ${connection.localUid} joined");

            isJoined.value = true;
            update();

        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");

        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");

        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
    print("local user  joined");
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
    isLoading.value=false;
    update();
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    engine.muteLocalAudioStream(isMuted.value);
  }

  void toggleVideo() {
    isVideoDisabled.value = !isVideoDisabled.value;
    engine.muteLocalVideoStream(isVideoDisabled.value);
    engine.enableLocalVideo(!isVideoDisabled.value);
  }

  /// Screen share toggle (same UID)
  Future<void> startScreenShare() async {
    if (!isJoined.value || isSharing.value) return;

    await engine.updateChannelMediaOptions(
      const ChannelMediaOptions(
        publishCameraTrack: true,      // keep camera visible
        publishMicrophoneTrack: true,
        publishScreenTrack: true,      // start screen share
      ),
    );
    await PipHelper.enterPip();
    isSharing.value = true;
  }

  Future<void> stopScreenShare() async {
    if (!isJoined.value || !isSharing.value) return;

    await engine.updateChannelMediaOptions(
      const ChannelMediaOptions(
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        publishScreenTrack: false,    // stop screen share
      ),
    );

    isSharing.value = false;
  }

  /// Leave channel
  Future<void> leaveCall() async {

      await engine.stopPreview();
      if (isSharing.value) {
        await stopScreenShare();
      }
      await engine.leaveChannel();
      await engine.release();
      isJoined.value = false;
      update();

  }

  @override
  void onClose() {
    leaveCall();
    super.onClose();
  }
}


