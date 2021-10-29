

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/objects/meeting.dart';
import 'package:bclose/modules/screens/Notification/preview_notification.dart';
import 'package:bclose/modules/screens/calender/calender_controller/calender_controller.dart';
import 'package:bclose/util/helpers/helpers.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/request_alert.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'controller/notification_controller.dart';


class Notification_Page extends StatefulWidget {

  @override
  _Notification_Page  createState() => _Notification_Page();
}

class _Notification_Page extends State<Notification_Page> {
  NotificationController notificationController = Get.put(NotificationController());
  Services services = Get.put(Services());
  var select = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    services.getUser();
    notificationController.loadingNotification(context);

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
      body: Obx(()=> Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [


                  Container(
                    height: 30,
                    width: Get.width,
                    color: AppColors.Blue,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Center(
                        child: UILabels.Regular(text: "HOJE", textLines: 1,fontSize: 16,textAlign: TextAlign.center,),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      width: Get.width,
                      color: AppColors.Gray3,
                      padding: EdgeInsets.all(16.0),
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: notificationController.appointmentUser.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(notificationController.appointmentUser[index].id.toString()),
                            // Provide a function that tells the app
                            // what to do after an item has been swiped away.
                            onDismissed: (direction) {
                              // Remove the item from the data source.

                              setState(() {
                                notificationController.appointmentUser.removeAt(index);

                              });
                              print("deleteNotification");

                              notificationController.deleteNotification(context,notificationController.appointmentUser[index].id.toString());

                              // Then show a snackbar.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text('dismissed')));
                            },
                            child: GestureDetector(
                              onTap: (){
                                if(notificationController.appointmentUser[index].extra != "null")
                                  _joinMeeting(notificationController.appointmentUser[index]);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    color: notificationController.appointmentUser[index].background,
                                    height: 80,
                                    width: 3,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: Get.width,
                                          color: AppColors.White,
                                          padding: EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex:1,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex:1,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                //child: Image.asset(name),
                                                                backgroundColor: AppColors.White,
                                                                radius: 10,
                                                                backgroundImage: AssetImage(
                                                                  'packages/bclose/assets/icons/ic_horas2.png',

                                                                ),
                                                              ),
                                                              SizedBox(width: 4,),

                                                              UILabels(text: Util.parseDataTime(notificationController.appointmentUser[index].to.toString()), textLines: 1,color: AppColors.Black,)
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          UILabels.Bold(text: notificationController.appointmentUser[index].eventName != null? notificationController.appointmentUser[index].eventName:"", textLines: 1,color: AppColors.Black,)
                                                        ],
                                                      ),
                                                    ),
                                                    if(notificationController.appointmentUser[index].extra != "null")
                                                    Image.asset(
                                                      'packages/bclose/assets/icons/ic_videochamada.png',
                                                      width: 30,
                                                      // height: Get.width/2 -32,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // CircleAvatar(
                                              //   //child: Image.asset(name),
                                              //   backgroundColor: AppColors.White,
                                              //   radius: 20,
                                              //   backgroundImage: AssetImage(
                                              //     !notificationController.appointmentUser[index].concluded ? 'packages/bclose/assets/icons/ic_horas1.png':'packages/bclose/assets/icons/ic_certo.png',
                                              //
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 16,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        },
                      ),
                    ),
                  ),



                ],

              ),
            ),
            if(notificationController.loading.value)
              UIRequestAlert(cb: (cd){notificationController.loading.value = false;}, title: '', sub_title: 'A carregar as suas informações ',)
          ],
        ),
      ),
    );
  }

  _joinMeeting(AppointmentUser alert) async {
    try {
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      featureFlag.addPeopleEnabled = false;
      featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION; // Limit video resolution to 360p

      var options = JitsiMeetingOptions(room: alert.extra)

      // Required, spaces will be trimmed
      // ..serverURL = "https://someHost.com"
      ..subject = services.user.value.username
        ..userDisplayName = alert.eventName
       ..userEmail = services.user.value.email
       // ..userAvatarURL = services.user.value.image // or .png
      ..audioOnly = false
      ..audioMuted = false
      ..videoMuted = false;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      debugPrint("error: $error");
    }
  }
}


