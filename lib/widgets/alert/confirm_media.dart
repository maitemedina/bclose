

import 'dart:io';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../ui_button.dart';
import '../ui_textFields.dart';

class UIConfirmMediaAlert extends StatelessWidget {

  final void Function(String) cb;
  final XFile? img;
  final String sub_title;



  const UIConfirmMediaAlert({Key? key, required this.cb,required this.img, required this.sub_title}) : super(key: key);
  static final TextEditingController fileName = TextEditingController();
  @override

  Widget build(BuildContext context) {

    return Container(
      // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
      color: AppColors.Black.withOpacity(0.5),
      alignment: Alignment.center,
      child: Container(
        width: Get.width,
        height: 420,
        margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
        padding: EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child:Column(
          children: [
            UILabels(text: "Nome do ficheiro", textLines: 4,color: AppColors.Black,),
            Container(
              padding: const EdgeInsets.all(0.0),

              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(8.0),


              ),
               child: UITextFields(text:"Nome",inputText: fileName, prefix_Icon: Icon(Icons.supervised_user_circle),),

            ),
            // Image.file(File(img!.path),
            //   fit: BoxFit.cover,
            //   width: Get.width,
            //   height: 220,),
            SizedBox(height: 16,),
            UILabels(text: sub_title, textLines: 4,color: AppColors.Black,),
            SizedBox(height: 16,),
            Row(
              children: [
                Container(
                    height: 30,
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 10),

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
                Container(
                    height: 30,
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 10),

                    child: UIBottons(
                      labels: UILabels.Bold(
                        text: "Sim",
                        fontSize: 16,
                        textLines: 1,
                        color: AppColors.White,
                      ),
                      cb: cb,
                      color: AppColors.Blue, colorList: [AppColors.Blue],
                    )),
              ],
            ),

          ],
        ),
      ),
    );
  }

}