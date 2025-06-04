import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:projectflutter/auth/auth_gate.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    // Aguarda 5 segundos e navega para AuthGate
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 214, 214), // Fundo escuro
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Campus",
                    style: TextStyle(
                      fontSize: 42,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: "M",
                    style: TextStyle(
                      fontSize: 42,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  WidgetSpan(
                    child: Icon(
                      Icons.location_on,
                      color: Color(0xFF4CAF50),
                      size: 42,
                    ),
                  ),
                  const TextSpan(
                    text: "p",
                    style: TextStyle(
                      fontSize: 42,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 350,
              height: 350,
              child: Lottie.asset('assets/animation/Loader2.json'),
            ),
          ],
        ),
      ),
    );
  }
}
