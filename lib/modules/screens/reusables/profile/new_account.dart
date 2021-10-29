


import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/core/autentication/controller/autentication_controller.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/request_alert.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:bclose/widgets/ui_textFields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class NewAccountPage extends StatefulWidget {

  @override
  _NewAccount createState() => _NewAccount();
}

class _NewAccount extends State<NewAccountPage> {

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
                              UITextFields.PASSWORD(text:"Reference Id",inputText: _controllerPassword, suffix_Icon: visiblePassword(), prefix_Icon: Icon(Icons.supervised_user_circle),passwordVisible: seePassword,),

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
      if( _controllerName.text != "" && _controllerPassword.text != ""){


            var first_name = "";
            var last_name = "";
            var splitName = _controllerName.text.split(" ");
            first_name = splitName[0];
            if(splitName.length > 1)
              last_name = splitName[1];
            autenticationController.registerNew({"first_name": first_name,"last_name":last_name,"password":"12345678","email":"${first_name+last_name+_controllerPassword.text}@bclose.pt"}, context);

      }else{
        Services().pushAlert('Todos os campos são de preenchimento obrigatório.',context);
      }
    });
  }






}


