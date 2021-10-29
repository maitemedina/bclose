import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './../constants/app_colors.dart';

class UIUserMode extends StatelessWidget {


  @override

  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: Get.width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(16, 20, 0, 0),
      child: UILabels(text: "MODO CUIDADOR ATIVO", textLines: 1,fontSize: 20,color: AppColors.Blue,),
    );
  }

}
