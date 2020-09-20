import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class MyAppSettings {
  MyAppSettings(StreamingSharedPreferences preferences)
      : darkMode = preferences.getBool('darkMode', defaultValue: false);

  final Preference<bool> darkMode;
}
