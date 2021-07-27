import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class UILabels extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;
  final TextAlign textAlign;
  final int textLines;



  // ignore: use_key_in_widget_constructors
  const UILabels({required this.text,this.color = AppColors.White,this.fontSize = 16,this.fontWeight= FontWeight.w400,this.textDecoration = TextDecoration.none, this.textAlign = TextAlign.center,required this.textLines});

  const UILabels.Bold({required this.text,this.color = AppColors.White,this.fontSize = 16,this.fontWeight= FontWeight.w700,this.textDecoration = TextDecoration.none,this.textAlign = TextAlign.center,required this.textLines,});
  const UILabels.Regular({required this.text,this.color = AppColors.White,this.fontSize = 16,this.fontWeight= FontWeight.w400,this.textDecoration = TextDecoration.none,this.textAlign = TextAlign.center,required this.textLines,});
  const UILabels.SemiBold({required this.text,this.color = AppColors.White,this.fontSize = 16,this.fontWeight= FontWeight.w600,this.textDecoration = TextDecoration.none,this.textAlign = TextAlign.center,required this.textLines,});


  @override
  Widget build(BuildContext context) {


    return Text(
      text,
      textAlign: textAlign,
      maxLines: textLines,

      style: TextStyle(
        fontFamily: 'ProximaNova',
        fontWeight: this.fontWeight,
        fontSize: this.fontSize,
        color: this.color,
        decoration: textDecoration,
        decorationColor: this.color,
      ),



    );
  }
}



