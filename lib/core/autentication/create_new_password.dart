
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


class Create_New_Password_CodePage extends StatefulWidget {
  final String id;

  const Create_New_Password_CodePage({Key? key, required this.id}) : super(key: key);

  @override
  _Create_New_Password_Code createState() => _Create_New_Password_Code();
}

class _Create_New_Password_Code extends State<Create_New_Password_CodePage> {
  AutenticationController autenticationController =  Get.put(AutenticationController());
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
           autenticationController.changePassword({"id":widget.id,"password":_controllerPassword.text},context);
        }else{
          Services().pushAlert('Palavras passe não coincidem. Tente novamente.',context);
        }

      }else{
        Services().pushAlert('Todos os campos são de preenchimento obrigatório.',context);
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
                      SizedBox(height: 32,),
                      Container(
                        padding: const EdgeInsets.all(0.0),

                        decoration: BoxDecoration(
                          color: AppColors.White,
                          borderRadius: BorderRadius.circular(8.0),


                        ),
                        child: Column(
                          children: [

                            UITextFields.PASSWORD(text:"Password",inputText: _controllerPassword, suffix_Icon: visiblePassword(), prefix_Icon: Icon(Icons.supervised_user_circle),passwordVisible: seePassword,),
                            Divider(height: 1,color: AppColors.Black,),
                            UITextFields.PASSWORD(text:"Confirmar Password",inputText: _controllerNewPassword, suffix_Icon: visibleNewPassword(), prefix_Icon: Icon(Icons.supervised_user_circle),passwordVisible: seeNewPassword,),


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
                              text: "Recuperar conta",
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
              UIRequestAlert(cb: _onRegister, title: 'Recuperar conta', sub_title: 'Verificando o código',)
          ],
        ),
      ),
    );
  }
}


