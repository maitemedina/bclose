import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/material.dart';
import './../constants/app_colors.dart';

class UIBottons extends StatelessWidget {
  final UILabels labels;
  final int flex;
  final Color color;
  final AlignmentGeometry beginDGD;
  final AlignmentGeometry endDGD;
  final void Function(String) cb;
  final List<Color> colorList ;
  bool home;
  bool fat;

  UIBottons({
    required this.labels,
    this.flex = 1,
    this.color = AppColors.FacebookColor,
    this.beginDGD = Alignment.bottomCenter,
    this.endDGD = Alignment.topRight,
    required this.colorList,
    required this.cb,
    this.home = false,
    this.fat = false,
  });

  UIBottons.Fat({
    required this.labels,
    this.flex = 1,
    this.color = AppColors.FacebookColor,
    this.beginDGD = Alignment.bottomCenter,
    this.endDGD = Alignment.topRight,
    required this.colorList,
    required this.cb,
    this.home = false,
    this.fat = true,
  });

  UIBottons.DGR({
    required this.labels,
    this.flex = 1,
    this.color = AppColors.FacebookColor,
    this.beginDGD = Alignment.bottomCenter,
    this.endDGD = Alignment.topRight,
    required this.colorList,
    required this.cb,
    this.home = true,
    this.fat = false,
  });



  @override

  Widget build(BuildContext context) {
    return fat ? getFat(context):  RaisedButton(
        onPressed: ()=> cb(this.labels.text),
        color: this.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: EdgeInsets.all(8.0),
        child: home ? getInk(context) : this.labels

    );
  }

  getFat(context){
    return FlatButton(
      color: this.color,
      splashColor: Colors.black26,
      onPressed: ()=> cb(this.labels.text),
      child:  home ? getInk(context) : this.labels,
    );
  }

  getInk(context){
    return Ink(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: beginDGD,
          end: endDGD,
          colors: colorList,
        ),
        borderRadius: BorderRadius.circular(4.0),


      ),


      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,

      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        child: this.labels,

      ),
    );
  }

  getNormal(context){
    return this.labels;
  }
}
