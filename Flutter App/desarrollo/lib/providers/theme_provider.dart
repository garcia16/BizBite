// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
class ThemeProvider extends ChangeNotifier{

  ThemeData currentTheme;


  ThemeProvider({
    required bool isDarkMode
  }): currentTheme = isDarkMode ? 
    ThemeData(
      colorScheme: ColorScheme.dark(
       primary: Color.fromARGB(255, 224, 224, 224),
       secondary: Color.fromARGB(255, 0, 123, 255),
       tertiary: Color.fromARGB(255, 0, 123, 255),
       surface: Color.fromARGB(255, 224, 224, 224),
       onBackground: Color.fromARGB(255, 0, 123, 255),
       outline: Color.fromARGB(255, 36, 36, 36),
       onSecondary: Color.fromARGB(255, 224, 224, 224),
       onTertiary: Colors.black,
       onTertiaryContainer: Colors.black,
       error: Colors.red,
      ),
    ) 
    : 
    ThemeData(
      colorScheme: ColorScheme.light(
        primary: Color(0xFF2C3E50),
        secondary: Colors.blue,
        tertiary: Colors.white,
        surface: Colors.black,
        onBackground: Color(0xFF2C3E50),
        outline: Colors.white,
        onSecondary: Color(0xFF2C3E50),
        onTertiary: Color(0xFF2C3E50),
        onTertiaryContainer: Colors.white,
        error: Colors.red,
      )
    );

  setLightMode() {
    currentTheme = ThemeData(
      colorScheme: ColorScheme.light(
        primary: Color(0xFF2C3E50),
        secondary: Colors.blue,
        tertiary: Colors.white,
        surface: Colors.black,
        onBackground: Color(0xFF2C3E50),
        outline: Colors.white,
        onSecondary: Color(0xFF2C3E50),
        onTertiary: Color(0xFF2C3E50),
        onTertiaryContainer: Colors.white,
        error: Colors.red,

      ),
    );
    notifyListeners();
  }

  setDarkMode() {
    currentTheme = ThemeData(
      colorScheme: ColorScheme.dark(
       primary: Color.fromARGB(255, 224, 224, 224),
       secondary: Color.fromARGB(255, 0, 123, 255),
       tertiary: Color.fromARGB(255, 0, 123, 255),
       surface: Color.fromARGB(255, 224, 224, 224),
       onBackground: Color.fromARGB(255, 0, 123, 255),
       outline: Color.fromARGB(255, 36, 36, 36),
       onSecondary: Color.fromARGB(255, 224, 224, 224),
       onTertiary: Colors.black,
       onTertiaryContainer: Colors.black,
       error: Colors.red,
      ),
    );
    notifyListeners();
  }
}