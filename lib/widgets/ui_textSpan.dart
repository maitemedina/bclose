
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class UITextSpam extends StatelessWidget {
  final List<TextSpan>  textSpan;

  UITextSpam({required this.textSpan});


  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
          text: "",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.White,
          ),
          children: this.textSpan),
      textAlign: TextAlign.start,

    );
  }
}
