import 'dart:io';

import 'package:bclose/core/autentication/create_new_password.dart';
import 'package:bclose/core/autentication/forgot_password_code.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/core/splash/splash.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/modules/objects/documents.dart';
import 'package:bclose/modules/objects/user.dart';
import 'package:bclose/util/handler/request_handler.dart';
import 'package:bclose/util/helpers/helpers.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/info_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

class DocumentsController extends GetxController{
  static ILocalStorage localStorage = new PrefsLocalStorageService();

  final documents =  <Documents>[].obs;

  final loading = false.obs;

  Future saveDoc(List<File> file, String name, String category, BuildContext context)async{

    loading.value = true;
    var value = await RequestHandler.uploadImagePost(file,"patient/uploadFile",name,category);
    loading.value = false;

    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);

    }else{

      loadingDoc(category,context);
      Get.back();



    }

  }
  Future Delete(String category, String id, BuildContext context)async{

    var myid = await localStorage.get("id").then((value) => value.toString());

    loading.value = true;
    var value = await RequestHandler.servicesDelete(
        {"user_id":myid}, "patient/deleteFile/$id");

    print("value");
    print(value);
    print("value");
    loading.value = false;

    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);

    }else{

      loadingDoc(category,context);
      Get.back();



    }

  }

  Future loadingDoc(String category,BuildContext context)async{
    documents.value = [];
    loading.value = true;
    var value = await RequestHandler.servicesGet("patient/listFiles");
    loading.value = false;


    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);

    }else{
      documents.value = [];

      value.forEach((element) {
        print(element['type'].toString());
        print(category);

        if(element['type'].toString() == category)

          documents.add(Documents(id: element['id'],data: Util.getTimestampToData(element['created_at']),image:element['path'],name: element['name'],type: element['type']));

      });


      for(var item in value){




      }


    }

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