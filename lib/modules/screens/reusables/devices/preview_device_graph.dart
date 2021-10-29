

import 'package:bclose/bluetooth/services/bluetooth_serveces.dart';
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/util/ui/devices/widgets/graphic.dart';
import 'package:bclose/util/ui/devices/widgets/oximeter.dart';
import 'package:bclose/util/ui/devices/widgets/thermometer.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/device_controller.dart';


class PreviewGraphDevice_Page extends StatefulWidget {

  @override
  _PreviewGraphDevice_Page  createState() => _PreviewGraphDevice_Page();
}

class _PreviewGraphDevice_Page extends State<PreviewGraphDevice_Page> {

  // DeviceController deviceController =  Get.put(DeviceController());
  BluetoothServices bluetoothServices = Get.find();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if(deviceController.devicesConnect.value == DevicesConnect.OXIMETRO)
    //   deviceController.onLoadData();
    // if(deviceController.devicesConnect.value == DevicesConnect.THERMOMETER)
    // UIThermometer(),


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Gray6,
      appBar: AppBar(
        backgroundColor: AppColors.GREEN.withAlpha(95),
        iconTheme: IconThemeData(
          color: AppColors.Blue, //change your color here
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [

              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: CircleAvatar(
                  child: Image.asset('packages/bclose/assets/device/ic_back.png',
                    height: 65,width: 65,),
                  backgroundColor: AppColors.White,
                  radius: 25,

                ),
              ),
              SizedBox(width: 8,),
              CircleAvatar(
                child: Image.asset('packages/bclose/assets/icons/ic_gree_interrogacao.png',
                  height: 65,width: 65,),
                backgroundColor: AppColors.White,
                radius: 25,

              ),
              SizedBox(width: 8,),
              CircleAvatar(child: Image.asset('packages/bclose/assets/icons/ic_gree_partilhar.png',
                height: 65,width: 65,),
                backgroundColor: AppColors.White,
                radius: 25,
              ),

            ],
          ),
        ),

        elevation: 0,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child:
            Container(
                padding: const EdgeInsets.all(16.0),

                child: Column(
                  children: [
                    UIGraphc(),
                  ],
                )
            ),
      ),
    );
  }
}


