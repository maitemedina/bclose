


import 'dart:async';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/core/autentication/change_langue.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/modules/screens/tabBar/tabBar.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:i18n_extension/i18n_widget.dart';

import '../../main.dart';


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  static ILocalStorage localStorage = new PrefsLocalStorageService();



  void onDoneLoading() async {
    Services().getUser();
    localStorage.get("id").then((value) => value==null?Get.offAll(ChangeLangue()):Get.offAll(TabBarHomePage()));


  }



  Future<Timer> loadData() async {
   var lang = await Services().getLang();

    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  @override
  initState()   {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);


    loadData();


  }


  @override
  dispose()  {
    SystemChrome.setPreferredOrientations([

      DeviceOrientation.portraitUp,
    ]);



    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.GREENBHEALTH,
      body: Container(

        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'packages/bclose/assets/icons/ic_logo_designaçao.png',
                width: 220,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


