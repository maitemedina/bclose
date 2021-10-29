


import 'dart:async';
import 'dart:io';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/constants/app_strings.dart';
import 'package:bclose/core/autentication/forgot_password_code.dart';
import 'package:bclose/core/autentication/register.dart';
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
import 'package:url_launcher/url_launcher.dart';

import 'controller/autentication_controller.dart';
import 'controller/authentication_social.dart';
import 'forgot_password.dart';


class LoginPage extends StatefulWidget {

  @override
  _Login createState() => _Login();
}

class _Login extends State<LoginPage> {

  AutenticationController autenticationController =  Get.put(AutenticationController());
  final TextEditingController _controllerEmail = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();
  var seePassword = false;

  _onRegister(String command) {
    setState(() {

    });

    setState(() {
      if(_controllerEmail.text != ""  && _controllerPassword.text != ""){
        if(Services().validarEmail(_controllerEmail.text)){
          autenticationController.login({"password":_controllerPassword.text,"email":_controllerEmail.text}, context);
        }else{
          Services().pushAlert('O email inserido não é válido.',context);
        }
      }else{
        Services().pushAlert('Todos os campos são de preenchimento obrigatório.',context);
      }
    });
  }

  _onforgotPassword(String command){
    setState(() {

      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: false,
          builder: (context) => Forgot_PasswordPage(),
        ),
      );

    });
  }

  _onGoToRegister(String command){
    setState(() {

      Get.off(RegisterPage());

    });
  }


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
  Widget gotoRegister() {
    return GestureDetector(
      onTap: (){
        _onGoToRegister("");
      },
      child: Text.rich(

        TextSpan(
            text: appAin_nta,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.Black.withAlpha(90),
            ),
            children: <TextSpan>[
              TextSpan(
                text: appReg_tar,
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
                       SizedBox(height: 64,),

                       Container(
                         padding: const EdgeInsets.all(0.0),

                         decoration: BoxDecoration(
                           color: AppColors.White,
                           borderRadius: BorderRadius.circular(8.0),


                         ),
                         child: Column(
                           children: [

                             UITextFields.EMAIL(text:"Email",inputText: _controllerEmail, prefix_Icon: Icon(Icons.supervised_user_circle),),
                             Divider(height: 1,color: AppColors.Black,),
                             UITextFields.PASSWORD(text:"Password",inputText: _controllerPassword, suffix_Icon: visiblePassword(), prefix_Icon: Icon(Icons.supervised_user_circle),passwordVisible: seePassword,),


                           ],
                         ),
                       ),
                       Container(
                           height: 50,
                           width: Get.width,
                           margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                           alignment: Alignment.center,
                           child:  UIBottons.Fat(labels: UILabels.Regular(text: appEsq_sse,fontSize: 16,textLines: 1,color: AppColors.Gray4,),cb: _onforgotPassword,color: Colors.transparent, colorList: [AppColors.Gray4],)

                       ),
                       SizedBox(height: 32,),
                       Container(
                           height: 50,
                           margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                           width: Get.width,
                           child: UIBottons(
                             labels: UILabels.Bold(
                               text: "Iniciar sessão",
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
                           child: gotoRegister()
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
           UIRequestAlert(cb: (cd){autenticationController.loading.value = false;}, title: 'Login', sub_title: 'A carregar as suas informações ',)
         ],
        ),
      ),
    );
  }
}


