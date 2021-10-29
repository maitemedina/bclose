

import 'package:bclose/bluetooth/services/bluetooth_serveces.dart';
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/util/ui/devices/widgets/bpm.dart';
import 'package:bclose/util/ui/devices/widgets/oximeter.dart';
import 'package:bclose/util/ui/devices/widgets/thermometer.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/device_controller.dart';


class PreviewDeviceGraph_Page extends StatefulWidget {

  @override
  _PreviewDeviceGraph_Page  createState() => _PreviewDeviceGraph_Page();
}

class _PreviewDeviceGraph_Page extends State<PreviewDeviceGraph_Page> {

  DeviceController deviceController =  Get.find();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(deviceController.devicesConnect.value == DevicesConnect.OXIMETRO)
      deviceController.onLoadData();
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
        title: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              CircleAvatar(
                //child: Image.asset(name),
                radius: 20,
                backgroundColor: AppColors.White,
                backgroundImage: AssetImage(
                  'packages/bclose/assets/device/ic_bola_graficos.png',

                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              // Get.to(Profile_page());
            },
            child: Row(
              children: [
                Container(

                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    //child: Image.asset(name),
                      radius: 50,
                      backgroundImage:NetworkImage('https://via.placeholder.com/140x100')
                  ),
                ),
                Icon(Icons.more_vert,color: AppColors.Black,),
                SizedBox(width: 16,)
              ],
            ),
          ),
        ],
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
          child: Obx(()=>
              Container(
                  padding: const EdgeInsets.all(16.0),

                  child: Column(
                    children: [
                      if(deviceController.devicesConnect.value == DevicesConnect.OXIMETRO)
                        UIOximeter(),
                      if(deviceController.devicesConnect.value == DevicesConnect.THERMOMETER)
                        UIThermometer(),
                      if(deviceController.devicesConnect.value == DevicesConnect.BPM)
                        UIBpm(),
                    ],
                  )
              ),
          )
      ),
    );
  }
}


