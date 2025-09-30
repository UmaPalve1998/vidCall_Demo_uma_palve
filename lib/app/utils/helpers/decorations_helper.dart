
import 'package:flutter/material.dart';

import '../difenece_colors.dart';
import '../difenece_text_style.dart';

class DecorationsHelper{
  static const KInputRadius = BorderRadius.all(Radius.circular(1.71));
  static const KInputRadiusCricle = BorderRadius.all(Radius.circular(8));
  static InputDecoration KInputSytleBorder = InputDecoration(
    filled: true,
    fillColor:  DifeneceColors.WhiteColor,
    hintText: "",
    hintStyle: DifeneceTextStyle.KH_3_BOLD.copyWith(
        color: DifeneceColors.TextDarkColor2
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
    border: const OutlineInputBorder(
        borderSide: BorderSide(color: DifeneceColors.PBlueColor2,width: 0.8,),
        borderRadius: KInputRadius),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: DifeneceColors.PBlueColor2,width: 0.8),
        borderRadius: KInputRadius),
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: DifeneceColors.PBlueColor2,width: 0.8),
        borderRadius: KInputRadius),
    // labelText: '',
    // labelStyle:AppUtils.KH8,
    floatingLabelStyle: const TextStyle(color: DifeneceColors.PBlueColor2),
  );

  static InputDecoration KInputStyleWithoutBorder = InputDecoration(
    filled: true,
    fillColor: DifeneceColors.WhiteColor,
    hintText: "",
    hintStyle: DifeneceTextStyle.KH_3_BOLD.copyWith(
      color: DifeneceColors.TextDarkColor2,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
    border: InputBorder.none, // No border
    focusedBorder: InputBorder.none, // No border when focused
    enabledBorder: InputBorder.none, // No border when enabled
    floatingLabelStyle: const TextStyle(color: DifeneceColors.PBlueColor2),
  );
}
