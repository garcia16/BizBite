
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WelcomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: const Duration(seconds: 1));
    final animation = CurvedAnimation(parent: animationController, curve: Curves.elasticOut);

    useEffect(() {
      animationController.forward();

      Future.delayed(const Duration(seconds: 2), () {
        // Verificar el estado de autenticación después de 2 segundos
        if (FirebaseAuth.instance.currentUser != null) {
          // Usuario ha iniciado sesión, navegar a MainScreen
          Navigator.of(context).pushReplacementNamed('/main');
        } else {
          // Usuario no ha iniciado sesión, navegar a LoginScreen
          Navigator.of(context).pushReplacementNamed('/login');
        }
      });

    }, const []);

    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 180),
                const SizedBox(height: 20),
                const Text(
                  'BizBite',
                  style: TextStyle(
                    fontSize: 29,
                    color: Colors.white,
                    fontFamily: 'ChesNagroBlack',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'La aplicación para gestionar tu negocio',
                  style: TextStyle(fontSize: 17, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
