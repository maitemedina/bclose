


import 'dart:async';
import 'dart:io';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/constants/app_strings.dart';
import 'package:bclose/core/autentication/login.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/info_alert.dart';
import 'package:bclose/widgets/alert/request_alert.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:bclose/widgets/ui_textFields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controller/autentication_controller.dart';
import 'controller/authentication_social.dart';


class RegisterPage extends StatefulWidget {

  @override
  _Register createState() => _Register();
}

class _Register extends State<RegisterPage> {
  
  AutenticationController autenticationController =  Get.put(AutenticationController());
  final TextEditingController _controllerEmail = new TextEditingController();
  final TextEditingController _controllerName = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();
  final TextEditingController _controllerNewPassword = new TextEditingController();
  var seePassword = false;
  var seeNewPassword = false;

  
  Widget visiblePassword(){
      return IconButton(iconSize: 20,icon: Icon(
        seePassword ? Icons.visibility :Icons.visibility_off,
      ),
        onPressed: (){
          setState(() {
            seePassword = !seePassword;
          });
        }
        );
  }
  Widget visibleNewPassword(){
    return IconButton(iconSize: 20,icon: Icon(
      seeNewPassword ? Icons.visibility :Icons.visibility_off,
    ),
        onPressed: (){
          setState(() {
            seeNewPassword = !seeNewPassword;
          });
        }
    );
  }
  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      child: Center(
          child: Text.rich(
            TextSpan(
                text: appEnt_sos,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.Black,
                ),
                children: <TextSpan>[

                  TextSpan(
                      text: appTer_Uso,
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.Black,
                          fontWeight: FontWeight.w700),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                           launch("https://shop.bclose.pt/pt/termos-e-condicoes/");
                          // code to open / launch terms of service link here
                        }),
                  TextSpan(
                      text: appE_as_sas,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.Black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: appPol_ade,
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.Black,
                                fontWeight: FontWeight.w700),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                 launch("https://shop.bclose.pt/pt/termos-e-condicoes/");
                                // code to open / launch privacy policy link here
                              })
                      ])
                ]),
            textAlign: TextAlign.center,
          )),
    );
  }
  Widget gotoLogin() {
    return GestureDetector(
      onTap: (){
        setState(() {

          Get.off(LoginPage());

        });
      },
      child: Text.rich(

        TextSpan(
            text: appJat_nta,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.Black.withAlpha(90),
            ),
            children: <TextSpan>[
              TextSpan(
                text: appIni_sao,
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.Black,
                    fontWeight: FontWeight.bold
                ),

              ),
            ]
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  Widget socialBtn(String image, Color color, SocialNetwork socialNetwork) {
    return FloatingActionButton(


      onPressed: () {
        switch (socialNetwork) {
          case SocialNetwork.focebook:
            AuthenticationSocial().facebookLogin();
            break;
          case SocialNetwork.google:
            AuthenticationSocial().loginGoogle();
            break;
          case SocialNetwork.apple:
            AuthenticationSocial().appleLogin();
            break;
        }
      },
      child: socialNetwork == SocialNetwork.apple ? Image.asset(
        image,
        color: AppColors.Black,
        height: 40,
        width: 40,
      ):Image.asset(
        image,
        height: 40,
        width: 40,
      ),
      backgroundColor: color,
      elevation: 0,
    );
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
            SingleChildScrollView(
              child: Padding(
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
                        SizedBox(height: 32,),

                        Container(
                          padding: const EdgeInsets.all(0.0),

                          decoration: BoxDecoration(
                            color: AppColors.White,
                            borderRadius: BorderRadius.circular(8.0),


                          ),
                          child: Column(
                            children: [
                              UITextFields(text:"Nome",inputText: _controllerName, prefix_Icon: Icon(Icons.supervised_user_circle),),
                              Divider(height: 1,color: AppColors.Black,),
                              UITextFields.EMAIL(text:"Email",inputText: _controllerEmail, prefix_Icon: Icon(Icons.supervised_user_circle),),
                              Divider(height: 1,color: AppColors.Black,),
                              UITextFields.PASSWORD(text:"Password",inputText: _controllerPassword, suffix_Icon: visiblePassword(), prefix_Icon: Icon(Icons.supervised_user_circle),passwordVisible: seePassword,),
                              Divider(height: 1,color: AppColors.Black,),
                              UITextFields.PASSWORD(text:"Confirmar Password",inputText: _controllerNewPassword, suffix_Icon: visibleNewPassword(), prefix_Icon: Icon(Icons.supervised_user_circle),passwordVisible: seeNewPassword,),

                            ],
                          ),
                        ),

                        SizedBox(height: 32,),
                        Container(
                            height: 50,
                            width: Get.width,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: UIBottons(
                              labels: UILabels.Bold(
                                text: "Sign up",
                                fontSize: 16,
                                textLines: 1,
                                color: AppColors.Black,
                              ),
                              cb: _onRegister,
                              color: AppColors.White, colorList: [AppColors.White],
                            )),
                        SizedBox(height: 16,),
                        Container(
                            height: 30,
                            width: Get.width,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            alignment: Alignment.center,
                            child: gotoLogin()
                        ),

                        SizedBox(height: 32,),
                        UILabels.Regular(
                          text: "Ou",
                          fontSize: 16,
                          textLines: 1,
                          color: AppColors.Black,
                        ),
                        SizedBox(height: 32,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            socialBtn('packages/bclose/assets/icons/ic_logo_face.png',
                                AppColors.White, SocialNetwork.focebook),
                            SizedBox(
                              width: 16,
                            ),
                            socialBtn('packages/bclose/assets/icons/ic_logo_google.png',
                                AppColors.White, SocialNetwork.google),
                            if(Platform.isIOS)
                              SizedBox(
                                width: 16,
                              ),
                            if(Platform.isIOS)
                              socialBtn('packages/bclose/assets/icons/ic_logo_apple.png',
                                  AppColors.White, SocialNetwork.apple),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                          width: Get.width,
                          child: privacyPolicyLinkAndTermsOfService(),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            if(autenticationController.loading.value)
              UIRequestAlert(cb: _onRegister, title: 'Registar', sub_title: 'Estamos a registar a sua conta. Dentro de momentos estará connosco a desfrutar da nossa aplicação.',)
          ],
        ),
      ),
    );
  }

  _onRegister(String command) {
    setState(() {
      if(_controllerEmail.text != "" && _controllerName.text != "" && _controllerPassword.text != "" &&_controllerNewPassword.text != ""){
        if(Services().validarEmail(_controllerEmail.text)){
          if (_controllerPassword.text != _controllerNewPassword.text){
            Services().pushAlert('Palavras passe não coincidem. Tente novamente.',context);
          }else{
            var first_name = "";
            var last_name = "";
            var splitName = _controllerName.text.split(" ");
            first_name = splitName[0];
            if(splitName.length > 1)
              last_name = splitName[1];
            autenticationController.register({"first_name": first_name,"last_name":last_name,"password":_controllerPassword.text,"email":_controllerEmail.text}, context);
          }
        }else{
          Services().pushAlert('O email inserido não é válido.',context);
        }
      }else{
        Services().pushAlert('Todos os campos são de preenchimento obrigatório.',context);
      }
    });
  }


}


