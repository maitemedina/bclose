


import 'dart:async';

import 'package:bclose/constants/app_strings.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/core/splash/splash.dart';
import 'package:bclose/modules/objects/user.dart';
import 'package:bclose/modules/screens/reusables/profile/profile_controller/profile_controller.dart';
import 'package:bclose/modules/screens/tabBar/tabBar.dart';
import 'package:bclose/widgets/alert/info_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';

class Services {

  static ILocalStorage localStorage = new PrefsLocalStorageService();
  ProfileController  profileController =  Get.put(ProfileController());
  var user = User().obs;
  final loading = false.obs;

  setUser(String id,String name,String email,String code, String token,String status,String gender, String born_date,String idPatiente,String weight,String height,String image,String cuidadorId,String cuidadorPin) async {
    await localStorage.put("id",id);
    await localStorage.put("name",name);
    await localStorage.put("email",email);
    await localStorage.put("code",code);
    await localStorage.put("token",token);
    await localStorage.put("status",status);
    await localStorage.put("born_date",born_date);
    await localStorage.put("gender",gender);
    await localStorage.put("image",image);
    //patiente
    await localStorage.put("idPatiente",idPatiente);
    await localStorage.put("userweight",weight);
    await localStorage.put("userheight",height);
    await localStorage.put("cuidadorId",cuidadorId);
    await localStorage.put("cuidadorPin",cuidadorPin);

  }

  setUserUnit(unitW, uinT,unitH) async {


    await localStorage.put("unitW",unitW);
    await localStorage.put("uinT",uinT);
    await localStorage.put("unitH",unitH);
    getUser();
  }

  setUserUpdate(User newUser) async {



    var name =   await localStorage.get("name").then((value) => value.toString());
    var born_date = await localStorage.get("born_date").then((value) => value.toString());
    var gender = await localStorage.get("gender").then((value) => value.toString());
    var weight =   await localStorage.get("userweight").then((value) => value.toString());
    var height =  await localStorage.get("userheight").then((value) => value.toString());
    var sos_number =   await localStorage.get("sos_number").then((value) => value.toString());
    var sos_name =  await localStorage.get("sos_name").then((value) => value.toString());
    var image =  await localStorage.get("image").then((value) => value.toString());



    if(newUser.username != name || newUser.gender != gender
    || newUser.born_date != born_date || newUser.userpatient?.height != height
        || newUser.userpatient?.weight != weight|| newUser.userpatient?.weight != sos_number
        || newUser.userpatient?.weight != sos_name || newUser.image != image){

      loading.value = true;
      await localStorage.put("id",newUser.id);
      await localStorage.put("name",newUser.username);
      await localStorage.put("email",newUser.email);
      await localStorage.put("code",newUser.code);
      await localStorage.put("token",newUser.token);
      await localStorage.put("status",newUser.status);
      await localStorage.put("born_date",newUser.born_date);
      await localStorage.put("gender",newUser.gender);
      //patiente
      await localStorage.put("idPatiente",newUser.userpatient?.id);
      await localStorage.put("userweight",newUser.userpatient?.weight);
      await localStorage.put("userheight",newUser.userpatient?.height);
      //patiente
      await localStorage.put("sos_name",newUser.sos_name);
      await localStorage.put("sos_number",newUser.sos_number);
      await localStorage.put("sos_image",newUser.sos_number);
      await localStorage.put("image",newUser.image);
    }
    getUser();
    profileController.UpdateUser(newUser.gender,newUser.username,newUser.born_date,newUser.userpatient?.height,newUser.userpatient?.weight,newUser.sos_name,newUser.sos_number,newUser.sos_number);
    await loadData();


  }

