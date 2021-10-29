import 'package:bclose/core/autentication/create_new_password.dart';
import 'package:bclose/core/autentication/forgot_password_code.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/core/splash/splash.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/modules/objects/documents.dart';
import 'package:bclose/modules/objects/user.dart';
import 'package:bclose/modules/objects/user_sos.dart';
import 'package:bclose/util/handler/request_handler.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/info_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

class SOSController extends GetxController{
  static ILocalStorage localStorage = new PrefsLocalStorageService();
  final userSos =  <UserSos>[].obs;

  final loading = false.obs;

  Future saveUser(String image,String morada,String name, String number, BuildContext context)async{

    loading.value = true;

    var id =   await localStorage.get("id").then((value) => value.toString());
    var body = {
      "user_id": id,
      "name1": name,
      "address1": morada,
      "phone_number1": number,
      "image1": image,
      "type": "MOBILE"
    };

    var value = await RequestHandler.servicesPost(body,"patient/emergencyContact/create");

    loading.value = false;
    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
      //setUser()
    }else{
      print(value);
      loadingUser(context);
      Get.back();
    }



  }

  Future UpateUser(String image,String morada,String name, String number,String idConteu, BuildContext context)async{

    loading.value = true;

    var id =   await localStorage.get("id").then((value) => value.toString());
    var body = {
      "user_id": id,
      "name1": name,
      "address1": morada,
      "phone_number1": number,
      "image1": image
    };

    var value = await RequestHandler.servicesPut(body,"patient/emergencyContact/edit/$idConteu");

        loading.value = false;
    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
      //setUser()
    }else{
      print(value);
      loadingUser(context);
      Get.back();
    }



  }

  Future RemoveUser(String idConteu, BuildContext context)async{

    loading.value = true;

    var id =   await localStorage.get("id").then((value) => value.toString());
    var body = {
      "user_id": id,
    };

    var value = await RequestHandler.servicesDelete(body,"patient/emergencyContact/delete/$idConteu");

    loading.value = false;
    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
      //setUser()
    }else{
      print(value);
      loadingUser(context);
      Get.back();
    }



  }

  Future loadingUser(BuildContext context)async{

    loading.value = true;


    var value = await RequestHandler.servicesGet("patient/emergencyContact/view");

    loading.value = false;

    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
      //setUser()

    }else{
      print(value);
      userSos.value = List<UserSos>.from(value
          .map((model) => UserSos.fromJson(model)));

      Get.back();
    }



  }


  _requestAlertError(BuildContext context , ErrorRequest errorRequest){
    switch (errorRequest) {
      case ErrorRequest.TimeOut:
        Services().pushAlert("Time out",context);
        break;
      case ErrorRequest.Internet:
        Services().pushAlert("Não à conexão com Internet",context);
        break;
      case ErrorRequest.ServerError:
        Services().pushAlert("Oops, algo deve ter dado errado! Tentar de Novo",context);
        break;
    }

  }



}