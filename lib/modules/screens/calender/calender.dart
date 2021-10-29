

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/objects/meeting.dart';
import 'package:bclose/modules/screens/calender/calender_controller/calender_controller.dart';
import 'package:bclose/modules/screens/calender/putOffEvents.dart';
import 'package:bclose/util/helpers/helpers.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'add_medications.dart';


class Calender_Page extends StatefulWidget {

  @override
  _Calender_Page  createState() => _Calender_Page();
}

class _Calender_Page extends State<Calender_Page> {
  CalenderController calendarController = Get.put(CalenderController());
  final   appointmentUser =  <AppointmentUser>[].obs;
  Services services = Get.put(Services());
  var select = 1;
  var modoCui = false;
  var initialSelectedDate = DateTime.now().obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calendarController.loadingAppointment(context);

    appointmentUser.value = calendarController.filterappointmentUser;
    setState(() {
      services.getPin().then((value) => modoCui = value);
    });

  }

  _onRemovePress(String command) {
    Get.defaultDialog(
      textConfirm: 'Sim',
      title: 'Remover',
      onConfirm: () {
        Get.back();
        calendarController.removerAppointment(context, command);
      },
      confirmTextColor: AppColors.White,
      onCancel: () {
        Get.close;
      },
      textCancel: 'Não',
      middleText: 'Tens a certeza?',
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Gray6,

      body: Obx(()=> calendarController.loading.value ? Center(child: CircularProgressIndicator(color: AppColors.Blue,),) : Container(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: _refreshLocalGallery,
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      height: 30,
                      width: Get.width,
                      color: AppColors.Gray3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex:1,
                              child: GestureDetector(
                                onTap: (){
                                  select = 1;
                                  _filterToday();

                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    height: 30,
                                    alignment: Alignment.center,
                                     color: select == 1 ? AppColors.Blue : null,
                                    child: UILabels.Regular(text: "Hoje", textLines: 1,color: select == 1 ? AppColors.White: AppColors.Black,textAlign:TextAlign.center,),
                                  ),

                                ),
                              )),
                          Expanded(
                              flex:1,
                              child: GestureDetector(
                                onTap: (){
                                  select = 2;
                                  _filterMedicamente();

                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    height: 30,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                     color: select == 2 ? AppColors.Blue : null,
                                    child: UILabels.Regular(text: "Medicamentos", textLines: 1,color: select == 2 ? AppColors.White: AppColors.Black,textAlign:TextAlign.center ,),
                                  ),

                                ),
                              )),
                          Expanded(
                              flex:1,
                              child: GestureDetector(
                                onTap: (){
                                  select = 3;

                                  _filterConsult();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    height: 30,
                                    alignment: Alignment.center,
                                    color: select == 3 ? AppColors.Blue : null,
                                    child: UILabels.Regular(text: "Consultas", textLines: 1,color: select == 3 ? AppColors.White: AppColors.Black,textAlign:TextAlign.center,),
                                  ),

                                ),
                              )),
                        ],
                      ),
                    )
                ),
                SizedBox(height: 30,),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: Get.width,
                    // color: AppColors.Gray3,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(0.0),
                    child: new ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(

                              height: 330,
                              child: SfCalendar(
                                view: CalendarView.month,
                                allowedViews: [CalendarView.month,CalendarView.week,CalendarView.day],
                                dataSource: AppointmentDataSource(calendarController.appointmentUser),
                                todayHighlightColor: AppColors.Blue,
                                initialSelectedDate: initialSelectedDate.value,

                                onTap: (value){
                                  setState(() {

                                    initialSelectedDate.value = value.date!;
                                    _filterSelect();
                                    print(appointmentUser.length);
                                  });



                                  //  value.appointments as [AppointmentUser];

                                },

                                // monthViewSettings: MonthViewSettings(
                                //     appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
                                // monthViewSettings: MonthViewSettings(showAgenda: true),
                                // timeSlotViewSettings: TimeSlotViewSettings(
                                //     startHour: 9,
                                //     endHour: 16,
                                //     nonWorkingDays: <int>[DateTime.friday, DateTime.saturday]),
                              ),
                            ),
                            SizedBox(height: 16,),
                            for(var item in appointmentUser)
                            GestureDetector(
                              onTap:(){
                                if(item.extra != "null")
                                _joinMeeting(item);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    color: item.background,
                                    height: 80,
                                    width: 3,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Container(
                                          // height: 80,
                                          width: Get.width,
                                          color: AppColors.White,
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Row(
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

                                                            UILabels(text: Util.parseDataTime(item.from.toString()), textLines: 1,color: AppColors.Black,)
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 6,
                                                        ),
                                                        UILabels.Bold(text: item.eventName != null ? item.eventName:""  , textLines: 1,color: AppColors.Black,),

                                                      ],
                                                    ),
                                                  ),
                                                  if(item.concluded != 0 )
                                                  CircleAvatar(
                                                    //child: Image.asset(name),
                                                    backgroundColor: AppColors.White,
                                                    radius: 20,
                                                    backgroundImage: AssetImage(
                                                      item.concluded == 2 ? 'packages/bclose/assets/icons/ic_horas1.png':'packages/bclose/assets/icons/ic_certo.png',

                                                    ),
                                                  ),
                                                  if(item.extra != "null")
                                                    Image.asset(
                                                      'packages/bclose/assets/icons/ic_videochamada.png',
                                                      width: 30,
                                                      // height: Get.width/2 -32,
                                                      fit: BoxFit.cover,
                                                    ),
                                                ],
                                              ),
                                              SizedBox(height: 32,),
                                              if(item.extra == "null")
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  if(item.background == AppColors.GREEN)
                                                    if(item.concluded != 1)
                                                    Container(
                                                      height: 30,
                                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),

                                                      child: UIBottons(
                                                        labels: UILabels.Regular(
                                                          text: "Adiar",
                                                          fontSize: 14,
                                                          textLines: 1,
                                                          color: AppColors.White,
                                                        ),
                                                        cb: (cb){
                                                          Get.to(PutOffEvents_Page(appointmentUser: item,));
                                                        },
                                                        color: AppColors.Blue, colorList: [AppColors.Blue],
                                                      )
                                                  ),
                                                  if(item.concluded != 1)
                                                  Container(
                                                      height: 30,
                                                      margin: EdgeInsets.fromLTRB(8, 0, 0, 10),

                                                      child: UIBottons(
                                                        labels: UILabels.Regular(
                                                          text: "Concluir",
                                                          fontSize: 14,
                                                          textLines: 1,
                                                          color: AppColors.White,
                                                        ),
                                                        cb: (cb){setState(() {
                                                           item.concluded = 1;
                                                          calendarController.updateFinishAppointment(context,item.id,item.to.toString(),item.from.toString());
                                                        });},
                                                        color: AppColors.Blue, colorList: [AppColors.Blue],
                                                      )
                                                  ),
                                                  if(item.background == AppColors.GREEN)
                                                  Container(
                                                      height: 30,
                                                      margin: EdgeInsets.fromLTRB(8, 0, 0, 10),

                                                      child: UIBottons(
                                                        labels: UILabels.Regular(
                                                          text: "Remover",
                                                          fontSize: 14,
                                                          textLines: 1,
                                                          color: AppColors.White,
                                                        ),
                                                        cb: (cb){_onRemovePress(item.id.toString());},
                                                        color: AppColors.Blue, colorList: [AppColors.Blue],
                                                      )
                                                  ),



                                                ],
                                              )
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

                          ],
                        );

                      },
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: (){
                        if(modoCui){
                          Services().pushAlert('Por Favor desativa o modo cuidador para continuar.',context);
                        }else{Get.to(AddMedications_Page());}

                      },
                      child: Image.asset(
                        'packages/bclose/assets/icons/ic_medicamentos.png',
                        width: 60,
                        // height: Get.width/2 -32,
                        fit: BoxFit.cover,
                      ),
                    ),


                  ],
                ),
              ],

            ),
          ),
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
      // ..userAvatarURL = services.user.value.image// or .png
      ..audioOnly = false
      ..audioMuted = false
      ..videoMuted = false;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  Future<Null> _refreshLocalGallery() async {
    calendarController.loadingAppointment(context);
    if(select == 1)
    _filterToday();
    if(select == 2)
      _filterMedicamente();
    if(select == 3)
      _filterConsult();

    _filterSelect();

  }
  _filterToday(){
    setState(() {

      appointmentUser.value = [];

      calendarController.filterappointmentUser.forEach((element) {
        print(element.to);

        if(element.to.year == DateTime.now().year && element.to.month == DateTime.now().month && element.to.day == DateTime.now().day)
          appointmentUser.add(element);
      });

    });
  }

  _filterSelect(){
    setState(() {

      appointmentUser.value = [];

      calendarController.filterappointmentUser.forEach((element) {
        print(element.to);

        if(element.to.year == initialSelectedDate.value.year && element.to.month == initialSelectedDate.value.month && element.to.day == initialSelectedDate.value.day)
          appointmentUser.add(element);
      });

    });
  }



  _filterMedicamente(){
    setState(() {

      appointmentUser.value = [];

      calendarController.filterappointmentUser.forEach((element) {
        print(element.to);

        if(element.type == "Medicamento")
          appointmentUser.add(element);
      });


    });
  }

  _filterConsult(){
    setState(() {

      appointmentUser.value = [];

      calendarController.filterappointmentUser.forEach((element) {
        print(element.to);

        if(element.type == "appointment")
          appointmentUser.add(element);
      });

    });
  }

}


