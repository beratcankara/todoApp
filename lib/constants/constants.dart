import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static const mainColor = Color.fromRGBO(26, 18, 11, 100);
  static const secColor = Color.fromRGBO(60, 42, 33, 100);
  static const lightColor = Color.fromRGBO(213, 206, 163, 100);
  static const lastColor = Color.fromRGBO(229, 229, 203, 100);
  static final titleTextStyle = GoogleFonts.odibeeSans(
      color: lastColor, fontWeight: FontWeight.bold, fontSize: 32);
  static labelTextStyle(double? fontSize, bool isCompleted) {
    return GoogleFonts.odibeeSans(
        color: isCompleted ? lastColor.withOpacity(.4) : lastColor,
        fontSize: fontSize,
        decoration:
            isCompleted ? TextDecoration.lineThrough : TextDecoration.none);
  }
}
