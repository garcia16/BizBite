import 'package:flutter/material.dart';
import '../welcome/welcome_decision_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 60), 
              _buildTopSection(), 
              const SizedBox(height: 30),
              _buildLoginForm(), 
              const SizedBox(height: 20),
              _buildSignUpButton(context), 
              const SizedBox(height: 20),
              _buildSocialLogin() 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      children: <Widget>[
        // Agregar una imagen y el texto
        Image.asset('assets/logo.png', height: 180), 
        const Text(
          'BizBite',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'ChesNagroBlack'
          ),
        ),
        const Text(
          'Completa el formulario para continuar con el registro',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          _buildTextField(hint: 'Correo Electrónico', icon: Icons.email),
          const SizedBox(height: 10),
          _buildTextField(hint: 'Nombre y apellidos', icon: Icons.person),
          const SizedBox(height: 10),
          _buildTextField(hint: 'Contraseña', icon: Icons.lock, isPassword: true),
          const SizedBox(height: 10),
          _buildTextField(hint: 'Confirmar contraseña', icon: Icons.lock, isPassword: true),
        ],
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeDecisionScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.purple, 
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text('Registrarse'),
    );
  }

  Widget _buildSocialLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Image.asset('assets/google.png', scale: 10,), 
          onPressed: () {},
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: Image.asset('assets/apple.png', scale: 10,),
          onPressed: () {},
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: Image.asset('assets/facebook.png', scale: 10,),
          onPressed: () {},
        ),
      ],
    );
  }
}