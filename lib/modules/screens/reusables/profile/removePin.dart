
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/constants/app_strings.dart';
import 'package:bclose/core/autentication/controller/autentication_controller.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/core/splash/splash.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/modules/screens/home/controler/home_controller.dart';
import 'package:bclose/modules/screens/tabBar/tabBar.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/request_alert.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:bclose/widgets/ui_textFields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';



class RemovePinPage extends StatefulWidget {
  final String id;

  const RemovePinPage({Key? key, required this.id}) : super(key: key);

  @override
  _InsertPin createState() => _InsertPin();
}

class _InsertPin extends State<RemovePinPage> {

  AutenticationController autenticationController =  Get.put(AutenticationController());
  HomeController homeController = Get.put(HomeController());
  final TextEditingController _controllerEmail = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();
  final TextEditingController _controllerNewPassword = new TextEditingController();
  static ILocalStorage localStorage = new PrefsLocalStorageService();
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

  _onRegister(String command) async {
    var cuidadorPin =  await localStorage.get("cuidadorPin").then((value) => value.toString());

    setState(() {
      if(_controllerPassword.text != ""){
        if(_controllerPassword.text ==  cuidadorPin){
          // homeController.mode_cuid.value = true;
          // autenticationController.addPatient(_controllerPassword.text, _controllerEmail.text, context);

          localStorage.put("statePin",false);

          Get.offAll(TabBarHomePage());


        }else{
          Services().pushAlert('Pin não coincidem. Tenta novamente.',context);
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
                        text: "Desativar Modo Cuidador",
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

                            UITextFields.PASSWORD(text:"Pin",inputText: _controllerPassword, suffix_Icon: visiblePassword(), prefix_Icon: Icon(Icons.supervised_user_circle),passwordVisible: seePassword,),


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
              UIRequestAlert(cb: (cb){Navigator.pop(context);}, title: 'Confirmar Pin', sub_title: 'Verificando o Pin',)
          ],
        ),
      ),
    );
  }
}


