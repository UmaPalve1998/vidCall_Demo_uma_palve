import 'dart:async';


import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/helpers/app_images.dart';
import '../../../utils/shared_prefernce.dart';
import '../../auth/screen/auth_screen.dart';
import '../../dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? appVersion;

  @override
  void initState() {
    super.initState();
    _initialize();
  }



  void _initialize() async {
    // Timer to navigate after 2 seconds
    Timer(const Duration(seconds: 2), () async {
      String? token = await SPManager.instance.getToken();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => (token == null || token.isEmpty)
              ? const LoginScreen()
              : const DashboardScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.AppLogo,
              height: 150,
            ), // Replace with your logo or splash image
            const SizedBox(height: 20),
            Text(
              appVersion != null ? "Version: $appVersion" : "Loading...",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ), // Replace with your logo or splash image
      ),
    );
  }
}
