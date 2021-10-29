
import 'package:bclose/bluetooth/services/bluetooth_serveces.dart';
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/screens/reusables/devices/controller/device_controller.dart';
import 'package:bclose/util/helpers/helpers.dart';
import 'package:bclose/widgets/alert/info_alert.dart';
import 'package:bclose/widgets/alert/request_alert.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UIThermometer extends StatelessWidget {
  BluetoothServices deviceController =  Get.find();

  @override

  Widget build(BuildContext context) {
    return Obx(() =>  Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(

              width: Get.width,
              color: AppColors.Gray3,
              alignment: Alignment.center,
              child: Column(
                children: [

                  Container(
                    height: 40,
                    width: Get.width,
                    color: AppColors.Blue,
                    // alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex:1 ,
                              child: UILabels.Regular(text: "Termômetro", textLines: 1,fontSize: 16,textAlign: TextAlign.left,)
                          ),
                          UILabels.Regular(text:deviceController.THERMOMETER_READING.length > 0 ?  Util.parseDataH(deviceController.THERMOMETER_READING[0].timestamp.toString(),):"0", textLines: 1,fontSize: 16,)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Expanded(
                        flex:1,
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Image.asset(
                                  'packages/bclose/assets/device/ic_termometro.png',

                                  height: 280,
                                  fit: BoxFit.fitHeight,
                                ),
                                Column(
                                  children: [
                                    UILabels.Bold(text: deviceController.THERMOMETER_READING.length > 0 ? deviceController.THERMOMETER_READING[0].temperature.toStringAsFixed(1) + "˚" : "0", textLines: 1,fontSize: 16,textAlign: TextAlign.left,color: AppColors.Black,),
                                    SizedBox(
                                      height: 44,
                                    )
                                  ],
                                ),


                              ],

                            ),
                            UILabels.Bold(text: deviceController.THERMOMETER_READING.length > 0 ? deviceController.THERMOMETER_READING[0].temperature.toStringAsFixed(1) + "˚" : "0", textLines: 1,fontSize: 20,textAlign: TextAlign.left,color: AppColors.Black,),

                          ],
                        ),
                      ),

                      SizedBox(width: 16,),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: (){
                            deviceController.startScan("TEMP");
                          },
                          child: Image.asset(
                            'packages/bclose/assets/device/ic_start.png',
                            width: 80,
                            // height: Get.width/2 -32,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),



                    ],
                  ),
                  SizedBox(height: 32,),
                ],
              ),
            ),
            SizedBox(height: 8,),
            // Container(
            //   color: AppColors.White,
            //   padding: const EdgeInsets.all(8.0),
            //   height: 50,
            //   child: Row(
            //
            //     children: [
            //       Expanded(
            //         flex: 1,
            //         child: Container(
            //           color: AppColors.Black,
            //           padding: const EdgeInsets.all(8.0),
            //           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               UILabels.Bold(text: "99", textLines: 1,fontSize: 16,textAlign: TextAlign.left,color: AppColors.White,),
            //               Icon(Icons.arrow_upward_outlined,color: AppColors.White,),
            //                 ],
            //           ),
            //
            //         ),
            //       ),
            //       SizedBox(width: 8,),
            //       Expanded(
            //         flex: 1,
            //         child: Container(
            //           color: AppColors.Black,
            //           padding: const EdgeInsets.all(8.0),
            //           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               UILabels.Bold(text: "99", textLines: 1,fontSize: 16,textAlign: TextAlign.left,color: AppColors.White,),
            //               Icon(Icons.arrow_upward_outlined,color: AppColors.White,),
            //             ],
            //           ),
            //
            //         ),
            //       ),
            //       SizedBox(width: 8,),
            //       Expanded(
            //         flex: 1,
            //         child: Container(
            //           color: AppColors.Black,
            //           padding: const EdgeInsets.all(8.0),
            //           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               UILabels.Bold(text: "99", textLines: 1,fontSize: 16,textAlign: TextAlign.left,color: AppColors.White,),
            //               Icon(Icons.arrow_upward_outlined,color: AppColors.White,),
            //             ],
            //           ),
            //
            //         ),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
        if(deviceController.loadingScanning.value)
          UIRequestAlert(cb: (dhgd){deviceController.loadingScanning.value = false;}, title: 'Emparelhar', sub_title: 'A Emparelhar dispositivo',),

        if(deviceController.reading.value)
          UIRequestAlert(cb: (dhgd){deviceController.reading.value = false;}, title: 'Bhealth', sub_title: 'Estamos a fazer leitura dos seus dados. Por Favor aguarde!',),

        if(deviceController.finishSave.value)
          Container(
              height: Get.height,
              child: UIInfoAlert(cb: (dhgd){deviceController.finishSave.value = false;}, title: 'Gravar', sub_title: 'Dados gravados com sucesso!',))

      ],

    ),
    );
  }

}