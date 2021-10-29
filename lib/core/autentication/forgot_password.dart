


import 'dart:async';
import 'dart:io';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/constants/app_strings.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/request_alert.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:bclose/widgets/ui_textFields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/autentication_controller.dart';


class Forgot_PasswordPage extends StatefulWidget {

  @override
  _Forgot_Password createState() => _Forgot_Password();
}

class _Forgot_Password extends State<Forgot_PasswordPage> {

  AutenticationController autenticationController =  Get.put(AutenticationController());
  final TextEditingController _controllerEmail = new TextEditingController();

  _onRegister(String command) {
    setState(() {
      if(Services().validarEmail(_controllerEmail.text)){
        autenticationController.forgotPassword({"email":_controllerEmail.text}, context,_controllerEmail.text);
      }else{
        Services().pushAlert('O email inserido não é válido.',context);
      }
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Gray6,
      body: Obx(
          () => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(

                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40,),
                      Image.asset(
                        'packages/bclose/assets/icons/ic_logo_bclose_wtext.png',
                        width: 260,
                      ),
                      SizedBox(height: 64,),
                      UILabels.Bold(
                        text: "Recuperar conta",
                        fontSize: 20,
                        textLines: 1,
                        color: AppColors.Black,
                      ),
                      SizedBox(height: 16,),
                      UILabels(
                        text: "Insira abaixo o seu email de registo para recuperar a sua conta Bclose.",
                        fontSize: 14,
                        textLines: 4,
                        color: AppColors.Black,
                      ),
                      SizedBox(height: 32,),
                      Container(
                        padding: const EdgeInsets.all(0.0),

                        decoration: BoxDecoration(
                          color: AppColors.White,
                          borderRadius: BorderRadius.circular(8.0),


                        ),
                        child: UITextFields.EMAIL(text:"Email",inputText: _controllerEmail, prefix_Icon: Icon(Icons.supervised_user_circle),),

                      ),

                      SizedBox(height: 32,),
                      Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          width: Get.width,
                          child: UIBottons(
                            labels: UILabels.Bold(
                              text: "Requisitar nova palavra-passe",
                              fontSize: 16,
                              textLines: 1,
                              color: AppColors.Black,
                            ),
                            cb: _onRegister,
                            color: AppColors.White, colorList: [AppColors.White],
                          )),
                      SizedBox(height: 16,),



                    ],
                  ),
                ),
              ),
            ),
            if(autenticationController.loading.value)
              UIRequestAlert(cb: _onRegister, title: 'Recuperar conta', sub_title: 'Enviámos um código para o seu email para verificar a sua autenticidade.',)
          ],
        ),
      ),
    );
  }
}


