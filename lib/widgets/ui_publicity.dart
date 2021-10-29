
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UIPublicity extends StatelessWidget {

  final void Function(String) cb;

  const UIPublicity({Key? key, required this.cb}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: Get.width,
      color: AppColors.Gray4,
      alignment: Alignment.center,
      child: Stack(
       children: [
         Image.asset(
           'packages/bclose/assets/images/pub.jpeg',
           width: Get.width,
           height: Get.height,
           fit: BoxFit.cover,
         ),
         Padding(
           padding: const EdgeInsets.all(16.0),
           child: GestureDetector(
             onTap: ()=> cb("remove"),
             child: CircleAvatar(
               backgroundColor: AppColors.Blue,
               radius: 20,
               child: Icon(Icons.close),
             ),
           ),
         ),

       ],
      ),
    );
  }

}