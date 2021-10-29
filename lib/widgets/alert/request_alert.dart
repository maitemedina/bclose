
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui_button.dart';

class UIRequestAlert extends StatelessWidget {

  final void Function(String) cb;
  final String title;
  final String sub_title;

  const UIRequestAlert({Key? key, required this.cb,required this.title, required this.sub_title}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
      color: AppColors.Black.withOpacity(0.5),
      alignment: Alignment.center,
      child: Container(
        width: Get.width,
        height: 350,
        margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
        padding: EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(4.0),


        ),
        child:Column(
          children: [
            SizedBox(height: 16,),
            UILabels.Bold(text: title, textLines: 1,color: AppColors.Black,),
            SizedBox(height: 16,),
            Expanded(child: UILabels(text: sub_title, textLines: 4,color: AppColors.Black,),flex: 1,),
            SizedBox(height: 16,),
            Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.all(16),
                child:  CircularProgressIndicator(
                  color: AppColors.Blue,
                )
            ),
            Container(
                height: 45,
                margin: EdgeInsets.fromLTRB(16, 5, 16, 5),

                child: UIBottons(
                  labels: UILabels.Bold(
                    text: "Cancelar",
                    fontSize: 16,
                    textLines: 1,
                    color: AppColors.White,
                  ),
                  cb: cb,
                  color: AppColors.Blue, colorList: [AppColors.Blue],
                )),

          ],
        ),
      ),
    );
  }

}