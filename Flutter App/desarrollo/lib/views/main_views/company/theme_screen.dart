import 'package:desarrollo/share_preferences/preferences.dart';
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class ThemeView extends StatefulWidget {
  @override
  _ThemeViewState createState() => _ThemeViewState();
}

class _ThemeViewState extends State<ThemeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarToBack(context,'Tema'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Selecciona el tema", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: Preferences.isDarkMode
                      ? [Colors.black87, Colors.black54]
                      : [Colors.yellowAccent, Colors.orangeAccent],
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    Preferences.isDarkMode = !Preferences.isDarkMode;
                    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                    Preferences.isDarkMode 
                      ? themeProvider.setDarkMode()
                      : themeProvider.setLightMode();
                  });
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return RotationTransition(turns: animation, child: child);
                  },
                  child: Preferences.isDarkMode
                      ? Icon(Icons.nightlight_round, key: UniqueKey(), size: 40, color: Colors.white)
                      : Icon(Icons.sunny, key: UniqueKey(), size: 40, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
