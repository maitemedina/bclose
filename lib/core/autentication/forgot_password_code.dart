


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
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controller/autentication_controller.dart';


class Forgot_Password_CodePage extends StatefulWidget {
  final String email;
  final String id;

  const Forgot_Password_CodePage({required this.email, required this.id});

  @override
  _Forgot_Password_Code createState() => _Forgot_Password_Code();
}

class _Forgot_Password_Code extends State<Forgot_Password_CodePage> {
  AutenticationController autenticationController =  Get.put(AutenticationController());
  final TextEditingController _controllercode = new TextEditingController();

  _onRegister(String command) {
    setState(() {
      if(_controllercode.text != ""){
        autenticationController.recuverPassword({"email":widget.email,"code":_controllercode.text},context,widget.id);
      }else{
        Services().pushAlert('Todos os campos são de preenchimento obrigatório.',context);
      }
    });
  }

  _onforgotPassword(String command){
    setState(() {
      autenticationController.newForgotPassword({"email":widget.email}, context);

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
                        text: "Enviámos um código para o seu email para verificar a sua autenticidade. Insira o código abaixo.",
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
                        child: UITextFields(text:"Código",inputText: _controllercode, prefix_Icon: Icon(Icons.supervised_user_circle),),

                      ),
                      Container(
                          height: 50,
                          width: Get.width,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          alignment: Alignment.centerRight,
                          child:  UIBottons.Fat(labels: UILabels.Regular(text: "Reenviar código",fontSize: 16,textLines: 1,color: AppColors.Blue,),cb: _onforgotPassword,color: Colors.transparent, colorList: [AppColors.Blue],)

                      ),

                      SizedBox(height: 32,),
                      Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          width: Get.width,
                          child: UIBottons(
                            labels: UILabels.Bold(
                              text: "Verificar código",
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
              UIRequestAlert(cb: (cb){autenticationController.loading.value = false;}, title: 'Recuperar conta', sub_title: 'Verificando o código',)
          ],
        ),
      ),
    );
  }
}


