
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../main_views/start/create_company_screen.dart';
import '../main_views/start/join_company_screen.dart';

class WelcomeDecisionScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final animationController = useRef<AnimationController?>(null);

    animationController.value ??= AnimationController(duration: const Duration(seconds: 1), vsync: Navigator.of(context));

    final animation = Tween(begin: 0.0, end: 1.0).animate(animationController.value!);

    useEffect(() {
      animationController.value!.forward();
      return () {
        if (animationController.value!.isAnimating || animationController.value!.isCompleted) {
          animationController.value!.dispose();
        }
      };
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.black,
        child: FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTopSection(),
                  const Text(
                    'Continuemos con el registro',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildNeumorphicButton(
                    text: 'Crear tu empresa',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateCompanyScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildNeumorphicButton(
                    text: 'Unirme a una empresa',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => JoinCompanyScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
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
      ],
    );
  }

  Widget _buildNeumorphicButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.purple,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}
