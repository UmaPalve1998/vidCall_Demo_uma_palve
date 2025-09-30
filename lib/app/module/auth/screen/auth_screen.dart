import "package:video/app/module/auth/controllers/auth_controller.dart";
import "package:video/app/module/auth/screen/contact_screen.dart";

import "package:video/app/utils/difenece_colors.dart";
import "package:video/app/utils/difenece_text_style.dart";

import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import "package:video/app/utils/helpers/app_language.dart";

import "../../../stores/permission_controller.dart";
import "../../../utils/helpers/app_images.dart";
import "../../../utils/helpers/flutter_navigation.dart";
import "../../../utils/helpers/globals.dart";
import "../../../utils/shared_prefernce.dart";
import "../../../utils/widgets/global_widgets.dart";
import "../../dashboard/dashboard_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  final PermissionService permissionService = Get.put(PermissionService());
  final LoginController loginController = Get.put(LoginController());

  bool _isCurrentPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final savedCreds = await SPManager.instance.getSavedCredentials();
    final savedUserId = savedCreds['userId'];
    final savedPassword = savedCreds['password'];
    final rememberMe = savedCreds['rememberMe'];

    if (rememberMe && savedUserId != null && savedPassword != null) {
      setState(() {
        _userIdController.text = savedUserId;
        _passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }

  void _login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      await loginController.login(
          _userIdController.text, _passwordController.text);
      if (loginController.loginResponse.value.access_token != null) {
        // Save or clear credentials based on remember me checkbox
        await SPManager.instance.saveCredentials(
            _userIdController.text, _passwordController.text, _rememberMe);


          pushReplacement(context, const DashboardScreen());

      } else {
        flutterToast(
            message: "Login Error" "${loginController.errorMessage.value}",
            bgColor: DifeneceColors.RedColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFEAF6FF),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Colors.lightBlue[50]!,
                  Color(0xFFEAF6FF),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(blurRadius: 10, color: Colors.black12)
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.AppLogo2,
                            width: 150,
                            height: 150,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Login",
                        style: DifeneceTextStyle.KH_BOLD.copyWith(
                          color: DifeneceColors.PBlueColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // User ID TextField with validation
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: DifeneceColors.GreyColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: DifeneceColors.PBlueColor.withOpacity(0.05),
                            blurRadius: 40,
                            offset: const Offset(0, 16),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _userIdController,
                        style: DifeneceTextStyle.KH_2.copyWith(
                          color: DifeneceColors.TextDarkColor,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(right: 12, left: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  DifeneceColors.PBlueColor.withOpacity(0.1),
                                  DifeneceColors.PBlueColor.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SvgPicture.asset(
                              "assets/images/person_icon.svg",
                              height: 20,
                              width: 20,
                              color: DifeneceColors.PBlueColor,
                            ),
                          ),
                          hintText: 'Enter your email ID',
                          hintStyle: DifeneceTextStyle.KH_2.copyWith(
                            color:
                                DifeneceColors.TextDarkColor2.withOpacity(0.6),
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                            // BorderSide(
                            //   color: DifeneceColors.PBlueColor.withOpacity(0.3),
                            //   width: 2,
                            // ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email id';
                          } else if (!isValidEmail(value.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    // Password TextField with validation
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: DifeneceColors.GreyColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: DifeneceColors.PBlueColor.withOpacity(0.05),
                            blurRadius: 40,
                            offset: const Offset(0, 16),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _isCurrentPasswordObscured,
                        style: DifeneceTextStyle.KH_2.copyWith(
                          color: DifeneceColors.TextDarkColor,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(right: 12, left: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  DifeneceColors.PBlueColor.withOpacity(0.1),
                                  DifeneceColors.PBlueColor.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SvgPicture.asset(
                              "assets/images/lock_icon.svg",
                              height: 20,
                              width: 20,
                              color: DifeneceColors.PBlueColor,
                            ),
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  DifeneceColors.PBlueColor.withOpacity(0.1),
                                  DifeneceColors.PBlueColor.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(
                                _isCurrentPasswordObscured
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: DifeneceColors.PBlueColor,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isCurrentPasswordObscured =
                                      !_isCurrentPasswordObscured;
                                });
                              },
                            ),
                          ),
                          hintText: 'Enter your Password',
                          hintStyle: DifeneceTextStyle.KH_2.copyWith(
                            color:
                                DifeneceColors.TextDarkColor2.withOpacity(0.6),
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                            // BorderSide(
                            //   color: DifeneceColors.PBlueColor.withOpacity(0.3),
                            //   width: 2,
                            // ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          errorStyle: TextStyle(height: 0),
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Remember Me Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        Text(
                          "Remember Me",
                          style: DifeneceTextStyle.KH_2.copyWith(
                            color: DifeneceColors.BlackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    // Login Button
                    GestureDetector(
                      onTap: _login,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: DifeneceColors.PBlueColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: DifeneceTextStyle.KH_1.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
