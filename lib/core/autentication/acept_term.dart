


import 'package:bclose/constants/translation.dart';
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/core/autentication/change_langue.dart';
import 'package:bclose/core/autentication/login.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';



class AceptTerm extends StatefulWidget {

  @override
  _AceptTerm createState() => _AceptTerm();
}

class _AceptTerm extends State<AceptTerm> {

  _onRegister(String command) {
    setState(() {
      Get.off(LoginPage());

    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Gray6,
      body: Container(

        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
                color: AppColors.GREEN,
                height: 80,
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UILabels.Bold(
                    text: "Termos e Condições".i18n,
                    fontSize: 16,
                    textLines: 1,
                    color: AppColors.White,
                  ),
                ),


              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    color: AppColors.White,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Expanded(
                        flex: 1,
                        child: Container(

                            child: WebView(
                              initialUrl: "https://shop.bclose.pt/pt/termos-e-condicoes/",
                              javascriptMode: JavascriptMode.unrestricted,
                            )),
                      ),
                    ),

                  ),
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 45,
                      margin: EdgeInsets.fromLTRB(16, 5, 16, 5),
                      // width: MediaQuery.of(context).size.width,
                      child: UIBottons(
                        labels: UILabels.Bold(
                          text: "Voltar",
                          fontSize: 16,
                          textLines: 1,
                          color: AppColors.White,
                        ),
                        cb: (as){
                          Get.off(ChangeLangue());
                        },
                        color: AppColors.Blue, colorList: [AppColors.Blue],
                      )),Container(
                      height: 45,
                      margin: EdgeInsets.fromLTRB(16, 5, 16, 5),
                      // width: MediaQuery.of(context).size.width,
                      child: UIBottons(
                        labels: UILabels.Bold(
                          text: "Aceitar",
                          fontSize: 16,
                          textLines: 1,
                          color: AppColors.White,
                        ),
                        cb: _onRegister,
                        color: AppColors.Blue, colorList: [AppColors.Blue],
                      )),
                ],
              ),


              SizedBox(
                height: 32,
              )
            ],
          ),
        ),
      ),
    );
  }
}


