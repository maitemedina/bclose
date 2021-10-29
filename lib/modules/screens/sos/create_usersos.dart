import 'dart:convert';
import 'dart:io';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/screens/sos/sos_controller/sos_controller.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:bclose/widgets/ui_textFields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class CreateUserSos_Page extends StatefulWidget {

  @override
  _EditUser_Page  createState() => _EditUser_Page();
}

class _EditUser_Page extends State<CreateUserSos_Page> {
  SOSController  sOSController =  Get.find();
  final ImagePicker _picker = ImagePicker();
  late File? _imageFile = null;

  final TextEditingController userName = TextEditingController();
  final TextEditingController numeber = TextEditingController();

  _onSave(String command) {
    setState(() {
      if(userName.text!=""&&numeber.text!=""){
        String base64Image = "";
        if(_imageFile != null){
          File imageFile = new File(_imageFile!.path);
          List<int> imageBytes = imageFile.readAsBytesSync();
          base64Image = base64Encode(imageBytes);
        }

        sOSController.saveUser(base64Image,"",userName.text,numeber.text,context);
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
        iconTheme: IconThemeData(
          color: AppColors.Blue, //change your color here
        ),
        centerTitle: false,


        elevation: 0,
        toolbarHeight: 80,
      ),
      body: Obx( ()=> !sOSController.loading.value ? Container(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: AppColors.White,
          width: Get.width,
          height: Get.height,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 32,),
                GestureDetector(
                  onTap: (){
                    showModalBottomSheet(context: context, builder: ((builder)=>bottomSheet()),isDismissible: true);
                  },
                  child: _imageFile != null ? CircleAvatar(
                    radius: 50,
                    child: Image.file(_imageFile!,

                      // height: Get.width/2 -32,
                      fit: BoxFit.scaleDown,
                    ),
                  ):  Image.asset(
                    'packages/bclose/assets/icons/ic_blue_foto.png',
                    width: 120,
                    // height: Get.width/2 -32,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 32,),
                UILabels(text: "NOME", textLines: 1,color: AppColors.Blue,fontSize: 18,),
                SizedBox(
                  height: 8,
                ),
                Container(
                    decoration: BoxDecoration(
                      color: AppColors.Gray6,
                      borderRadius: BorderRadius.circular(25.0),
                      // border: Border.all(width: 1.0, color: AppColors.Gray4),

                    ),
                    child: UITextFields(text:"Nome",inputText: userName, prefix_Icon: Icon(Icons.supervised_user_circle),)),

                SizedBox(height: 32,),
                UILabels(text: "NUMERO DE TELEFONE", textLines: 1,color: AppColors.Blue,fontSize: 18,),
                SizedBox(
                  height: 8,
                ),
                Container(
                    decoration: BoxDecoration(
                      color: AppColors.Gray6,
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
        ),
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
}


