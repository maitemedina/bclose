import 'package:flutter/material.dart';

class AppColors{

  final int alpha;

  AppColors(this.alpha);

  // THEME COLORS
  static const Black = Color.fromRGBO(0, 0, 0, 1);
  static const White = Color.fromRGBO(255, 255, 255, 1);
  static const Gray6 = Color.fromRGBO(242, 242, 242, 1);
  static const Gray4 = Color.fromRGBO(151, 151, 151, 1.0);
  static const Gray3 = Color.fromRGBO(224, 224, 224, 1);
  static const Gray2 = Color(0xffF2F2F2);
  static const GoogleColor = Color.fromRGBO(220, 78, 65, 1);
  static const FacebookColor =  Color.fromRGBO(57, 81, 133, 1);
  static const Color GREEN = Color(0xFFB4D325);
  static const Color GREENBHEALTH = Color(0xFFB7F216);
  static const Blue = Color(0xff139DEA);



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