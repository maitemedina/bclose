
import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/constants/app_strings.dart';
import 'package:bclose/core/autentication/controller/autentication_controller.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/core/splash/splash.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/modules/objects/user.dart';
import 'package:bclose/modules/screens/Notification/notification.dart';
import 'package:bclose/modules/screens/home/controler/home_controller.dart';
import 'package:bclose/modules/screens/reusables/devices/pairing_device.dart';
import 'package:bclose/modules/screens/reusables/devices/preview_device.dart';
import 'package:bclose/modules/screens/reusables/devices/purchase_device.dart';
import 'package:bclose/modules/screens/reusables/profile/removePin.dart';
import 'package:bclose/modules/screens/reusables/profile/validate_email.dart';
import 'package:bclose/modules/screens/reusables/profile/validate_mod_priveite.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/switch/ui_switch.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:bclose/widgets/ui_publicity.dart';
import 'package:bclose/widgets/ui_user_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../sos/edit_user.dart';
import 'edit_account.dart';
import 'insert_pin.dart';
import 'new_account.dart';


class Profile_Page extends StatefulWidget {

  @override
  _Profile_Page createState() => _Profile_Page();
}

class _Profile_Page extends State<Profile_Page> {
  HomeController homeController = Get.put(HomeController());
  AutenticationController autenticationController =  Get.put(AutenticationController());
  static ILocalStorage localStorage = new PrefsLocalStorageService();
  Services services = Get.put(Services());
  var _switchMCL = false.obs;
  var _switchPRI = false.obs;
  var  switchCui = false.obs;




  @override
  void initState() {
    // TODO: implement initState
    // autenticationController.updateUserValue(context);
    services.getUser();
    setState(() {
       services.getPin().then((value) =>
       switchCui.value = value

       );

       print("_switchCui.value");
       print(switchCui.value);
       print("_switchCui.value");
    });
    super.initState();
  }


