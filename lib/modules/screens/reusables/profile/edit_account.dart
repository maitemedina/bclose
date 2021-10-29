import 'dart:convert';
import 'dart:io';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/screens/Notification/preview_notification.dart';
import 'package:bclose/modules/screens/reusables/profile/profile_controller/profile_controller.dart';
import 'package:bclose/modules/screens/sos/sos_controller/sos_controller.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/util/ui/ui_info_biometric.dart';
import 'package:bclose/widgets/alert/request_alert.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:bclose/widgets/ui_textFields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class EditAccount_Page extends StatefulWidget {



  @override
  _EditAccount_Page  createState() => _EditAccount_Page();
}

class _EditAccount_Page extends State<EditAccount_Page> {

  Services services = Get.find();
  SOSController  sOSController =  Get.put(SOSController());
  ProfileController  profileController =  Get.put(ProfileController());


  final ImagePicker _picker = ImagePicker();
  late File? _imageFile = null;

  final TextEditingController userName = TextEditingController();
  final TextEditingController numeber = TextEditingController();
  final TextEditingController nameSos = TextEditingController();
  final TextEditingController datanas = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController height = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      userName.text = services.user.value.username;
      nameSos.text = services.user.value.sos_name;
      numeber.text = services.user.value.sos_number;
      if(services.user.value.userpatient!.weight != "null")
        weight.text= services.user.value.userpatient!.weight;
        height.text = services.user.value.userpatient!.height;

    });


  }

  _onSave(String command) {
    String base64Image = "";

    if(_imageFile != null){
      File imageFile = new File(_imageFile!.path);
      List<int> imageBytes = imageFile.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      services.user.value.image = base64Image;
    }

    services.user.value.userpatient!.weight = weight.text;
    services.user.value.userpatient!.height = height.text;
    services.user.value.username = userName.text;

    services.setUserUpdate(services.user.value);
  }

  _onSaveSOS(String command) {
    setState(() {
      if(nameSos.text!=""&&numeber.text!=""){
        services.user.value.sos_name = nameSos.text;
        services.user.value.sos_number = numeber.text;
        services.setUserUpdate(services.user.value);
        // sOSController.saveUser("", "", nameSos.text, numeber.text, context);
      }else{
        Services().pushAlert('Todos os campos são de prenchimento obrigatório.',context);
      }

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
      body: Obx( ()=> services.user.value != null ? Stack(
        children:[
          DefaultTabController(
            length:2,
            child: TabBarView(

              children: [
                Container(

                  child: SingleChildScrollView(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              SizedBox(height: 32,),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        UILabels(text: "NOME", textLines: 1,color: AppColors.Blue,fontSize: 18,),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: AppColors.White,
                                              borderRadius: BorderRadius.circular(25.0),
                                              // border: Border.all(width: 1.0, color: AppColors.Gray4),

                                            ),
                                            child: UITextFields(text:"Nome",inputText: userName, prefix_Icon: Icon(Icons.supervised_user_circle),)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16,),
                                  GestureDetector(
                                    onTap: (){
                                      showModalBottomSheet(context: context, builder: ((builder)=>bottomSheet()),isDismissible: true);
                                    },
                                    child: _imageFile != null ? Container(
                                      height: 60,
                                      width: 60,
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundImage: Image.file(_imageFile!,

                                          // height: Get.width/2 -32,
                                          fit: BoxFit.scaleDown,
                                        ).image,
                                      ),
                                    ):  Image.asset(
                                      'packages/bclose/assets/icons/ic_blue_foto.png',
                                      width: 60,
                                      // height: Get.width/2 -32,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 32,),
                              UIInfoBiometric(userInfo: services.user.value,),
                              Container(
                                width: Get.width,
                                color: AppColors.White,
                                alignment: Alignment.center,

                                padding: EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          UILabels.SemiBold(text: "ALTURA", textLines: 1,color: AppColors.Blue,fontSize: 14,textAlign: TextAlign.left,),

                                          Row(
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.White,
                                                    borderRadius: BorderRadius.circular(25.0),
                                                    // border: Border.all(width: 1.0, color: AppColors.Gray4),

                                                  ),
                                                  child: UITextFields.NUMBER(text:"••••",infoBio: true, inputText: weight,cbChenge: (){
                                                    // profileController.weight.value = weight.text;
                                                  },)),
                                              UILabels(text: services.user.value.unitH.toString() == "1" ?"Cm":"Inch", textLines: 1,color: AppColors.Black,fontSize: 14,textAlign: TextAlign.left,),

                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          UILabels.SemiBold(text: "PESO", textLines: 1,color: AppColors.Blue,fontSize: 14,textAlign: TextAlign.left,),

                                          Row(
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.White,
                                                    borderRadius: BorderRadius.circular(25.0),
                                                    // border: Border.all(width: 1.0, color: AppColors.Gray4),

                                                  ),
                                                  child: UITextFields.NUMBER(text:"••••",inputText: height,infoBio: true,cbChenge:(){
                                                    // userInfo.userpatient!.height = height.text;
                                                  })),
                                              UILabels(text: services.user.value.unitW.toString() == "1" ?"Kg":"Lb", textLines: 1,color: AppColors.Black,fontSize: 14,textAlign: TextAlign.left,),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(height: 32,),
                              Container(
                                  height: 40,
                                  margin: EdgeInsets.fromLTRB(16, 0, 16, 10),

                                  child: UIBottons(
                                    labels: UILabels.Bold(
                                      text: "Gravar",
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 60, 8, 0),
                          child: Container(
                              // height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.Blue,
                                borderRadius: BorderRadius.circular(25.0),
                                // border: Border.all(width: 1.0, color: AppColors.Gray4),

                              ),
                              child: IconButton(iconSize: 20,icon: Icon(
                                            Icons.navigate_next_sharp,
                                color: AppColors.White,
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              // seeNewPassword = !seeNewPassword;
                                            });
                                          }
                                      )
                                    ),
                        )
                            ]

                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 32,),
                        UILabels(text: "NUMEROS SOS", textLines: 1,color: AppColors.Blue,fontSize: 18,),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.White,
                              borderRadius: BorderRadius.circular(25.0),
                              // border: Border.all(width: 1.0, color: AppColors.Gray4),

                            ),
                            child: UITextFields(text:"Nome",inputText: nameSos, prefix_Icon: Icon(Icons.supervised_user_circle),)),
                        SizedBox(height: 16,),
                        Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.White,
                              borderRadius: BorderRadius.circular(25.0),
                              // border: Border.all(width: 1.0, color: AppColors.Gray4),

                            ),
                            child: UITextFields.NUMBER(text:"Numero de telefone",inputText: numeber, prefix_Icon: Icon(Icons.supervised_user_circle),)),
                        SizedBox(height: 32,),
                        Container(
                            height: 40,
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 10),

                            child: UIBottons(
                              labels: UILabels.Bold(
                                text: "ACEITAR",
                                fontSize: 16,
                                textLines: 1,
                                color: AppColors.White,
                              ),
                              cb: _onSaveSOS,
                              color: AppColors.Blue, colorList: [AppColors.Blue],
                            )),

                      ],

                    ),
                  ),
                ),
              ],
            ),
          ),
          if(services.loading.value)
            UIRequestAlert(cb: (value){services.loading.value= false;}, title: '', sub_title: 'A carregar as suas informações ',),
          if(sOSController.loading.value)
            UIRequestAlert(cb: (value){sOSController.loading.value = false;}, title: '', sub_title: 'A carregar as suas informações ',)

        ]

      ) : Center(child: CircularProgressIndicator(color: AppColors.Blue,),),
      ),
    );
  }



  Widget bottomSheet(){
    return Container(
      height: 100,
      width: Get.width,
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Text("Escolha a tua Foto de Perfil", style: TextStyle(fontSize: 20),),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                icon: Icon(Icons.camera),
                label: Text("Camera"),
                onPressed: (){
                  Navigator.pop(context);
                  takePhoto(ImageSource.camera);
                },
              ),
              FlatButton.icon(
                icon: Icon(Icons.image),
                label: Text("Gallery"),
                onPressed: (){
                  Navigator.pop(context);
                  takePhoto(ImageSource.gallery);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    // profileController.postUploadPhoto(File(pickedFile.path));
  }

  culculeCm(value){
    var result = 0;
    if(services.user.value.unitH=="1")


    return 123;
  }
}




