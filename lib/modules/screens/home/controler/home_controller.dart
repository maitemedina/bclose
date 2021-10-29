import 'package:bclose/core/autentication/create_new_password.dart';
import 'package:bclose/core/autentication/forgot_password_code.dart';
import 'package:bclose/core/splash/splash.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/modules/objects/documents.dart';
import 'package:bclose/modules/objects/user.dart';
import 'package:bclose/util/handler/request_handler.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/info_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{

  final mode_cuid =  false.obs;

  final loading = false.obs;

  Future modePriveit(String image,String data,String name,  BuildContext context)async{

    mode_cuid.value = true;

    Get.back();



  }




  _requestAlertError(BuildContext context , ErrorRequest errorRequest){
    switch (errorRequest) {
      case ErrorRequest.TimeOut:
        Services().pushAlert("The connection has timed out, Please try again!",context);
        break;
      case ErrorRequest.Internet:
        Services().pushAlert("sem conexão à Internet",context);
        break;
      case ErrorRequest.ServerError:
        Services().pushAlert("Oops, erro inesperado! Tente de Novo",context);
        break;
    }

  }



}