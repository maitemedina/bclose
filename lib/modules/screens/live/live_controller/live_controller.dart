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
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

class LiveController extends GetxController{
  static ILocalStorage localStorage = new PrefsLocalStorageService();
  final userSos =  <UserSos>[].obs;
  final conversation =  <Conversation>[].obs;

  final loading = false.obs;


  Future loadingUser(BuildContext context)async{

    loading.value = true;

    var idPatiente =   await localStorage.get("idPatiente").then((value) => value.toString());
    var value = await RequestHandler.servicesGetPatient("admission/getDoctor/$idPatiente");

    loading.value = false;

    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
      //setUser()

    }else{
      print(value);
      userSos.value = [];
      for(var item in value){
        var medicalSpecialty = "";
        if (item["medicalSpecialty"] != null){
          medicalSpecialty = item["medicalSpecialty"];
        }
        var resDoctor = item["responsableDoctor"];
        if (resDoctor != null){
          userSos.add(UserSos(id: item["id"],userId: item["user_id"],
              morada: "",image: resDoctor["image"],name: resDoctor["first_name"].toString()+ " "+resDoctor["last_name"].toString(),
              number: medicalSpecialty ) );
        }



      }


      //Get.back();
    }



  }

  Future loadingConversation(BuildContext context,String idDoct)async{

    loading.value = true;
    print("chat/getConversation/$idDoct/");
    var idPatiente =   await localStorage.get("idPatiente").then((value) => value.toString());
    print("chat/getConversation/$idDoct/$idPatiente");
    var value = await RequestHandler.servicesGetPatient("chat/getConversation/$idDoct/$idPatiente");

    loading.value = false;

    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
      //setUser()

    }else{
      conversation.value = List<Conversation>.from(value
          .map((model) => Conversation.fromJson(model)));
      //Get.back();
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