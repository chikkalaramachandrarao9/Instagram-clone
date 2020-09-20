import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

//class DarkTheme {
//  setTheme() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    if (prefs.containsKey('darkThemeValue'))
//      prefs.setBool('darkThemeValue', !getTheme());
//    else {
//      prefs.setBool('darkThemeValue', true);
//    }
//  }
//
//  getTheme() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    //Return bool
//    bool boolValue;
//    if (prefs.containsKey('darkThemeValue'))
//      boolValue = prefs.getBool('darkThemeValue');
//    else {
//      boolValue = false;
//    }
//    return boolValue;
//  }
//}

class MyAppSettings {
  MyAppSettings(StreamingSharedPreferences preferences)
      : darkMode = preferences.getBool('darkMode', defaultValue: false);

  final Preference<bool> darkMode;
}
