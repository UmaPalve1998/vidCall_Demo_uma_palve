
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../difenece_colors.dart';
import '../difenece_text_style.dart';

Widget btn(String text,
    {Function()? onPressed,
    Widget? icon,
    TextStyle? txtStyle,
    Color? color,
    bool shape = false,
    bool start = true,
    String elevateBtn = 'elevated',
    double? width}) {
  final button = elevateBtn == 'elevated'
      ? ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              backgroundColor: color,
              elevation: 6,
              shape: shape
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))
                  : null),
          iconAlignment: start ? IconAlignment.start : IconAlignment.end,
          icon: icon ?? const SizedBox.shrink(),
          label: Text(
            text,
            style: txtStyle ??
                DifeneceTextStyle.KH_2.copyWith(
                  color: Colors.white,
                ),
          ),
        )
      : OutlinedButton.icon(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
              alignment: Alignment.center,
              backgroundColor: color,
              elevation: 6,
              shape: shape
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))
                  : null),
          iconAlignment: start ? IconAlignment.start : IconAlignment.end,
          icon: icon ?? const SizedBox.shrink(),
          label: Text(
            text,
            style: txtStyle ??
                DifeneceTextStyle.KH_2.copyWith(
                  color: Colors.white,
                ),
          ),
        );
  if (width != null) {
    return SizedBox(width: width, child: button);
  } else {
    return button;
  }
}

Widget txtfied(
    {TextEditingController? controller,
    String? labelText,
    String? hintTxt,
    String? Function(String?)? validator,
    String imgUrl = '',
    String? firstLabel,
    Color? secondLabelColor,
    bool prefix = true,
    String? secondLabel, // Second label text
    Color? firstLabelColor,
    void Function(PointerDownEvent)? onTapOutside}) {
  return Container(
    height: 45,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
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
        controller: controller,
        style: DifeneceTextStyle.KH_2.copyWith(
          color: DifeneceColors.TextDarkColor,
          fontWeight: FontWeight.w500,
        ),
        onTapOutside: onTapOutside,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          prefixIcon: prefix == true
              ? Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
                    imgUrl,
                    height: 8,
                    width: 8,
                    color: DifeneceColors.PBlueColor,
                  ),
                )
              : null,
          labelText: labelText,
          label: (firstLabel != null || secondLabel != null)
              ? Text.rich(
                  TextSpan(
                    children: [
                      if (firstLabel != null)
                        TextSpan(
                          text: firstLabel,
                          style: DifeneceTextStyle.KH_2_NORMAL.copyWith(
                            color: firstLabelColor ?? DifeneceColors.BlackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      if (firstLabel != null && secondLabel != null)
                        const TextSpan(text: ' '), // Space between labels
                      if (secondLabel != null)
                        TextSpan(
                          text: secondLabel,
                          style: DifeneceTextStyle.KH_2_BOLD.copyWith(
                            color:
                                secondLabelColor ?? DifeneceColors.PBlueColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                )
              : null,
          labelStyle: DifeneceTextStyle.KH_2_BOLD.copyWith(
            color: DifeneceColors.BlackColor,
            fontWeight: FontWeight.w400,
          ),
          hintText: hintTxt,
          hintStyle: DifeneceTextStyle.KH_2.copyWith(
            color: DifeneceColors.TextDarkColor2,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: DifeneceColors.PBlueColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: validator),
  );
}

SnackbarController getxSnackBar(
    {required String title,
    required String message,
    Color bgColor = DifeneceColors.BlackColor,
    Color txtColor = DifeneceColors.WhiteColor,
    SnackPosition snackPosition = SnackPosition.TOP}) {
  return Get.snackbar(title, message,
      backgroundColor: bgColor,
      colorText: txtColor,
      snackPosition: snackPosition);
}

Future<bool?> flutterToast(
    {required String message,
    ToastGravity gravity = ToastGravity.CENTER,
    // Color bgColor = DifeneceColors.BlackColor,
    Color bgColor = DifeneceColors.GreenColor,
    Color txtColor = DifeneceColors.WhiteColor,
    double fontSize = 16.0}) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      backgroundColor: bgColor,
      textColor: txtColor,
      fontSize: fontSize);
}
