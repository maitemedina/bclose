
import 'package:shared_preferences/shared_preferences.dart';

import 'interface_shared_preference.dart';

class PrefsLocalStorageService implements ILocalStorage {
  @override
  Future delete(String key) async {
    var shared = await SharedPreferences.getInstance();
    shared.remove(key);
  }

  @override
  Future get(String key) async {
    var shared = await SharedPreferences.getInstance();
    return shared.get(key);
  }



  @override
  Future put(String key, dynamic value) async {
    var shared = await SharedPreferences.getInstance();
    if (value is bool) {
      shared.setBool(key, value);
    } else if(value is int) {
      shared.setInt(key, value);
    }else if(value is List<String>){
      shared.setStringList(key, value);
    }else{
      shared.setString(key, value);
    }
  }

  @override
  Future clear()async{
    var shared = await SharedPreferences.getInstance();
    shared.clear();

  }


}
