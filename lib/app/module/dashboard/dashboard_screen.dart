import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video/app/module/user/screen/user_list_screen.dart';

import '../../utils/difenece_colors.dart';
import '../../utils/helpers/app_images.dart';
import '../user/controllers/user_call_controller.dart';
import '../videoCal/controllers/video_call_controller.dart';
import '../videoCal/screen/video_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MeetingController ctrl = Get.put(MeetingController());

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
                onPressed: () async {
                    final result = await showTextInputPopup(ctrl.controller,context,
                        title: 'Enter Uid', hintText: 'Type here...');

                  // Get.to(MeetingScreen());

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

/// Shows a popup dialog with one TextField and a Submit button.
/// Returns the entered text if submitted, or null if dismissed.
Future<String?> showTextInputPopup(
controller,
    BuildContext context, {
      String title = 'Input',
      String hintText = '',
      String submitLabel = 'Submit',
    }) {

  String? errorText;

  return showDialog<String>(
    context: context,
    barrierDismissible:
    false, // user must explicitly press Cancel or Submit (change if needed)
    builder: (context) {
      // Use StatefulBuilder to manage local state inside the dialog
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: hintText,
                  errorText: errorText,
                ),
                onSubmitted: (_) async {
                  // allow keyboard "done" to submit
                  final text = controller.text.trim();
                  if (text.isEmpty) {
                    setState(() => errorText = 'Please enter a UID (0,1,2)');
                    return;
                  }
                  Navigator.of(context).pop(text);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) {
                  setState(() => errorText = 'Please enter a value');
                  return;
                }
                Navigator.pop(context);
                Navigator.pushReplacement(context,  MaterialPageRoute (
                  builder: (BuildContext context) =>  MeetingScreen(),
                ));
              },
              child: Text(submitLabel),
            ),
          ],
        );
      });
    },
  );
}
