import 'package:android_pip/android_pip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../../utils/helpers/globals.dart';
import '../../dashboard/dashboard_screen.dart';
import '../controllers/video_call_controller.dart';
import 'package:flutter/services.dart';

class MeetingScreen extends StatefulWidget  {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> with WidgetsBindingObserver {
  final MeetingController ctrl = Get.put(MeetingController());

  double top = 20;
  double right = 20;
  bool _inPip = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    PipHelper.setPipListener((inPip) {
      setState(() => _inPip = inPip);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("state ${state}");
    if (state == AppLifecycleState.paused ) {
      _shouldEnterPiP = false;
      _enterPiP();
    }
  }

  bool _shouldEnterPiP = false;

  Future<void> onBackPressed() async {
    _shouldEnterPiP = true;
    setState(() {

    });
    Get.back(); // This triggers AppLifecycleState.resumed later
  }

  Future<void> _enterPiP() async {
    if (await AndroidPIP.isPipAvailable) {
      // Enter PiP mode instead of popping
      await AndroidPIP().enterPipMode(aspectRatio: const [16, 9]);
    }
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
     ctrl.engine.stopPreview();
    ctrl.leaveCall();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await PipHelper.enterPip();
        return false; // prevent immediate pop
      },
      child: Scaffold(
        body: Obx(() {
          if (ctrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Remote video full screen
          Widget mainVideo;
          if (ctrl.isSharing.value) {
            // Screen share is main video
            mainVideo = AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: ctrl.engine,
                canvas: VideoCanvas(uid: 1001),
                connection: RtcConnection(channelId: ctrl.channelName),
              ),
            );
          } else if (ctrl.remoteUids.isNotEmpty) {
            mainVideo = AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: ctrl.engine,
                canvas: VideoCanvas(uid: ctrl.remoteUids[0]),
                connection: RtcConnection(channelId: ctrl.channelName),
              ),
            );
          } else {
            mainVideo = const Center(
              child: Text(
                "Waiting for remote participant...",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          return Stack(
            children: [
              Positioned.fill(child: mainVideo),

              // Local camera / avatar overlay
              Positioned(
                top: top,
                right: right,
                width: 120,
                height: 160,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      top += details.delta.dy;
                      right -= details.delta.dx;
                      if (top < 0) top = 0;
                      if (top > MediaQuery.of(context).size.height - 160)
                        top = MediaQuery.of(context).size.height - 160;
                      if (right < 0) right = 0;
                      if (right > MediaQuery.of(context).size.width - 120)
                        right = MediaQuery.of(context).size.width - 120;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ctrl.isVideoDisabled.value
                        ? const Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blueGrey,
                        child: Text("UP",
                            style: TextStyle(
                                fontSize: 32, color: Colors.white)),
                      ),
                    )
                        : AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: ctrl.engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom controls
              Positioned(bottom: 16, left: 16, right: 16, child:         (!_inPip)?buildControls():SizedBox()),
            ],
          );
        }),
      ),
    );
  }
  Widget buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: "mic",
          onPressed: ctrl.toggleMute,
          child: Obx(() =>
              Icon(ctrl.isMuted.value ? Icons.mic_off : Icons.mic)),
        ),
        FloatingActionButton(
          heroTag: "video",
          onPressed: ctrl.toggleVideo,
          child: Obx(() => Icon(ctrl.isVideoDisabled.value
              ? Icons.videocam_off
              : Icons.videocam)),
        ),
        FloatingActionButton(
          heroTag: "screen",
          onPressed: ctrl.isSharing.value
              ? ctrl.stopScreenShare
              : ctrl.startScreenShare,
          child: Obx(() => Icon(ctrl.isSharing.value
              ? Icons.stop_screen_share
              : Icons.screen_share)),
        ),
        FloatingActionButton(
          heroTag: "leave",
          backgroundColor: Colors.red,
          onPressed: () async {
         await   ctrl.leaveCall();
            Navigator.pushReplacement(context,  MaterialPageRoute (
              builder: (BuildContext context) =>  DashboardScreen(),
            ));
          },
          child: const Icon(Icons.call_end),
        ),
      ],
    );
  }
}

