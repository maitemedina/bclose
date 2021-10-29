
import 'package:bclose/bluetooth/services/bluetooth_serveces.dart';
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/constants/app_strings.dart';
import 'package:bclose/core/autentication/acept_term.dart';
import 'package:bclose/constants/translation.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i18n_extension/i18n_widget.dart';


class ChangeLangue extends StatefulWidget {


  @override
  _ChangeLangue createState() => _ChangeLangue();
}

class _ChangeLangue extends State<ChangeLangue> {

  String dropdownValue = appPT;
  Locale? _locale;

  _onRegister() {
    Get.to(()=>AceptTerm());
  }

 _changeLang() async {
   var lang = await Services().getLang();
    setState((){
      var locale = lang;
      Get.updateLocale(locale);

    });

 }

  @override
   initState(){
    // TODO: implement initState
    super.initState();
    _changeLang();

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.GREENBHEALTH,
      body: Container(

        child: Stack(
          children: [

            Center(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                UILabels.Bold(text: "IDIOMA", textLines: 1,fontSize: 16,),
                SizedBox(height: 8,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Container(
                        height: 30,
                        padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: AppColors.White,
                          borderRadius: BorderRadius.circular(4.0),

                        ),
                        child: DropdownButton<String>(
                          isExpanded: false,
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_drop_down,color: AppColors.White,),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: AppColors.Black),
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (String? newValue,) {
                            setState(() {
                              dropdownValue = newValue!;


                            });
                          },
                          items: <String>[appPT, appFR, appEN, appES]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,

                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    GestureDetector(
                      onTap: (){
                        _onRegister();
                      },
                      child: Container(
                        color: AppColors.Blue.withAlpha(0),
                        padding: EdgeInsets.all(16),
                        child: Image.asset(
                          'packages/bclose/assets/icons/ic_seta.png',
                          width: 12,
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 80,)

              ],
            ),
          ],
        )
      ),
    );
  }
}


