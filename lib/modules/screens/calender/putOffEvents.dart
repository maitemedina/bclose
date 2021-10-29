

import 'dart:io';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/objects/meeting.dart';
import 'package:bclose/modules/screens/home/controler/documents_controller.dart';
import 'package:bclose/util/helpers/helpers.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/confirm_media.dart';
import 'package:bclose/widgets/switch/ui_switch.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_textFields.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'calender_controller/calender_controller.dart';


class PutOffEvents_Page extends StatefulWidget {
 final AppointmentUser appointmentUser;

  const PutOffEvents_Page({ required this.appointmentUser});

  @override
  _PutOffEvents_Page  createState() => _PutOffEvents_Page();
}

class _PutOffEvents_Page extends State<PutOffEvents_Page> {

  CalenderController calendarController = Get.find();

  final TextEditingController fileName = TextEditingController();
  var myDataInit = "".obs;
  var myDataEnd = "".obs;
  var dataEndInit = DateTime.now().obs;
  var dataInit = DateTime.now().obs;
  var allDay = false.obs;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myDataInit.value = widget.appointmentUser.from.toString();
    myDataEnd.value = widget.appointmentUser.to.toString();
    dataInit.value = widget.appointmentUser.from;
    dataEndInit.value = widget.appointmentUser.to;
    

  }

  _onChageSwitch(bool command,String name){
    // setState(() {
    allDay.value = command;
    // });

    print(command);
    print(name);
  }

  _onSave(String command){
    // myDataInit.value = DateTime.now().toString();
    // if(fileName.text!=""){
      calendarController.updateAppointment(context,widget.appointmentUser.id,myDataInit.value);
    // }else{
    //   Services().pushAlert('Nome e de prenchimento obrigatório.',context);
    // }
  }

  Widget pikerDataInit(context){

    return TextButton(
      onPressed: () {
        DatePicker.showTimePicker(context,
            showTitleActions: true,
             currentTime: dataInit.value,
             onChanged: (date) {
              print('change $date in time zone ' +
                  date.timeZoneOffset.inHours.toString());
            }, onConfirm: (date) {
              print('confirm $date');
              myDataInit.value = date.toString();
              myDataEnd.value = date.toString();
              dataEndInit.value = date;
            }, locale: LocaleType.pt,);
      },
      child:  Obx(()=> Row(
        children: [

          Column(
            children: [
              UILabels.Bold(text: Util.parseDataTime(myDataInit.value), textLines: 1,color: AppColors.Black,),
              Container(
                height: 1,
                color: AppColors.Black,
                width: 60,
              )
            ],
          ),
        ],
      ),
      ),
    );
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

        elevation: 0,
        toolbarHeight: 80,
      ),
      body:  Container(
        // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
        color: AppColors.Black.withOpacity(0.5),
        alignment: Alignment.center,
        child: Container(
          width: Get.width,
          padding: EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: AppColors.White,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child:Column(

            children: [


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 32,),
                  UILabels.Bold(text: "Adiar o horário de tomar a seu medicamento", textLines: 4,color: AppColors.Blue, textAlign: TextAlign.center,fontSize: 18,),
                  SizedBox(height: 32,),
                  UILabels.Bold(text: "Horário", textLines: 4,color: AppColors.Blue, textAlign: TextAlign.left,),
                  SizedBox(height: 8,),
                  Container(
                    padding: const EdgeInsets.all(0.0),

                    decoration: BoxDecoration(
                      color: AppColors.Gray3,
                      borderRadius: BorderRadius.circular(8.0),


                    ),
                    child: pikerDataInit(context),

                  ),

                ],
              ),
              SizedBox(height: 8,),
              UILabels(text: "", textLines: 4,color: AppColors.Black,),
              SizedBox(height: 16,),
              Container(
                  height: 45,
                  padding: EdgeInsets.fromLTRB(16, 5, 16, 5),


                  child: UIBottons(
                    labels: UILabels.Bold(
                      text: "Adiar",
                      fontSize: 16,
                      textLines: 1,
                      color: AppColors.White,
                    ),
                    cb: _onSave,
                    color: AppColors.Blue, colorList: [AppColors.Blue],
                  )),

            ],
          ),
        ),
      ),

    );
  }
}
