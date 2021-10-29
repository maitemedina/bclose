
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/modules/objects/user.dart';
import 'package:bclose/modules/screens/reusables/profile/profile_controller/profile_controller.dart';
import 'package:bclose/util/helpers/helpers.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/switch/ui_switch.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:bclose/widgets/ui_textFields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';


class UIInfoBiometric extends StatelessWidget {

  final TextEditingController dataNas = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController height = TextEditingController();
  ProfileController  profileController =  Get.put(ProfileController());
  static ILocalStorage localStorage = new PrefsLocalStorageService();
  Services services = Get.find();
  final User userInfo;
  final position = 3.obs;

  final myDataNas = "".obs;
  var day = "".obs;
  var month = "".obs;
  var year = "".obs;




  UIInfoBiometric({Key? key,required this.userInfo,}) : super(key: key);

  onchagevalue(){

    var date = userInfo.born_date is String ? userInfo.born_date : "";


    var newdate = date.split("/");
    if (newdate.length > 2){
      day.value = newdate[0];
      month.value = newdate[1];
      year.value = newdate[2];
    }



    // profileController.weight.value = userInfo.userpatient?.weight   is String ? userInfo.userpatient?.weight :"";

    weight.text = profileController.weight.value;
    height.text = userInfo.userpatient?.height  is String ? userInfo.userpatient?.height : "";

    if(userInfo.gender.toString() == "M" )
      position.value = 1;
    if(userInfo.gender.toString() == "F" )
      position.value = 0;

  }


  _onChageSwitch(bool command,String name){
    print(command);
    print(name);
    print("command");
    print(name);

    if(name=="ALTURA"){
      if(command){
        userInfo.unitH = "1";
      }else{
        userInfo.unitH ="0";
      }
    }
    if(name=="PESO"){
      if(command){
        userInfo.unitW = "1";
      }else{
        userInfo.unitW = "0";
      }
    }
    if(name=="TEMPO"){
      if(command){
        userInfo.uinT = "1";
      }else{
        userInfo.uinT = "0";
      }
    }



   services.setUserUnit(userInfo.unitW.toString(), userInfo.uinT.toString(),userInfo.unitH.toString());

  }

  Widget pikerData(context){
    return TextButton(
        onPressed: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(1800, 3, 5),
              maxTime: DateTime.now(),
              onChanged: (date) {
                print('change $date');
              }, onConfirm: (date) {
                print('confirm $date');
                day.value = date.day.toString();
                month.value = date.month.toString();
                year.value = date.year.toString();
                userInfo.born_date = "${day}/${month}/${year}";
              }, currentTime: DateTime.now(), locale: LocaleType.pt);
        },
        child: Obx(()=> Row(
            children: [
              Column(
                children: [
                  UILabels.Bold(text: day.value, textLines: 1,color: AppColors.Black,),
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
                  UILabels.Bold(text:month.value, textLines: 1,color: AppColors.Black,),
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
                  UILabels.Bold(text:year.value, textLines: 1,color: AppColors.Black,),
                  Container(
                    height: 1,
                    color: AppColors.Black,
                    width: 40,
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget switchUI(String value1,String valu2,String name,bool value){
    return Column(
      children: [
        UILabels.Regular(text: name, textLines: 1,color: AppColors.Blue,),
        SizedBox(height: 16,),
        Row(
          children: [
            UISwitch(cb: _onChageSwitch, name: name,value: value,),
            SizedBox(width: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UILabels.Regular(text: value1, textLines: 1,color: AppColors.Gray4,),
                SizedBox(height: 8,),
                UILabels.Regular(text: valu2, textLines: 1,color: AppColors.Gray4,),
              ],
            ),
          ],
        ),
      ],
    );
  }
  Widget genreUI(){
    return Obx(()=>
        Row(
          children: [
            GestureDetector(
                  onTap: (){
                    userInfo.gender = "F";
                    position.value = 0;
                  },
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'packages/bclose/assets/icons/ic_genre_H.png',
                      height: 40,
                      // height: Get.width/2 -32,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 16,),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: position.value == 0 ? AppColors.Blue :AppColors.Blue.withAlpha(0),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(width: 2.0, color: AppColors.Gray4),

                      ),
                    ),
                  ],
              ),
                ),
            SizedBox(width: 16,),
            GestureDetector(
              onTap: (){
                userInfo.gender = "M";
                position.value = 1;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // UILabels.Regular(text: "M", textLines: 1,color: AppColors.Blue,),
                  Image.asset(
                    'packages/bclose/assets/icons/ic_genre_M.png',
                    height: 40,
                    // height: Get.width/2 -32,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16,),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: position.value == 1 ? AppColors.Blue :AppColors.Blue.withAlpha(0),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 2.0, color: AppColors.Gray4),

                    ),
                  ),
                ],
              ),
            ),
          ],
      )
    );
  }

  @override

  Widget build(BuildContext context) {
    onchagevalue();
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(16),
      color: AppColors.White,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              switchUI( 'Cm', 'Inch', 'ALTURA',userInfo.unitH == "0" ? false:true),
              switchUI( 'kg', 'lb', 'PESO',userInfo.unitW == "0" ? false:true),
              switchUI( 'Cº', 'Fº', 'TEMPO',userInfo.uinT == "0" ? false:true),

            ],
          ),
          SizedBox(height: 32,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              genreUI(),
              SizedBox(
                width: 32,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UILabels.SemiBold(text: "DATA ANIVERSÁRIO", textLines: 1,color: AppColors.Blue,fontSize: 14,textAlign: TextAlign.left,),

                    pikerData(context),
                    SizedBox(height: 16,),

                  ],


                ),
              )
            ],
          )

        ],
      ),
    );
  }

}