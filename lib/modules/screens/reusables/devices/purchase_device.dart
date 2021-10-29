
import 'package:bclose/bluetooth/services/bluetooth_serveces.dart';
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/modules/screens/reusables/devices/preview_device.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';


class Purchase_device_Page extends StatefulWidget {
  final String nameDevice;
  final String imgDevice;

  const Purchase_device_Page({Key? key, required this.nameDevice, required this.imgDevice}) : super(key: key);

  @override
  _Purchase_device_Page  createState() => _Purchase_device_Page();
}

class _Purchase_device_Page extends State<Purchase_device_Page> {
    BluetoothServices deviceController =  Get.put(BluetoothServices());



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.nameDevice == "TEMP")
      deviceController.devicesConnect.value = DevicesConnect.THERMOMETER;
    if(widget.nameDevice == "BLT_M70C")
      deviceController.devicesConnect.value = DevicesConnect.OXIMETRO;
    if(widget.nameDevice == "BPM_01")
      deviceController.devicesConnect.value = DevicesConnect.BPM;
    deviceController.onLoadData();

  }

  _onAtiveBlue(String command){
    setState(() {
      // deviceController.loading.value = false;


    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Gray6,
      appBar: AppBar(
        backgroundColor: AppColors.GREEN.withAlpha(95),

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
      body: Stack(
          children: [
            SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UILabels.Regular(text: "DISPOSITIVO NÃO ENCONTRADO", textLines: 1,color: AppColors.Blue,),
                        SizedBox(height: 16,),
                        Image.asset(
                          widget.imgDevice,
                          width: Get.width/2 -32,
                          // fit: BoxFit.cover,
                        ),
                        SizedBox(height: 16,),

                        GestureDetector(
                          onTap: () async {
                            await launch("https://shop.bclose.pt/pt/product/oximetro-digital-bluetooth/");
                            // print("https://www.abola.pt");

                          },
                          child: Image.asset(
                            'packages/bclose/assets/device/ic_comprar.png',
                            width: 80,
                            // height: Get.width/2 -32,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16,),
                        UILabels.Regular(text: "COMPRAR", textLines: 1,color: AppColors.Blue,),
                        SizedBox(height: 16,),
                        GestureDetector(
                          onTap: () async {
                            if(widget.nameDevice == "TEMP")
                              Get.to(Preview_device_Page());
                            if(widget.nameDevice == "BLT_M70C")
                              Get.to(Preview_device_Page());
                            if(widget.nameDevice == "BPM_01")
                              Get.to(Preview_device_Page());



                          },
                          child: Image.asset(
                            'packages/bclose/assets/device/ic_emparelhar.png',
                            width: 80,
                            // height: Get.width/2 -32,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16,),
                        UILabels.Regular(text: "EMPARELHAR", textLines: 1,color: AppColors.Blue,),
                        SizedBox(height: 16,),
                        GestureDetector(
                          onTap: () async {
                            await launch("https://shop.bclose.pt/pt/product/oximetro-digital-bluetooth/");

                          },
                          child: Image.asset(
                            'packages/bclose/assets/device/ic_informaçao.png',
                            width: 80,
                            // height: Get.width/2 -32,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16,),
                        UILabels.Regular(text: "IMFORMAÇÃO", textLines: 1,color: AppColors.Blue,),

                      ],
                    )
                )
            ),
            // if(deviceController.loading.value)
            // UIRequestAlert(cb: _onAtiveBlue, title: 'Emparelhar', sub_title: 'A Emparelhar dispositivo',)
          ],

      ),
    );
  }
}