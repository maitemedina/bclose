
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/util/handler/request_handler.dart';
import 'package:bclose/util/helpers/helpers.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';


class ProfileController extends GetxController{
  static ILocalStorage localStorage = new PrefsLocalStorageService();
  final weight = "0".obs;
  final height = "0".obs;

  
  Future UpdateUser(String genre,String name,String date,String weight, String height,String eName, String eNumber,String eimage) async {




    var id = await localStorage.get("id").then((value) => value.toString());

    var first_name = "";
    var last_name = "";
    var splitName = name.split(" ");
    first_name = splitName[0];
    if(splitName.length > 1)
      last_name = splitName[1];
    
    var body = {

        "emergency":{
          "name1": eName,
          "address1": "",
          "phone_number1": eNumber,
          "image1": eimage,
        },
        "user":{
          "first_name": first_name,
          "last_name": last_name,
          "born_date": date,
          "gender": genre
        },
        "patient": {
          "weight": weight,
          "height": height,
          "responsable_id": 1
        }
      };


    var value = await RequestHandler.servicesPut(body,
        "admission/editWithUser/$id");


    if (value.runtimeType == ErrorRequest) {
      // _requestAlertError(context, value);
      //setUser()
    } else {
      
    }
  }


  _requestAlertError(BuildContext context, ErrorRequest errorRequest) {
    switch (errorRequest) {
      case ErrorRequest.TimeOut:
        Services().pushAlert("Time out", context);
        break;
      case ErrorRequest.Internet:
        Services().pushAlert("Não à conexão com Internet", context);
        break;
      case ErrorRequest.ServerError:
        Services().pushAlert(
            "Oops, algo deve ter dado errado! Tentar de Novo", context);
        break;
    }
  }

}