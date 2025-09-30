
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../difenece_colors.dart';


class DialogHelper {
  //show error dialog
  static void showErroDialog(
      {String title = 'Error', String? description = 'Something went wrong'}) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headlineLarge,
              ),
              Text(
                description ?? '',
                style: Get.textTheme.headlineMedium,
              ),
              ElevatedButton(
                onPressed: () {
                  if (Get.isDialogOpen!) Get.back();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showTimeErroDialog(
      {String title = 'Error!', String? description = 'Something went wrong'}) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headlineSmall?.copyWith(fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                description ?? '',
                style: Get.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (Get.isDialogOpen!) Get.back();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showTimeErroDialog2(
      {String title = 'Error', String? description = 'Something went wrong'}) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headlineSmall,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                description ?? '',
                style: Get.textTheme.bodySmall,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (Get.isDialogOpen!) Get.back();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //show loading
  static showLoading([String? message]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isDialogOpen!) {
        Get.dialog(
          Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: DifeneceColors.PBlueColor2,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Text(
                    message ?? 'Loading Please wait...',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }



  //hide loading
  static void hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }
}
