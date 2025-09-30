import 'package:flutter/material.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import "package:path_provider/path_provider.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/module/splash/screen/splash_screen.dart';
import 'app/utils/difenece_colors.dart';
import 'app/utils/difenece_text_style.dart';
import 'app_binding.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();

  Hive.init(appDocumentDir.path);
  await Hive.openBox('fame_pocket');

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: DifeneceColors.PBlueColor, // Set status bar color
      statusBarIconBrightness: Brightness.light, // Light icons for contrast
    ),
  );

  runApp(const MyApp(),
  );
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isNotificationInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase messaging listeners after the app is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isNotificationInitialized) {
        _isNotificationInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      color: DifeneceColors.WhiteColor,
      initialBinding: AppBinding(),
      theme: ThemeData(
        primaryColor: DifeneceColors.PBlueColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: DifeneceColors.PBlueColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: DifeneceColors.PBlueColor,
            foregroundColor: Colors.white,
            textStyle: DifeneceTextStyle.KH_1.copyWith(color: Colors.white),
            elevation: 2,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}