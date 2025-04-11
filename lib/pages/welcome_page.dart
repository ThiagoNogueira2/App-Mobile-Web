import 'package:flutter/material.dart';
import 'package:projectflutter/auth/auth_gate.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 🖼 Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/welcome.jpeg',
                ), // Imagem de fundo
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🟤 Camada escura sobre a imagem
          Container(color: Colors.black.withOpacity(0.4)),

          // Conteúdo principal
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // 📝 Título
                const Text(
                  'Bem-vindo ao App!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 24), // Menor espaço entre texto e botão
                // 🟢 Botão INICIAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthGate(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                      ),
                      child: const Text(
                        'INICIAR',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40), // Espaço inferior
              ],
            ),
          ),
        ],
      ),
    );
  }
}
