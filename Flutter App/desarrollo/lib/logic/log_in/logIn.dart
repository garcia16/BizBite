// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../views/main_views/start/main_screen.dart';

void checkTextField(BuildContext context, TextEditingController emailController, TextEditingController passwordController) async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    // Mostrar algún mensaje de error
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor, ingrese correo electrónico y contraseña',style: TextStyle(color: Theme.of(context).colorScheme.surface),),
        backgroundColor: Theme.of(context).colorScheme.outline,
      )
    );
  } else {
    // Llamar a la función de autenticación de Firebase
    await signInWithEmailPassword(email, password,context);
  }
}

Future<void> signInWithEmailPassword(String email, String password, BuildContext context) async {
  try {
    // Intento de inicio de sesión con Firebase
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    // Navegar a la pantalla principal si el inicio de sesión es exitoso
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  } on FirebaseAuthException catch (e) {
    // Manejar los errores de autenticación
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error de autenticación: ${e.message}',style: TextStyle(color: Theme.of(context).colorScheme.surface),),
        backgroundColor: Theme.of(context).colorScheme.outline,
      )
    );
  }
}
