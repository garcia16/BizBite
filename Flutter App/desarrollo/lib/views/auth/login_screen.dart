
import 'package:desarrollo/logic/log_in/logIn.dart';
import 'package:desarrollo/views/auth/register_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              _buildRegisterButton(),
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
          'La mejor forma de gestionar tu negocio',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(){
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("¿No tienes cuenta?"),
            TextButton(onPressed: (){
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
            }, child: const Text("Regístrate", style: TextStyle(color: Colors.blue),))
          ],
        ),
      );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          _buildTextField(hint: 'Correo Electrónico', icon: Icons.email,controller: emailController),
          const SizedBox(height: 10),
          _buildTextField(hint: 'Contraseña', icon: Icons.lock, isPassword: true, controller: passwordController),
        ],
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, bool isPassword = false,required TextEditingController controller}) {
    return TextField(
      controller: controller,
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
        checkTextField(context, emailController,passwordController);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple, 
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text('Iniciar Sesión'),
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