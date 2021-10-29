import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/core/autentication/create_new_password.dart';
import 'package:bclose/core/autentication/forgot_password_code.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/core/splash/splash.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/modules/objects/meeting.dart';
import 'package:bclose/modules/objects/user.dart';
import 'package:bclose/modules/screens/reusables/profile/insert_pin.dart';
import 'package:bclose/modules/screens/reusables/profile/validate_mod_priveite.dart';
import 'package:bclose/util/handler/request_handler.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/info_alert.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AutenticationController extends GetxController{

  final _user = User().obs;
  final loading = false.obs;
  static ILocalStorage localStorage = new PrefsLocalStorageService();
  Future login(Map<String,dynamic> body , BuildContext context)async{

    loading.value = true;

    var login = await RequestHandler.servicesPost(body,"user/login");
    loading.value = false;

    if (login.runtimeType == ErrorRequest){
      _requestAlertError(context, login);

    }else{
      _saveUser(login);
    }

  }

  Future updateUserValue(BuildContext context)async{


    var value = await RequestHandler.servicesGet("user/view");

    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);

    }else{
      _saveUserUpdate(value);
    }

  }

  Future loginCode(String code , BuildContext context)async{

    loading.value = true;

    var login = await RequestHandler.servicesGetPatient("patient/read/$code");
    loading.value = false;

    if (login.runtimeType == ErrorRequest){
      _requestAlertError(context, login);

    }else{

      _saveUser(login);
    }

  }
  Future sendConfirmetionEmail(BuildContext context)async{

    loading.value = true;

    var login = await RequestHandler.servicesGet("user/sendMail");
    loading.value = false;

    if (login.runtimeType == ErrorRequest){
      _requestAlertError(context, login);

    }else{

    }

  }
  Future register(Map<String,dynamic> body , BuildContext context)async{

    loading.value = true;

    var value = await RequestHandler.servicesPost(body,"user/register");
    loading.value = false;
    if (login.runtimeType == ErrorRequest){

      _requestAlertError(context, value);
      //setUser()
    }else{


      if(value == "userExiste"){
        Services().pushAlert("Esta conta já está sendo usada em Bhealth",context);
      }else{
        _saveUser(value);
      }


    }
  }

  Future registerNew(Map<String,dynamic> body , BuildContext context)async{

    loading.value = true;

    var value = await RequestHandler.servicesPost(body,"user/register");
    loading.value = false;
    if (login.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
      //setUser()
    }else{
      var userValue = value['user'];
      var userPatientValue = value['patient'];
      if(userValue["first_name"] is String){



        Services().alertDialog(context, Container(
          // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
          color: AppColors.Black.withOpacity(0.5),
          alignment: Alignment.center,
          child: Container(
            width: Get.width,
            height: 450,
            margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
            padding: EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: AppColors.White,
              borderRadius: BorderRadius.circular(4.0),


            ),
            child: Center(
              child: Row(
                children: [
                  Column(
                    children: <Widget>[
                      UILabels.SemiBold(text: "Admitir Modo Clinico", textLines: 1,color: AppColors.Black,fontSize: 16,),

                      QrImage(
                        data: userValue["code"].toString(),
                        version: QrVersions.auto,
                        size: 220,
                        gapless: false,
                      ),

                      UILabels.SemiBold(text: "Email", textLines: 1,color: AppColors.Black,fontSize: 16,),
                      UILabels(text: userValue["email"].toString(), textLines: 1,color: AppColors.Black,fontSize: 16,),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                          height: 40,
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 10),

                          child: UIBottons(
                            labels: UILabels.Bold(
                              text: "Ok",
                              fontSize: 16,
                              textLines: 1,
                              color: AppColors.White,
                            ),
                            cb: (cb){Navigator.pop(context);},
                            color: AppColors.Blue, colorList: [AppColors.Blue],
                          )),
                    ],
                  ),
                  SizedBox(width: 32,)
                ],
              ),
            ),
          ),
        )
        );
      }
    }
  }

  Future recuverPassword(Map<String,dynamic> body , BuildContext context,String id)async{

    loading.value = true;

    var value = await RequestHandler.servicesPut(body,"user/recoverPassword");
    loading.value = false;
    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
    }else{
      if (value == true){
        Get.to(Create_New_Password_CodePage(id:id,));
      }else{
        Services().pushAlert("Não foi possível validar a sua Conta. Verifique seu código.",context);
      }

    }
  }

  Future confirmPin(Map<String,dynamic> body , BuildContext context,String id)async{

    loading.value = true;

    var value = await RequestHandler.servicesPut(body,"user/recoverPassword");
    loading.value = false;
    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
    }else{
      if (value == true){
        Get.off(InsertPinPage(id: id,));
      }else{
        Services().pushAlert("Não foi possível validar a sua Conta. Verifique seu código.",context);
      }

    }
  }


  Future changePassword(Map<String,dynamic> body , BuildContext context)async{

    loading.value = true;

    var value = await RequestHandler.servicesPut(body,"user/changePassword");
    loading.value = false;
    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
    }else{
      _saveUser(value);
    }
  }


  Future forgotPassword(Map<String,dynamic> body , BuildContext context,String email)async{

    loading.value = true;

    var value = await RequestHandler.servicesPut(body,"user/forgotPassword");
    loading.value = false;

    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
    }else{
      var id = value["user"]["id"];
      Get.to(Forgot_Password_CodePage(email: email,id:id.toString(),));
    }
  }
  Future newForgotPassword(Map<String,dynamic> body , BuildContext context)async{

    loading.value = true;

    var value = await RequestHandler.servicesPut(body,"user/forgotPassword");
    loading.value = false;

    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
    }else{
      // Get.to(() => Validate_Priveite_CodePage(email:email,id: id,));
      // Get.back();
    }
  }
  Future addPatient(String pin, String email , BuildContext context,)async{

    loading.value = true;
    var idPatiente =   await localStorage.get("idPatiente").then((value) => value.toString());
    var id =   await localStorage.get("id").then((value) => value.toString());
    var body= {"pin":pin,"email":email,"patient_id":idPatiente,"responsable_id": "1"}
    ;

    var value = await RequestHandler.servicesPost(body,"patient/addResponsable");
    loading.value = false;



    if (value.runtimeType == ErrorRequest){
      _requestAlertError(context, value);
    }else{
      // await localStorage.put("cuidadorPin",pin);
      Services().getUser();
      Get.back();

    }
  }

  Future newForgotPasswordLink(Map<String,dynamic> body , BuildContext context)async{

    var value = await RequestHandler.servicesPut(body,"user/forgotPassword");

  }



  _saveUser(user){
    var userValue = user?['user'] ?? user;
    var userPatientValue = user['patient'];


    var idResponsable = "";
    var pinResponsable = "";
    if(userValue?['responsable'] != null){
      for(var item in userValue['responsable']){
        idResponsable = item["responsable_id"].toString();
        pinResponsable = item["pin"].toString();
      }
    }

    print("responsable");
    print("responsable");

    if(userValue["first_name"] is String){
      Services().setUser(userValue["id"].toString(),
        userValue["first_name"].toString()+" "+userValue["last_name"].toString(),
        userValue["email"].toString(),
        userValue["code"].toString(),
        userValue["password_reset_token"].toString(),
        userValue["status"].toString(),

        userValue["gender"].toString(),
        userValue["born_date"].toString(),
        userPatientValue?["id"].toString() ?? "",
        userPatientValue?["weight"].toString() ?? "",
        userPatientValue?["height"].toString() ?? "",
        "",
        "$idResponsable",
        "$pinResponsable",

      );
      Get.offAll(SplashScreen());
    }
  }

  _saveUserUpdate(user){
    var userValue = user;
    var userPatientValue = user['patient'];


    var idResponsable = "";
    var pinResponsable = "";
    if(userValue?['responsable'] != null){
      for(var item in userValue['responsable']){
        idResponsable = item["responsable_id"].toString();
        pinResponsable = item["pin"].toString();
      }
    }

    print("responsable");
    print("responsable");

    if(userValue["first_name"] is String){
      Services().setUser(userValue["id"].toString(),
        userValue["first_name"].toString()+" "+userValue["last_name"].toString(),
        userValue["email"].toString(),
        userValue["code"].toString(),
        userValue["password_reset_token"].toString(),
        userValue["status"].toString(),

        userValue["gender"].toString(),
        userValue["born_date"].toString(),
        userPatientValue?["id"].toString() ?? "",
        userPatientValue?["weight"].toString() ?? "",
        userPatientValue?["height"].toString() ?? "",
        "",
        "$idResponsable",
        "$pinResponsable",

      );
    }
  }


  _requestAlertError(BuildContext context , ErrorRequest errorRequest){
    switch (errorRequest) {
      case ErrorRequest.TimeOut:
        Services().pushAlert("The connection has timed out, Please try again!",context);
        break;
      case ErrorRequest.Internet:
        Services().pushAlert("Sem conexão à Internet",context);
        break;
      case ErrorRequest.ServerError:
        Services().pushAlert("Oops, erro inesperado! Tente de Novo",context);
        break;
    }

  }



}