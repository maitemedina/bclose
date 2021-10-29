import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:http/http.dart' as http;
import 'package:bclose/constants/api_path.dart';



mixin RequestHandler {

  static ILocalStorage localStorage = new PrefsLocalStorageService();


  static Future statusError(request) async {
    try {
      final response =  await request.timeout(const Duration(seconds: 60),onTimeout : () {

        throw TimeoutException('The connection has timed out, Please try again!');

      });

      print(response.statusCode);
      print(response.statusCode);
      print(response.statusCode);
      print(response.statusCode);

      if (response.statusCode == 200){

        var result = jsonDecode(response.body);
        return result;
      } else{
        print(response.body);
        var result = jsonDecode(response.body);
        var resultSms = result is String ? result : result[0]['message'];

        if(resultSms == "email must be unique")
        return "userExiste";

        return ErrorRequest.ServerError;
      }
    } on SocketException {
      return ErrorRequest.Internet;
    } on TimeoutException {
      return ErrorRequest.TimeOut;
    }


  }

  static Future servicesPost(Map<String,dynamic> body, String url) async{

    final response =  await  statusError(http.post(Uri.parse(ApiPath.BASE_URL+url),

        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body)
    ));
    print(response);
    return response;

  }

  static Future servicesPut(Map<String,dynamic> body, String url) async{

    final response =  await  statusError(http.put(Uri.parse(ApiPath.BASE_URL+url),

        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body)
    ));
    print(response);
    return response;

  }


  static Future servicesDelete(Map<String,dynamic> body, String url) async{

    final response =  await  statusError(http.delete(Uri.parse(ApiPath.BASE_URL+url),

        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body)
    ));
    print(response);
    return response;

  }
  // static Future servicesDeleteNoBody(String url) async{
  //
  //   final response =  await  statusError(http.delete(Uri.parse(ApiPath.BASE_URL+url),
  //
  //       headers: {"Content-Type": "application/json"},
  //   ));
  //   print(Uri.parse(ApiPath.BASE_URL+url));
  //   print(response);
  //   return response;
  //
  // }




  static Future servicesGet(String url) async{

    var myid = await localStorage.get("id").then((value) => value.toString());
    print(myid);
    print(myid);
    print(myid);
    final response =  await  statusError(http.get(Uri.parse(ApiPath.BASE_URL+"$url/$myid")));
    return response;

  }
  static Future servicesGetPatient(String url) async{


    final response =  await  statusError(http.get(Uri.parse(ApiPath.BASE_URL+"$url")));
    return response;

  }

  static Future uploadImagePost(List<File> file, String url, String name, String category) async {

    var myid = await localStorage.get("id").then((value) => value.toString());
    print(ApiPath.BASE_URL+url);
    final request =
    http.MultipartRequest('POST', Uri.parse( ApiPath.BASE_URL+url));
    if(file != null)
      for(var img in file){
        request.files.add(await http.MultipartFile.fromPath('file', img.path));
      }
    request.fields['name'] = name;
    request.fields['user_id'] = myid;
    request.fields['type'] = category;


    var res = await request.send();


    return res;



  }



}