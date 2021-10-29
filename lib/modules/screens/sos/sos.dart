import 'dart:convert';
import 'dart:typed_data';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/screens/Notification/preview_notification.dart';
import 'package:bclose/modules/screens/sos/edit_user.dart';
import 'package:bclose/modules/screens/sos/sos_controller/sos_controller.dart';
import 'package:bclose/widgets/alert/request_alert.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'create_usersos.dart';


class Sos_Page extends StatefulWidget {

  @override
  _Sos_Page  createState() => _Sos_Page();
}

class _Sos_Page extends State<Sos_Page> {
  SOSController sOSController =  Get.put(SOSController());
 var userSelect = 0;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sOSController.loadingUser(context);

  }

  _onAlertaPress(String command){
    setState(() {
      sOSController.loading.value = false;
    });
  }

  _launchCaller() async {
    var number = sOSController.userSos[userSelect].number;
    var url = "tel:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Gray6,
      body: Obx(() => Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child:  Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    color: AppColors.White,
                    child: sOSController.userSos.length > 0 ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                          shrinkWrap: false,
                          scrollDirection: Axis.vertical,
                          itemCount: sOSController.userSos.length,

                          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,

                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: (){

                                setState(() {
                                  // Get.to();
                                  userSelect = index;
                                });
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 16,),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(55.0),

                                    child: Container(

                                      width: 110,
                                      height: 110,
                                      padding:  EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.Gray4,
                                        borderRadius: BorderRadius.circular(55.0),
                                        border: userSelect == index ? Border.all(width: 4.0, color: AppColors.Blue) : Border.all(width: 0.0, color: AppColors.Blue) ,

                                      ),

                                      child: sOSController.userSos[index].image != "dbhff"? CircleAvatar(
                                        radius: 100,
                                        backgroundImage: imageFromBase64String(sOSController.userSos[index].image).image,
                                      ) :
                                      CircleAvatar(
                                        //child: Image.asset(name),
                                        radius: 100,
                                        backgroundImage:NetworkImage('https://via.placeholder.com/140x100')
                                      ),
                                      ),
                                    ),
                                  SizedBox(height: 8,),
                                  UILabels.SemiBold(text: sOSController.userSos[index].name, textLines: 2,color: AppColors.Blue,),
                                  SizedBox(height: 2,),
                                  UILabels.Regular(text: sOSController.userSos[index].number, textLines: 1,color: AppColors.Black,)
                                ],
                              ),
                            );
                          }
                      ),
                    ) : Image.asset(
                      'packages/bclose/assets/icons/ic_sem_medico.png',
                      width: 250,
                      // height: Get.width/2 -32,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 16,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(

                      onTap: (){Get.to(CreateUserSos_Page());
                      },
                      child: Image.asset(
                        'packages/bclose/assets/icons/ic_create_documento.png',
                        width: 50,
                        // height: Get.width/2 -32,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 32,),
                    GestureDetector(
                      onTap: (){
                        _launchCaller();
                      },
                      child: Image.asset(
                        'packages/bclose/assets/icons/ic_botao_ligar.png',
                        width: 80,
                        // height: Get.width/2 -32,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 32,),
                    sOSController.userSos.length > 0 ?
                    GestureDetector(
                      onTap: (){Get.to(EditUser_Page(position: userSelect,));
                      },
                      child: Image.asset(
                        'packages/bclose/assets/icons/ic_editar_perfil.png',
                        width: 50,
                        // height: Get.width/2 -32,
                        fit: BoxFit.cover,
                      ),
                    ) : Container(width: 50,),

                  ],
                ),
              ],

            ),
          ),
          if(sOSController.loading.value)
            UIRequestAlert(cb: _onAlertaPress, title: '', sub_title: 'A carregar as suas informações',)
        ],

      ),
      ),
    );
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }
}


