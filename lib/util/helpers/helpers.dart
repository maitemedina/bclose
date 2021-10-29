import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
// import 'package:flutter_share/flutter_share.dart';
// import 'package:html/parser.dart';
import 'package:intl/intl.dart';



bool get isIos => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

bool validatePassword(String value){
  String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}

class Util{


  // static String parseHtmlString(String htmlString) {
  //
  //   var document = parse(htmlString);
  //
  //   String parsedString = parse(document.body.text).documentElement.text;
  //
  //   return parsedString;
  //
  //
  // }




  static String parseData(String data) {

    if (data == "")
      return "";

    var dateTime = DateTime.parse(data);
    String formattedDate = DateFormat('MMMM dd, yyyy')
        .format(dateTime);
    //
    // var formatter = new DateFormat('M-dd-yyyy').parse(data);
    // String formattedDate = formatter.toString();
    // print(formattedDate);
    return '$formattedDate';

  }

  static String parseDataH(String data) {

    if (data == "")
      return "";

    var dateTime = DateTime.parse(data);
    String formattedDate = DateFormat('dd MMMM yyyy, hh:mm')
        .format(dateTime);
    return '$formattedDate';

  }

  static String parseDataM(String data) {

    try
    {
      var dateTime = DateTime.parse(data);

      print(dateTime);

      String? formattedDate =
      DateFormat('MM')
          .format(dateTime);
      return '$formattedDate';
    }
    catch (Exception)
    {
      return '••';
    }

  }

  static String parseDataY(String data) {
    try
    {
      var dateTime = DateTime.parse(data);

      print(dateTime);

      String? formattedDate =
      DateFormat('yyyy')
          .format(dateTime);
      return '$formattedDate';
    }
    catch (Exception)
    {
      return '••••';
    }


  }

  static String parseDataD(String data) {

    try
    {
      var dateTime = DateTime.parse(data);

      print(dateTime);

      String? formattedDate =
      DateFormat('dd')
          .format(dateTime);
      return '$formattedDate';
    }
    catch (Exception)
    {
    return '••';
    }



    //
    // var formatter = new DateFormat('M-dd-yyyy').parse(data);
    // String formattedDate = formatter.toString();
    // print(formattedDate);


  }
  static String parseDataTime(String data) {

    var dateTime = DateTime.parse(data);
    String formattedDate =
    DateFormat('HH:mm')
        .format(dateTime);
    //
    // var formatter = new DateFormat('M-dd-yyyy').parse(data);
    // String formattedDate = formatter.toString();
    // print(formattedDate);
    return '$formattedDate';

  }
  static DateTime getDataTime(String data) {

    var dateTime = DateTime.parse(data);
    print(data);
    print(data);
    print(dateTime.toString());
    print(dateTime.toString());



    return dateTime;

  }

  static Timestamp getTimestamp(String data) {

    var dateTime = DateTime.parse(data);
    print(data);


    Timestamp myTimeStamp = Timestamp.fromDate(dateTime); //To TimeStamp

    DateTime myDateTime = myTimeStamp.toDate(); // TimeStamp to DateTime

    print("current phone data is: ${myTimeStamp.millisecondsSinceEpoch}");
    print("current phone data is: $myDateTime");


    return myTimeStamp;

  }

  static DateTime getTimestampToData(int data) {



    Timestamp myTimeStamp = Timestamp.fromMillisecondsSinceEpoch(data); //To TimeStamp

    DateTime myDateTime = myTimeStamp.toDate(); // TimeStamp to DateTime

    print(myDateTime);
    return myDateTime;

  }




}

