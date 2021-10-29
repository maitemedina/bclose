

import 'dart:io';

import 'package:bclose/constants/app_colors.dart';
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


class AddMedications_Page extends StatefulWidget {


  @override
  _AddMedications_Page  createState() => _AddMedications_Page();
}

class _AddMedications_Page extends State<AddMedications_Page> {

  CalenderController calendarController = Get.find();

  final TextEditingController fileName = TextEditingController();
  var myDataInit = "".obs;
  var myDataEnd = "".obs;
  var dataEndInit = DateTime.now().obs;
  var allDay = false.obs;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
    if(fileName.text!=""){
      calendarController.saveAppointment(myDataInit.value, myDataEnd.value, fileName.text, allDay.value, context);
    }else{
      Services().pushAlert('Nome e de prenchimento obrigatório.',context);
    }
  }

  Widget pikerDataInit(context){

    return TextButton(
        onPressed: () {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: DateTime(2050, 6, 7, 05, 09), onChanged: (date) {
                print('change $date in time zone ' +
                    date.timeZoneOffset.inHours.toString());
              }, onConfirm: (date) {
                print('confirm $date');
                myDataInit.value = date.toString();
                myDataEnd.value = date.toString();
                dataEndInit.value = date;
              }, locale: LocaleType.pt);
        },
        child:  Obx(()=> Row(
            children: [
              Column(
                children: [
                  UILabels.Bold(text: Util.parseDataD(myDataInit.value), textLines: 1,color: AppColors.Black,),
                  Container(
                    height: 1,
                    color: AppColors.Black,
                    width: 20,
                  )
                ],
              ),
              SizedBox(width: 8,),
              Column(
                children: [
                  UILabels.Bold(text: Util.parseDataM(myDataInit.value), textLines: 1,color: AppColors.Black,),
                  Container(
                    height: 1,
                    color: AppColors.Black,
                    width: 20,
                  )
                ],
              ),
              SizedBox(width: 8,),
              Column(
                children: [
                  UILabels.Bold(text: Util.parseDataY(myDataInit.value), textLines: 1,color: AppColors.Black,),
                  Container(
                    height: 1,
                    color: AppColors.Black,
                    width: 40,
                  )
                ],
              ),
              SizedBox(width: 8,),
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
  Widget pikerDataEnd(context){

    return TextButton(
      onPressed: () {
        if(allDay.value)
        DatePicker.showDateTimePicker(context,
            showTitleActions: true,
            minTime: dataEndInit.value,
            maxTime: DateTime(2050, 6, 7, 05, 09), onChanged: (date) {
              print('change $date in time zone ' +
                  date.timeZoneOffset.inHours.toString());
            }, onConfirm: (date) {
              print('confirm $date');
              myDataEnd.value = date.toString();
            }, locale: LocaleType.pt);
      },
      child:  Obx(()=> Row(
        children: [
          Column(
            children: [
              UILabels.Bold(text: Util.parseDataD(myDataEnd.value), textLines: 1,color: !allDay.value ? AppColors.Black.withAlpha(80) : AppColors.Black ,),
              Container(
                height: 1,
                color: AppColors.Black,
                width: 20,
              )
            ],
          ),
          SizedBox(width: 8,),
          Column(
            children: [
              UILabels.Bold(text: Util.parseDataM(myDataEnd.value), textLines: 1,color: !allDay.value ? AppColors.Black.withAlpha(80) : AppColors.Black ,),
              Container(
                height: 1,
                color: AppColors.Black,
                width: 20,
              )
            ],
          ),
          SizedBox(width: 8,),
          Column(
            children: [
              UILabels.Bold(text: Util.parseDataY(myDataEnd.value), textLines: 1,color: !allDay.value ? AppColors.Black.withAlpha(80) : AppColors.Black ,),
              Container(
                height: 1,
                color: AppColors.Black,
                width: 40,
              )
            ],
          ),
          SizedBox(width: 8,),
          Column(
            children: [
              UILabels.Bold(text: Util.parseDataTime(myDataEnd.value), textLines: 1,color: !allDay.value ? AppColors.Black.withAlpha(80) : AppColors.Black ,),
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
    myDataEnd.value = DateTime.now().toString();
    myDataInit.value = DateTime.now().toString();
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
                      UILabels.Bold(text: "Nome do medicamento", textLines: 4,color: AppColors.Blue, textAlign: TextAlign.left,),
                      SizedBox(height: 8,),
                      Container(
                        padding: const EdgeInsets.all(0.0),

                        decoration: BoxDecoration(
                          color: AppColors.Gray3,
                          borderRadius: BorderRadius.circular(8.0),


                        ),
                        child: UITextFields(text:"Nome",inputText: fileName, prefix_Icon: Icon(Icons.supervised_user_circle),),

                      ),
                      SizedBox(height: 32,),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                          child: UILabels.Bold(text: "Todos os dias", textLines: 1,color: AppColors.Black, textAlign: TextAlign.left,)),
                      UISwitch.V(cb: _onChageSwitch, name: "todos",),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 32,),
                      UILabels.Bold(text: "Data início", textLines: 4,color: AppColors.Blue, textAlign: TextAlign.left,),
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

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 32,),
                      UILabels.Bold(text: "Data fim", textLines: 4,color: AppColors.Blue, textAlign: TextAlign.left,),
                      SizedBox(height: 8,),
                      Obx(() => Container(
                          padding: const EdgeInsets.all(0.0),

                          decoration: BoxDecoration(
                            color: !allDay.value ? AppColors.Gray3.withAlpha(80):AppColors.Gray3,
                            borderRadius: BorderRadius.circular(8.0),


                          ),
                          child: pikerDataEnd(context),

                        ),
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
                          text: "Gravar ",
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
