import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonMessage{
  static showsnackBar(snackMessage){
    return Get.snackbar(
      'VidCall',
      snackMessage,
      colorText: Colors.white,
      backgroundColor: Colors.black87,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0,),
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0, vertical: 18.0,),
      borderRadius: 5.0,
      duration: const Duration(seconds: 2,),
    );
  }
}