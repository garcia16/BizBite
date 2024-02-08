// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'share_preferences/preferences.dart';
import 'views/auth/register_screen.dart';
import 'views/main_views/start/main_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/welcome/welcome_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  Platform.isAndroid ? await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: '............................',
      appId: '.............................',
      messagingSenderId: 'MessagingSenderId',
      projectId: '.........................',
    )) : await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => ThemeProvider(isDarkMode: Preferences.isDarkMode),),
      ],
    child: MyApp()
    ),
  );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BizBite',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).currentTheme,

      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(), 
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}
