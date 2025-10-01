import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video/app/module/user/screen/user_list_screen.dart';

import '../../utils/difenece_colors.dart';
import '../../utils/helpers/app_images.dart';
import '../user/controllers/user_call_controller.dart';
import '../videoCal/screen/video_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VideCall",style: TextStyle(color: Colors.white),),),
      body:Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DifeneceColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: () {
                  // Get.to(MeetingScreen());
                Navigator.pushReplacement(context,  MaterialPageRoute (
                  builder: (BuildContext context) =>  MeetingScreen(),
                ));
                  },
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.call,
                        color: DifeneceColors.WhiteColor,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start Call',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            UserListScreen()
          ],
        ),
      ),
    );
  }
}
