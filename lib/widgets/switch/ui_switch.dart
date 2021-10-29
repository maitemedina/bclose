
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/widgets/switch/Controller/switch_controller.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UISwitch extends StatelessWidget {


  final void Function(bool,String) cb;
  final String name;
  final bool scrollPosition;
  final bool value;
  final positionSwitch = false.obs;

  UISwitch({required this.cb, required this.name, this.scrollPosition = false,this.value = false});

  UISwitch.V({required this.cb, required this.name,this.scrollPosition = true, this.value = false});

  _onrelaodView(){
    positionSwitch.value = value;
  }

  @override

  Widget build(BuildContext context) {
    return this.scrollPosition ? verticale():horizontal();
  }

  Widget horizontal(){
    _onrelaodView();
    return GestureDetector(
      onTap: (){
        positionSwitch.value = !positionSwitch.value;
        this.cb(positionSwitch.value,this.name);
      },
      child: Obx(() =>
          Container(
            height: 60,
            width: 25,
            decoration: BoxDecoration(
              color: AppColors.Gray3,
              borderRadius: BorderRadius.circular(4.0),
              // border: Border.all(width: 1.0, color: AppColors.Gray4),

            ),
            alignment: positionSwitch.value ? Alignment.topCenter:Alignment.bottomCenter,
            child: Container(
              height: 30,
              width: 25,
              decoration: BoxDecoration(
                color: AppColors.Blue,
                borderRadius: BorderRadius.circular(4.0),
                // border: Border.all(width: 1.0, color: AppColors.Gray4),

              ),
            ),
          ),
      ),
    );
  }

  Widget verticale(){
    _onrelaodView();
    return GestureDetector(
      onTap: (){
        positionSwitch.value = !positionSwitch.value;
        this.cb(positionSwitch.value,this.name);
      },
      child: Obx(() =>
          Container(
            height: 25,
            width: 60,
            decoration: BoxDecoration(
              color: AppColors.Gray3,
              borderRadius: BorderRadius.circular(4.0),
              // border: Border.all(width: 1.0, color: AppColors.Gray4),

            ),

            child: Stack(
              children: [
                Container(
                    height: 25,
                    width: 60,
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.centerRight,
                    child: UILabels(text: "ON", textLines: 1,color: AppColors.Gray4,)),

                Container(
                  height: 25,
                  width: 60,
                  alignment: positionSwitch.value ? Alignment.centerLeft:Alignment.centerRight,
                  child: Container(
                    height: 25,
                    width: 30,

                    decoration: BoxDecoration(
                      color: positionSwitch.value ? AppColors.Blue: AppColors.Gray4,
                      borderRadius: BorderRadius.circular(4.0),
                      // border: Border.all(width: 1.0, color: AppColors.Gray4),

                    ),

                  ),
                ),


              ],
            ),
          ),
      ),
    );
  }

}