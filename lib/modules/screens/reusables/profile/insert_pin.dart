
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/constants/app_strings.dart';
import 'package:bclose/core/autentication/controller/autentication_controller.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/modules/screens/home/controler/home_controller.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/request_alert.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:bclose/widgets/ui_textFields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';



class InsertPinPage extends StatefulWidget {
  final String id;

  const InsertPinPage({Key? key, required this.id}) : super(key: key);

  @override
  _InsertPin createState() => _InsertPin();
}

class _InsertPin extends State<InsertPinPage> {

  AutenticationController autenticationController =  Get.put(AutenticationController());
  HomeController homeController = Get.put(HomeController());
  final TextEditingController _controllerEmail = new TextEditingController();
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

  _onRegister(String command) {
    setState(() {
      if(_controllerPassword.text != "" && _controllerNewPassword.text != ""){
        if(_controllerPassword.text ==  _controllerNewPassword.text){
          // homeController.mode_cuid.value = true;
          autenticationController.addPatient(_controllerPassword.text, _controllerEmail.text, context);


        }else{
          Services().pushAlert('Pin passes não coincidem. Tenta novamente.',context);
        }

      }else{
        Services().pushAlert('Todos os campos são de prenchimento obrigatório.',context);
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
                      SizedBox(height: 16,),
                      UILabels.Bold(
                        text: "Validar Modo CUIDADOR",
                        fontSize: 20,
                        textLines: 1,
                        color: AppColors.Black,
                      ),
                      SizedBox(height: 16,),
                      UILabels(
                        text: "Enviámos um link para seu e-mail para continuar seu registro",
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
                        child: Column(
                          children: [
                            UITextFields.EMAIL(text:"Email Cuidador",inputText: _controllerEmail, prefix_Icon: Icon(Icons.supervised_user_circle),),
                            Divider(height: 1,color: AppColors.Black,),
                            UITextFields.PASSWORD(text:"Pin",inputText: _controllerPassword, suffix_Icon: visiblePassword(), prefix_Icon: Icon(Icons.supervised_user_circle),passwordVisible: seePassword,),
                            Divider(height: 1,color: AppColors.Black,),
                            UITextFields.PASSWORD(text:"Confirmar Pin",inputText: _controllerNewPassword, suffix_Icon: visibleNewPassword(), prefix_Icon: Icon(Icons.supervised_user_circle),passwordVisible: seeNewPassword,),


                          ],
                        ),
                      ),

                      SizedBox(height: 32,),
                      Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          width: Get.width,
                          child: UIBottons(
                            labels: UILabels.Bold(
                              text: "Confirmar Pin",
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
              UIRequestAlert(cb: (cb){autenticationController.loading.value = false;}, title: 'Confirmar Pin', sub_title: 'Verificando o Pin',)
          ],
        ),
      ),
    );
  }
}