  _onValidatyEmail(String command) {
    setState(() {

      Services().pushAlert("Enviámos um link para o seu email para verificar a sua autenticidade.",context);
      autenticationController.sendConfirmetionEmail(context);


    });
  }
  _onEditUser(String command) {
    setState(() {
      if(switchCui.value){
        Services().pushAlert('Por Favor desativa o modo cuidador para continuar.',context);
      }else{Get.to(EditAccount_Page());}



    });
  }
  _onNewAccount(String command) {
    setState(() {

      Get.to(NewAccountPage());

    });
  }
  _onLogin(String command) {
    qrCode();
  }
  _onContinuePress(String command) {
    Get.defaultDialog(
      textConfirm: 'Sim',
      title: 'Terminar Sessão',
      onConfirm: () {
        ILocalStorage localStorage = new PrefsLocalStorageService();
        localStorage.clear();
        Get.offAll(() => SplashScreen());
      },
      confirmTextColor: AppColors.White,
      onCancel: () {
        Get.close;
      },
      textCancel: 'Não',
      middleText: 'Tens a certeza?',
    );
  }
  _onModePriveitOn(String command) {
    localStorage.put("statePin",true);
    switchCui.value = true;

  }
  _onModePriveit(String command) {

    Get.to(() => InsertPinPage(id: services.user.value.id,));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Gray6,
      appBar: AppBar(
        backgroundColor: AppColors.GREEN.withAlpha(95),

        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [

              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: CircleAvatar(
                  child: Image.asset('packages/bclose/assets/device/ic_back.png',
                    height: 65,width: 65,),
                  backgroundColor: AppColors.White,
                  radius: 25,

                ),
              ),
              SizedBox(width: 8,),
              CircleAvatar(
                child: Image.asset('packages/bclose/assets/icons/ic_gree_interrogacao.png',
                  height: 65,width: 65,),
                backgroundColor: AppColors.White,
                radius: 25,

              ),
              SizedBox(width: 8,),
              CircleAvatar(child: Image.asset('packages/bclose/assets/icons/ic_gree_partilhar.png',
                height: 65,width: 65,),
                backgroundColor: AppColors.White,
                radius: 25,
              ),
            ],
          ),
        ),
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx( ()=>
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(

                    children: [
                      Expanded(
                        flex:1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UILabels(text: "NOME", textLines: 2,color: AppColors.Blue,fontSize: 16,),
                            UILabels(text: services.user.value.username , textLines: 2,color: AppColors.Black,fontSize: 14,),
                          ],
                        ),
                      ),
                      SizedBox(width: 8,),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UILabels(text: "E-MAIL REGISTADO", textLines: 2,color: AppColors.Blue,fontSize: 16,),
                            UILabels(text: services.user.value.email, textLines: 2,color: AppColors.Black,fontSize: 14,),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if(services.user.value.status.toString() == "-1")
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(

                      children: [
                        Expanded(
                          flex:1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              UILabels(text: "ESTADO DO E-MAIL", textLines: 2,color: AppColors.Blue,fontSize: 16,),
                              UILabels(text: "Não validado", textLines: 2,color: AppColors.GoogleColor,fontSize: 14,),
                            ],
                          ),
                        ),
                        SizedBox(width: 8,),
                        Expanded(
                          flex: 1,
                          child: Container(
                              height: 30,
                              margin: EdgeInsets.fromLTRB(16, 0, 16, 10),

                              child: UIBottons(
                                labels: UILabels.Regular(
                                  text: "Validar email",
                                  fontSize: 14,
                                  textLines: 1,
                                  color: AppColors.White,
                                ),
                                cb: _onValidatyEmail,
                                color: AppColors.Blue, colorList: [AppColors.Blue],
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                Container(
                  color: AppColors.White,
                  width: 180,
                  padding: const EdgeInsets.all(0),
                  child: Column(

                    children: [
                      QrImage(
                        data: services.user.value.code,
                        version: QrVersions.auto,
                        size: 180.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          UILabels.Bold(text: "Uid:", textLines: 1,color: AppColors.Black,fontSize: 12,),
                          SizedBox(width: 2,),
                          Expanded(child: UILabels(text: services.user.value.code, textLines: 4,color: AppColors.Black,fontSize: 12,textAlign: TextAlign.start,),flex:1,),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32,),
                if(_switchMCL.value)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 30,
                          margin: EdgeInsets.fromLTRB(16, 0, 0, 10),

                          child: UIBottons(
                            labels: UILabels.Regular(
                              text: "NOVA CONTA",
                              fontSize: 14,
                              textLines: 1,
                              color: AppColors.White,
                            ),
                            cb: _onNewAccount,
                            color: AppColors.Blue, colorList: [AppColors.Blue],
                          )
                      ),
                      SizedBox(width: 32,),
                      Container(
                          height: 30,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: UIBottons(
                            labels: UILabels.Regular(
                              text: "Entrar com Nova Conta",
                              fontSize: 14,
                              textLines: 1,
                              color: AppColors.White,

                            ),
                            cb: _onLogin,
                            color: AppColors.Blue, colorList: [AppColors.Blue],
                          )
                      ),

                    ],
                  ),
                SizedBox(height: 32,),
              ],
            ),),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(

                children: [
                  Expanded(
                    flex:1,
                    child: UILabels(text: "MODO PRIVADO", textLines: 2,color: AppColors.Blue,fontSize: 16,textAlign: TextAlign.left,),
                  ),
                  SizedBox(width: 8,),
                  UISwitch.V(cb: (value,name){
                    _switchPRI.value = value;
                    // setState(() {
                    //
                    // });

                  }, name: "PRIVADO",value: _switchPRI.value),

                  // CupertinoSwitch(
                  //   value: _switchPRI,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       // _switchMP = value;
                  //       _switchPRI = value;
                  //
                  //     });
                  //   },
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(

                children: [
                  Expanded(
                    flex:1,
                    child: UILabels(text: "MODO CLÍNICO", textLines: 2,color: AppColors.Blue,fontSize: 16,textAlign: TextAlign.left,),
                  ),
                  SizedBox(width: 8,),
                  UISwitch.V(cb: (value,name){
                    _switchMCL.value = value;

                  }, name: "Clinico",value: _switchMCL.value),
                  // CupertinoSwitch(
                  //   value: _switchMCL,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _switchMCL = value;
                  //     });
                  //   },
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(

                children: [
                  Expanded(
                    flex:1,
                    child: UILabels(text: "MODO CUIDADOR", textLines: 2,color: AppColors.Blue,fontSize: 16,textAlign: TextAlign.left,),
                  ),
                  SizedBox(width: 8,),
                  UISwitch.V(cb: (value,name){
                    if(value == true){
                      localStorage.get("statePin").then((value) => value == null?  _onModePriveit("init") :  _onModePriveitOn("int"));

                    }else{
                      homeController.mode_cuid.value = false;
                      Get.to(RemovePinPage(id: services.user.value.id,));
                    }

                  }, name: "CUIDADOR",value: switchCui.value),
                  // CupertinoSwitch(
                  //   value: _switchCui,
                  //   onChanged: (value) {
                  //
                  //   },
                  // ),


                ],
              ),
            ),

            SizedBox(
              height: 32,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 30,
                    margin: EdgeInsets.fromLTRB(16, 0, 0, 10),

                    child: UIBottons(
                      labels: UILabels.Regular(
                        text: " EDITAR PERFIL ",
                        fontSize: 14,
                        textLines: 1,
                        color: AppColors.White,
                      ),
                      cb: _onEditUser,
                      color: AppColors.Blue, colorList: [AppColors.Blue],
                    )
                ),
                SizedBox(width: 32,),
                // Container(
                //     height: 30,
                //     margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                //     child: UIBottons(
                //       labels: UILabels.Regular(
                //         text: "NOVA CONTA",
                //         fontSize: 14,
                //         textLines: 1,
                //         color: AppColors.White,
                //
                //       ),
                //       cb: _onValidatyEmail,
                //       color: AppColors.Blue, colorList: [AppColors.Blue],
                //     )
                // ),
                Container(
                    height: 30,
                    margin: EdgeInsets.fromLTRB(0, 0, 16, 10),

                    child: UIBottons(
                      labels: UILabels.Regular(
                        text: "FECHAR",
                        fontSize: 14,
                        textLines: 1,
                        color: AppColors.Blue ,
                      ),
                      cb: _onContinuePress,
                      color: AppColors.White, colorList: [AppColors.White],
                    )
                )

              ],
            )

          ],
        ),
      )
    );
  }

  var qrValue;
  Future qrCode() async{
    var qr = await BarcodeScanner.scan();


    qrValue = qr;

    if(qr != ""){
      print(qr);
      autenticationController.loginCode(qr, context);
      // _doEmailSignIn(qrValue, "12345678");
    }else{
      // cancelar
    }



  }
}


