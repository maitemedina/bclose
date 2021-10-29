
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

class UIOximeter extends StatelessWidget {
  // DeviceController deviceController =  Get.find();
  BluetoothServices deviceController =  Get.find();



  init(BuildContext context){

    var permission = deviceController.init(context);
    print("permission");
    permission.listen((event) {
      if(event)
        deviceController.startScan("BLT_M70C");
      print("event.toString()");
      print(event.toString());
      print("event.toString()");
    });
    print("permission");
  }

  @override

  Widget build(BuildContext context) {

    return Obx(()=> Stack(
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
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex:1 ,
                              child: UILabels.Regular(text: "OXIMETRO", textLines: 1,fontSize: 16,textAlign: TextAlign.left,)
                          ),
                          // ignore: unnecessary_null_comparison
                          UILabels.Regular(text: deviceController.OXIMETRO_READING.length > 0  ? Util.parseDataH( deviceController.OXIMETRO_READING[0].timestamp.toString()) :"0", textLines: 1,fontSize: 16,)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'packages/bclose/assets/device/ic_grafico_pi.png',
                                width: Get.width/2 -32,
                                height: Get.width/2 -32,
                                fit: BoxFit.cover,
                              ),
                              UILabels.Regular(text: "${deviceController.OXIMETRO_READING.length > 0  ? deviceController.OXIMETRO_READING[0].saturation : "0" }%", textLines: 1,fontSize: 24,color: AppColors.Black,)

                            ],
                          ),
                          SizedBox(height: 8,),
                          UILabels.Regular(text: "SpO2%", textLines: 1,fontSize: 24,color: AppColors.Black,)
                        ],
                      ),
                      SizedBox(width: 16,),
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'packages/bclose/assets/device/ic_grafico_pi.png',
                                width: Get.width/2 -32,
                                height: Get.width/2 -32,
                                fit: BoxFit.cover,
                              ),
                              UILabels.Regular(text: "${deviceController.OXIMETRO_READING.length > 0 ? deviceController.OXIMETRO_READING[0].perfusion : "0"}%", textLines: 1,fontSize: 24,color: AppColors.Black,)

                            ],
                          ),
                          SizedBox(height: 8,),
                          UILabels.Regular(text: "PI", textLines: 1,fontSize: 24,color: AppColors.Black,)
                        ],
                      ),

                    ],
                  ),
                  SizedBox(height: 32,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'packages/bclose/assets/device/ic_coraçao_pulso.png',
                            width: Get.width/2 -32,
                            // fit: BoxFit.cover,
                          ),
                          Row(

                            children: [
                              UILabels.Bold(text: "${deviceController.OXIMETRO_READING.length > 0 ? deviceController.OXIMETRO_READING[0].pulseRate : "0"}", textLines: 1,fontSize: 40,color: AppColors.Blue,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  UILabels.Regular(text: "PULSO", textLines: 2,fontSize: 16,color: AppColors.Black,textAlign: TextAlign.left,),
                                  UILabels.Regular(text: "BPM", textLines: 2,fontSize: 16,color: AppColors.Black,textAlign: TextAlign.left,),
                                ],
                              ),
                            ],
                          )

                        ],
                      ),
                      SizedBox(width: 16,),
                      GestureDetector(
                        onTap: (){
                          init(context);
                        },
                        child: Image.asset(
                          'packages/bclose/assets/device/ic_start.png',
                          width: 80,
                          // height: Get.width/2 -32,
                          fit: BoxFit.cover,
                        ),
                      ),

                    ],
                  ),
                ],
              )
            // Center(child: CircularProgressIndicator(color: AppColors.Blue,),),
          ),
          SizedBox(height: 8,),
          if(deviceController.OXIMETRO_SAVE.length>0)
            Column(
              children: [
                UILabels.Regular(text: "Ultima Leitura em: ${Util.parseData(deviceController.OXIMETRO_SAVE.last.timestampRegister.toString())}", textLines: 1,fontSize: 16,textAlign: TextAlign.left,color: AppColors.Black,),
                SizedBox(height: 16,),
                Container(
                  color: AppColors.White,
                  padding: const EdgeInsets.all(8.0),
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: AppColors.Black,
                          padding: const EdgeInsets.all(8.0),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
                          child: Row(
                            children: [
                              UILabels.Bold(text: deviceController.OXIMETRO_SAVE.last.saturation.toString(), textLines: 1,fontSize: 16,textAlign: TextAlign.left,color: AppColors.White,),
                              UILabels.Regular(text: "Spo2", textLines: 1,fontSize: 12,textAlign: TextAlign.left,color: AppColors.White,),
                            ],
                          ),

                        ),
                      ),
                      SizedBox(width: 8,),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: AppColors.Black,
                          padding: const EdgeInsets.all(8.0),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
                          child: Row(
                            children: [
                              UILabels.Bold(text: deviceController.OXIMETRO_SAVE.last.perfusion.toString(), textLines: 1,fontSize: 16,textAlign: TextAlign.left,color: AppColors.White,),
                              UILabels.Regular(text: "%PI", textLines: 1,fontSize: 12,textAlign: TextAlign.left,color: AppColors.White,),
                            ],
                          ),

                        ),
                      ),
                      SizedBox(width: 8,),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: AppColors.Black,
                          padding: const EdgeInsets.all(8.0),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
                          child: Row(
                            children: [
                              UILabels.Bold(text: deviceController.OXIMETRO_SAVE.last.pulseRate.toString(), textLines: 1,fontSize: 16,textAlign: TextAlign.left,color: AppColors.White,),
                              UILabels.Regular(text: "Pulso", textLines: 1,fontSize: 12,textAlign: TextAlign.left,color: AppColors.White,),
                            ],
                          ),

                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

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