  void onDoneLoading() async {
    loading.value = false;
   Get.back();


  }



  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  getUser()  async {
    print(user.value);
    var id =   await localStorage.get("id").then((value) => value.toString());
    var name =   await localStorage.get("name").then((value) => value.toString());
    var email =  await localStorage.get("email").then((value) => value.toString());
    var code =   await localStorage.get("code").then((value) => value.toString());
    var token =   await localStorage.get("token").then((value) => value.toString());
    var status =  await localStorage.get("status").then((value) => value.toString());
    var born_date = await localStorage.get("born_date").then((value) => value.toString());
    var gender = await localStorage.get("gender").then((value) => value.toString());

    var idPatiente =   await localStorage.get("idPatiente").then((value) => value.toString());
    var weight =   await localStorage.get("userweight").then((value) => value.toString());
    var height =  await localStorage.get("userheight").then((value) => value.toString());
    var image =  await localStorage.get("image").then((value) => value.toString());
    var sos_name =   await localStorage.get("sos_name").then((value) => value.toString());
    var sos_number =  await localStorage.get("sos_number").then((value) => value.toString());
    var cuidadorId =   await localStorage.get("cuidadorId").then((value) => value.toString());
    var cuidadorPin =  await localStorage.get("cuidadorPin").then((value) => value.toString());

    var unitW =  await localStorage.get("unitW").then((value) => value != null?  value.toString(): localStorage.put("unitW","0"));
    var uinT =   await localStorage.get("uinT").then((value) => value != null?  value.toString(): localStorage.put("uinT","0"));
    var unitH =  await localStorage.get("unitH").then((value) => value != null?  value.toString(): localStorage.put("unitH","0"));


    user.value = User(id: id,username: name,email:email,token: token,code: code,
    image: image,status:status,userpatient:
    UserPatient(id: idPatiente,weight:weight,height:height,cuidadorId:cuidadorId,cuidadorPin:cuidadorPin),
    born_date: born_date,gender: gender,sos_name:sos_name,sos_number:sos_number,
    unitW:unitW,uinT:uinT,unitH:unitH);

  }

  Future<bool> getPin() async {
    var cuidadorPin =  await localStorage.get("cuidadorPin").then((value) => value.toString());
    print("cuidadorPin");
    print(cuidadorPin);
    print("cuidadorPin");
    var statepin = await getStatPin().then((value) => value);
    print("statepin");
    print(statepin);
    print("statepin");

    return  await localStorage.get("cuidadorPin").then((value) => value == null?  false :  value != "" ? statepin:false,);
  }

   getStatPin() async{

     return  await localStorage.get("statePin").then((value) => value == null?  true :  value);
  }


  Future<void> saveLang(String value) async {
    print(value);
    print(appPT);
    if(value == appPT)
      await localStorage.put("lang","pt");
      Get.updateLocale(Locale('pt', "BR"));
    if(value == appEN)
      await localStorage.put("lang","en");
      Get.updateLocale(Locale('en', "US"));
    if(value == appES)
      await localStorage.put("lang","es");
      Get.updateLocale(Locale('es', "ES"));
    if(value == appFR)
      await localStorage.put("lang","fr");
      Get.updateLocale(Locale('fr', "FR"));

  }

   getLang()  {

    var lang =  localStorage.get("lang").then((value) => value.toString());

    print(lang);

    if(lang == "pt")
      return Locale('pt', "BR");
    if(lang == "es")
      return Locale('es', "ES");
    if(lang == "en")
      return Locale('en', "US");
    if(lang == "fr")
      return Locale('fr', "FR");

    return Locale('pt', "BR");

  }

  void pushAlert(String value,BuildContext context){
    alertDialog(context, UIInfoAlert(title: 'Bhealth', cb: (String ) { Navigator.pop(context); }, sub_title: value ,));

  }


  void alertDialog(BuildContext context, Widget widget,) {
    showDialog(context: context,
      barrierDismissible: false,
      builder: (_) {
        return widget;
      },
    );
  }

  validarEmail(String value){

    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);

  }

  Future<void> share(file,title,) async {
    await FlutterShare.shareFile(
        title: '$title',
        text: '$title',
        filePath: file);
  }

}