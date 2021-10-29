
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class UITextFields extends StatelessWidget {
  final String text;
  final Color color;
  late  Widget? suffix_Icon;
  final Widget? prefix_Icon;
  final bool passwordVisible;
  final bool enable;
  final bool infoBio;
  final TextInputType type;
  final TextEditingController inputText;
  final void Function()? cbChenge;

  UITextFields.EMAIL({this.type = TextInputType.emailAddress, this.enable = true,required this.text,required this.inputText , this.color = AppColors.Black, this.suffix_Icon, this.prefix_Icon, this.passwordVisible = true, this.infoBio = false, this.cbChenge});
  UITextFields.PASSWORD({this.type = TextInputType.visiblePassword, this.enable = true,required this.text,required this.inputText , this.color = AppColors.Black, this.suffix_Icon, this.prefix_Icon, this.passwordVisible = false,this.infoBio = false, this.cbChenge});
  UITextFields.NUMBER({this.type = TextInputType.number, this.enable = true,required this.text,required this.inputText , this.color = AppColors.Black, this.suffix_Icon, this.prefix_Icon, this.passwordVisible = true,this.infoBio = false, this.cbChenge});
  UITextFields({this.type = TextInputType.name, this.enable = true,required this.text,required this.inputText , this.color = AppColors.Black, this.suffix_Icon, this.prefix_Icon, this.passwordVisible = true,this.infoBio = false, this.cbChenge});

  @override
  Widget build(BuildContext context) {
    return this.infoBio ? infoBiometric(): iniWidget();

  }

  Widget iniWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.White.withAlpha(10),
        borderRadius: BorderRadius.circular(4.0),
        // border: Border.all(width: 1.0, color: AppColors.Gray4),

      ),
      height: 52.0,
      child: Column(
          children : [
              TextField(
                keyboardType: type,
                controller: inputText,
                obscureText: !passwordVisible,
                enabled: enable,
                cursorColor: Colors.black26,
                onChanged: (text) {
                  cbChenge!();
                },
                style: TextStyle(
                  color: this.color,
                  fontFamily: 'ProximaNova',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,

              ),

                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 14,top: 4),
                  labelText: this.text,
                  hintText: this.text,
                  suffixIcon: suffix_Icon,
                  prefixIcon: prefix_Icon,

                  hintStyle: TextStyle(
                    color: Colors.black26,
                    fontFamily: 'ProximaNova',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
              ),
            ),
          ]
      ),
    );
  }

  Widget infoBiometric(){
    return Container(
      alignment: Alignment.centerLeft,

      height: 30.0,
      child: Column(
          children : [
            TextField(
              keyboardType: type,
              controller: inputText,
              obscureText: !passwordVisible,
              enabled: enable,
              cursorColor: Colors.black26,


              style: TextStyle(
                color: this.color,
                fontFamily: 'ProximaNova',
                fontWeight: FontWeight.w400,
                fontSize: 15,

              ),

              decoration: InputDecoration(
                border: InputBorder.none,
                // labelText: this.text,
                hintText: this.text,

                hintStyle: TextStyle(
                  color: Colors.black26,
                  fontFamily: 'ProximaNova',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ),
            Container(height: 1,
            color: AppColors.Black,)
          ]
      ),
    );
  }
}
