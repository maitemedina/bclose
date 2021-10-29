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

class SwitchController extends GetxController{
  final TextEditingController dataNas = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController height = TextEditingController();

  final positionSwitch = false.obs;

  @override
  void initState() {
    // TODO: implement initState

  }

  Future changeSwitch( BuildContext context)async{


    positionSwitch.value = !positionSwitch.value;

  }








}