
import 'package:bclose/bluetooth/services/blueTest.dart';
import 'package:bclose/bluetooth/services/bluetooth_serveces.dart';
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/constants/app_strings.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/modules/screens/Notification/notification.dart';
import 'package:bclose/modules/screens/home/controler/home_controller.dart';
import 'package:bclose/modules/screens/reusables/devices/pairing_device.dart';
import 'package:bclose/modules/screens/reusables/devices/preview_device.dart';
import 'package:bclose/modules/screens/reusables/devices/purchase_device.dart';
import 'package:bclose/modules/screens/reusables/profile/profile.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:bclose/widgets/ui_publicity.dart';
import 'package:bclose/widgets/ui_user_mode.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Home_Page extends StatefulWidget {

  @override
  _Home_Page createState() => _Home_Page();
}

class _Home_Page extends State<Home_Page> {
  HomeController homeController = Get.put(HomeController());
  BluetoothServices deviceController =  Get.put(BluetoothServices());
  var pub = true;
  var modoCui = false;
  Services services = Get.put(Services());

late List<Map<String,dynamic>> devices;

  _onfclosePub(String command){
    setState(() {
      pub = false;
    });
  }
  _getValue(String command){
    if(command == "BLT_M70C")
      return deviceController.OXIMETRO_SAVE.length > 0 ? deviceController.OXIMETRO_SAVE.last.saturation.toString() : "--";
    if(command == "TEMP")
      return deviceController.THERMOMETER_SAVE.length > 0 ? deviceController.THERMOMETER_SAVE.last.temperature.toString() : "--";
    if(command == "BPM_01")
      return deviceController.BPM_SAVE.length > 0 ? deviceController.BPM_SAVE.last.pulseRate.toString() : "--";
    return "--";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deviceController.onLoadData();
    setState(() {
      services.getPin().then((value) => modoCui = value);
    });
    devices = [{
      "img":"packages/bclose/assets/device/ic_device_oximetro.png",
      "imgDevive":"packages/bclose/assets/device/ic_oximetro.png",
      "type":"BLT_M70C",
      "name":"OXIMETRO",
      "unita":"SpO2"
    },
      {
        "img":"packages/bclose/assets/device/ic_temp.png",
        "imgDevive":"packages/bclose/assets/device/ic_img_termometro.png",
        "type":"TEMP",
        "name":"TEMP.",
        "unita":"Cº/Fº"
      },{
        "img":"packages/bclose/assets/device/ic_pressao.png",
        "imgDevive":"packages/bclose/assets/device/ic_foto_pressao.png",
        "type":"BPM_01"
        ,
        "name":"PRESSÃO",
        "unita":"Bpm"
      },{
        "img":"packages/bclose/assets/device/ic_device_fit_band.png",
        "imgDevive":"packages/bclose/assets/device/ic_img_termometro.png",
        "type":"PRESS",
        "name":"BALANÇA",
        "unita":"Kl/Lb"
      }
      // "packages/bclose/assets/device/ic_device_oximetro.png",
      // // "packages/bclose/assets/device/ic_pressao.png",
      // // "packages/bclose/assets/device/ic_device_balanca.png",
      // // "packages/bclose/assets/device/ic_device_fit_band.png",
      // "packages/bclose/assets/icons/ic_mais_dispositivpo.png",
    ];

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Gray6,

      body: SingleChildScrollView(
        child: Column(
            children: [
              if(modoCui)
              UIUserMode(),
              Container(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                      shrinkWrap: false,
                      scrollDirection: Axis.vertical,
                      itemCount: devices.length,
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              if(devices[index]["img"] == 'packages/bclose/assets/icons/ic_mais_dispositivpo.png'){
                                Services().pushAlert('Ainda em construção',context);
                              }else{
                                if(devices[index]["type"] != "PRESS")
                                Get.to(Purchase_device_Page(nameDevice: devices[index]["type"], imgDevice: devices[index]["imgDevive"],));
                              }


                            });
                          },
                          child: Card(

                            // check if the index is equal to the selected Card integer
                            color: AppColors.Gray3,

                            child: Stack(


                              children: [
                                Image.asset(
                                  devices[index]["img"],
                                  width: Get.width,
                                  height: Get.height,
                                  fit: BoxFit.cover,
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            UILabels.Bold(text: devices[index]["name"],fontSize: 20,textLines: 1,color: AppColors.Blue,),
                                            UILabels.Regular(text: devices[index]["unita"],fontSize: 16,textLines: 1,color: AppColors.Black,),
                                            Obx(()=> deviceController.OXIMETRO_SAVE.length > 0 ? UILabels.Bold(text: _getValue(devices[index]["type"]),fontSize: 24,textLines: 1,color: AppColors.Black,):
                                            UILabels.Bold(text: "--",fontSize: 24,textLines: 1,color: AppColors.Black,),
                                            )
                                             ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),



                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     // SvgPicture.network(
                                //     //   ApiPath.IMG_BASE_URL + tabBarController.Seletepreference.value[index].icon,
                                //     //   width: 20,
                                //     //   height: 20,
                                //     // ),
                                //     // SizedBox(height: 8,),
                                //     Image.asset(
                                //       'packages/bclose/assets/icons/ic_bg_device.png',
                                //       width: 20,
                                //       height: 20,
                                //       fit: BoxFit.cover,
                                //     ),
                                //
                                //     UILabels.Regular(text: "Novo",fontSize: 16,textLines: 1,color: AppColors.Blue,),
                                //
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ),
              if(pub)
              UIPublicity(cb: _onfclosePub,),

            ],
          ),
      ),
    );
  }


}


