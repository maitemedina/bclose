
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/modules/objects/meeting.dart';
import 'package:bclose/util/handler/request_handler.dart';
import 'package:bclose/util/helpers/helpers.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  static ILocalStorage localStorage = new PrefsLocalStorageService();

  final appointmentUser = <AppointmentUser>[].obs;

  final filterappointmentUser = <AppointmentUser>[].obs;

  final loading = false.obs;

  Future saveAppointment(String startData, String endData, String name,
      bool allday, BuildContext context) async {
    loading.value = true;

    var id = await localStorage.get("id").then((value) => value.toString());
    var patient_id = await localStorage.get("idPatiente").then((value) =>
        value.toString());

    var body = {
      "start": Util
          .getTimestamp(startData)
          .millisecondsSinceEpoch,
      "end": Util
          .getTimestamp(endData)
          .millisecondsSinceEpoch,
      "title": name,
      "location": "Casa",
      "all_day": allday,
      "repeat": false,
      "description": "",
      "patient_id": patient_id,
      "user_id": id,
      "type": "CONSULTA"
    };


    // appointmentUser.add(AppointmentUser(name, Util.getDataTime(startData), Util.getDataTime(endData), AppColors.GREEN, allday,false,0));
    // filterappointmentUser.add(AppointmentUser(name, Util.getDataTime(startData), Util.getDataTime(endData), AppColors.GREEN, allday,false,0));
    // ;
    // Get.back();

    var value = await RequestHandler.servicesPost(body, "appointment/create");

    loading.value = false;
    if (value.runtimeType == ErrorRequest) {
      _requestAlertError(context, value);
      //setUser()
    } else {
      print(value);
      // loadingAppointment(context);
      // appointmentUser.add(AppointmentUser(name, startData, endData, AppColors.GREEN, allday));

      Get.back();
    }
  }

  Future loadingNotification(BuildContext context) async {
    loading.value = true;

    var id = await localStorage.get("id").then((value) => value.toString());
    var value = await RequestHandler.servicesGetPatient(
        "notification/list/$id");


    loading.value = false;

    if (value.runtimeType == ErrorRequest) {
      _requestAlertError(context, value);
      //setUser()
    } else {
      appointmentUser.value = [];
      filterappointmentUser.value = [];

      for (var item in value) {
        if (item['created_at'] is int)
          appointmentUser.add(AppointmentUser(
              item['id'],
              item['title'],
              Util.getTimestampToData(item['created_at']),
              Util.getTimestampToData(item['created_at']),
              item['user_id'].toString() == id ? AppColors.GREEN : AppColors
                  .Blue,
              false,
              0,
              item['type'].toString(),
              item['extra']?.toString() ?? "null"));
        filterappointmentUser.add(AppointmentUser(
            item['id'],
            item['title'],
            Util.getTimestampToData(item['created_at']),
            Util.getTimestampToData(item['created_at']),
            item['user_id'].toString() == id ? AppColors.GREEN : AppColors.Blue,
            false,
            0,
            item['type'].toString(),
            item['extra']?.toString() ?? "null"));
      }

    }
  }
  Future deleteNotification(BuildContext context,String id) async {
print("servicesDelete");
    var value = await RequestHandler.servicesDelete({"":""},
        "notification/delete/$id");

    print(value);



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