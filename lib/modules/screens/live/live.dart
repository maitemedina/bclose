import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/screens/Notification/preview_notification.dart';
import 'package:bclose/modules/screens/live/video_call.dart';
import 'package:bclose/modules/screens/sos/edit_user.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/request_alert.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'chat.dart';
import 'live_controller/live_controller.dart';


class Live_Page extends StatefulWidget {

  @override
  _Live_Page  createState() => _Live_Page();
}

class _Live_Page extends State<Live_Page> {
  Services services = Get.put(Services());
  LiveController liveController = Get.put(LiveController());
  var userSelect = 0;
  var _switchCui = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    services.getUser();
    setState(() {
      services.getPin().then((value) => _switchCui = value);
    });
    liveController.loadingUser(context);
  }
  void onDiLoad(){

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Gray6,
     
      body: Obx(() =>Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshLocalGallery,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                color: AppColors.White,
                padding: const EdgeInsets.all(16.0),
                child: Column(

                  children: [

                    Expanded(
                      flex: 1,

                      child: Container(
                        width: Get.width,
                        alignment: Alignment.topCenter,
                        color: AppColors.White,
                        child:  liveController.userSos.length > 0 ? Padding(
                          padding: const EdgeInsets.all(0.0),
                          child:ListView.builder(
                            shrinkWrap: true,
                            itemCount: liveController.userSos.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){

                                  setState(() {
                                    // Get.to();
                                    userSelect = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.Gray4,
                                    border: userSelect == index ? Border.all(width: 4.0, color: AppColors.Blue) : Border.all(width: 0.0, color: AppColors.Blue) ,

                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Container(

                                        width: 100,
                                        height: 120,
                                        padding:  EdgeInsets.all(4.0),


                                        child: liveController.userSos[index].image != "" ? Image.network(liveController.userSos[index].image,fit: BoxFit.cover,)
                                        :
                                            Image.network('https://via.placeholder.com/140x100',fit: BoxFit.cover,)

                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              'packages/bclose/assets/icons/ic_bg_device.png',
                                              width: Get.width,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                UILabels.SemiBold(text: liveController.userSos[index].name, textLines: 2,color: AppColors.Blue,),
                                                SizedBox(height: 8,),
                                                UILabels.Regular(text: liveController.userSos[index].number, textLines: 1,color: AppColors.Black,),
                                                // Spacer(),
                                                // Container(
                                                //   height: 60,
                                                //   child: Row(
                                                //     crossAxisAlignment: CrossAxisAlignment.end,
                                                //     mainAxisAlignment: MainAxisAlignment.start,
                                                //     children: [
                                                //
                                                //       GestureDetector(
                                                //         onTap: () async {
                                                //
                                                //         },
                                                //         child: CircleAvatar(
                                                //           //child: Image.asset(name),
                                                //           backgroundColor: AppColors.White,
                                                //           radius: 20,
                                                //           child: Image.asset(
                                                //             'packages/bclose/assets/icons/ic_accept.png',
                                                //             width: 40,
                                                //             height: 40,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       SizedBox(width: 8,),
                                                //       GestureDetector(
                                                //         onTap: (){
                                                //           Get.to(PreviewNotification_Page());
                                                //         },
                                                //         child: CircleAvatar(
                                                //           //child: Image.asset(name),
                                                //           radius: 20,
                                                //           backgroundColor: AppColors.White,
                                                //
                                                //           child: Image.asset(
                                                //             'packages/bclose/assets/icons/ic_decline.png',
                                                //             width: 40,
                                                //             height: 40,
                                                //             // fit: BoxFit.cover,
                                                //           ),
                                                //         ),
                                                //       ),
                                                //
                                                //     ],
                                                //   ),
                                                // ),

                                              ],
                                          ),
                                            ),
                                          ],

                                        ),
                                      ),
                                       ],
                                  ),
                                ),
                              );

                            },
                          )

                        ):
                        Column(
                          children: [
                            Container(
                              color: AppColors.White,
                              width: 180,
                              padding: const EdgeInsets.all(0),
                              child: Column(


                                children: [
                                  SizedBox(height: 32,),
                                  UILabels.Bold(text: "FAZER ADMISSÃO", textLines: 16,color: AppColors.Blue,),
                                  SizedBox(height: 16,),
                                  QrImage(
                                    data: services.user.value.code,
                                    version: QrVersions.auto,
                                    size: 180.0,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      UILabels.Bold(text: "Uid:", textLines: 1,color: AppColors.Black,fontSize: 12,),
                                      Expanded(child: UILabels(text: services.user.value.code, textLines: 1,color: AppColors.Black,fontSize: 12,),flex:1,),
                                    ],
                                  ),

                                ],
                              ),

                            ),
                            SizedBox(height: 32,),
                            UILabels.SemiBold(text: "Caso ainda não tenha feito a sua admissão, por favor contacte os nossos serviços. Obrigado.", textLines: 12,color: AppColors.Black,),
                            SizedBox(height: 16,),
                          ],
                        ),
                      )
                    ),


                    SizedBox(height: 16,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // GestureDetector(
                        //   onTap: (){
                        //     _joinMeeting();
                        //   },
                        //   child: Image.asset(
                        //     'packages/bclose/assets/icons/ic_videochamada.png',
                        //     width: 40,
                        //     // height: Get.width/2 -32,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        // SizedBox(width: 16,),
                        GestureDetector(
                          child: Image.asset(
                            'packages/bclose/assets/icons/ic_chat.png',
                            width: 50,
                            // height: Get.width/2 -32,
                            fit: BoxFit.cover,
                          ),
                          onTap: (){
                            if(liveController.userSos.length > 0){
                              if(_switchCui){
                                Services().pushAlert('Por Favor desativa o modo cuidador para continuar.',context);
                              }else{
                                Get.to(Chat_Page(position: userSelect,));
                              }

                            }
                          },
                        ),
                        // SizedBox(width: 16,),
                        // Image.asset(
                        //   'packages/bclose/assets/icons/ic_anexar.png',
                        //   width: 40,
                        //   // height: Get.width/2 -32,
                        //   fit: BoxFit.cover,
                        // ),

                      ],
                    ),
                  ],

                ),
              ),
            ),
          ),
          if(liveController.loading.value)
            UIRequestAlert(cb: (value){liveController.loading.value = false;}, title: '', sub_title: 'A carregar as suas informações',),
        ],
      ),


      ),
    );
  }

  Future<Null> _refreshLocalGallery() async {
    print('refreshing stocks...');
    liveController.loadingUser(context);
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

  _joinMeeting() async {
    try {
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION; // Limit video resolution to 360p

      var options = JitsiMeetingOptions(room: 'teste_145')

         // Required, spaces will be trimmed
        // ..serverURL = "https://someHost.com"
        ..subject = "Meeting with Gunschu"
        ..userDisplayName = "Médico está a sua espera na Teleconsultas.";
        // ..userEmail = "myemail@email.com"
        // ..userAvatarURL = "https://someimageurl.com/image.jpg" // or .png
        // ..audioOnly = true
        // ..audioMuted = true
        // ..videoMuted = true,

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      debugPrint("error: $error");
    }
  }
}


