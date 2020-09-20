import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/user.dart';
import 'package:insta/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:insta/services/auth_service.dart';
import 'services/darktheme.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final preferences = await StreamingSharedPreferences.instance;
  final settings = MyAppSettings(preferences);
  runApp(MyApp(settings: settings));
}

class MyApp extends StatelessWidget {
  MyApp({this.settings});
  final MyAppSettings settings;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<bool>.value(
      value: settings.darkMode,
      child: StreamProvider<UserDetails>.value(
        value: AuthService().user,
        child: MaterialApp(
          home: Wrapper(),
        ),
      ),
    );
  }
}
