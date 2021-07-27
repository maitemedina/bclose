import 'package:flutter/material.dart';

class AppColors{

  final int alpha;

  AppColors(this.alpha);

  static const Black = Color.fromRGBO(0, 0, 0, 1);
  static const Gray4 = Color.fromRGBO(151, 151, 151, 1.0);
  static const Gray3 = Color.fromRGBO(224, 224, 224, 1);
  static const Gray6 = Color.fromRGBO(242, 242, 242, 1);
  static const BlueAction = Color.fromRGBO(0, 113, 163, 1.0);
  static const BlueAction4 = Color.fromRGBO(0, 113, 163, 0.4);
  static const Orange = Color.fromRGBO(232, 151, 51, 1);
  static const G = Color.fromRGBO(0, 229, 23, 1);
  static const White = Color.fromRGBO(255, 255, 255, 1);
  static const Gray2 = Color(0xffF2F2F2);
  static const GrayAlpha = Color(0xffE0E0E0);
  static const Blue01 = Color.fromRGBO(231, 240, 255, 1);
  static const Blue = Color(0xff4BB1D7);
  static const BlueDark = Color(0xff3C387B);
  static const Red = Color(0xffD41919);
  static const Gray = Color(0xfffafafa);
  static const bg = Color.fromRGBO(238, 238, 238, 1);
  static const GoogleColor = Color.fromRGBO(220, 78, 65, 1);
  static const FacebookColor =  Color.fromRGBO(57, 81, 133, 1);


}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}