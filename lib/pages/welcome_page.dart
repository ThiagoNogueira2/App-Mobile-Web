import 'package:flutter/material.dart';
import 'package:projectflutter/auth/auth_gate.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 🖼 Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/welcome2.jpg',
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
                SizedBox(height: screenHeight * 0.3), // Ajusta o espaço superior

                // 📝 Título
                SizedBox(height: screenHeight * 0.3,),
                Text(
                  'Bem-vindo ao App!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.08, // Ajusta o tamanho da fonte
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: screenHeight * 0.03), // Ajusta o espaço entre o título e o botão

                // 🟢 Botão INICIAR
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
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
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                      ),
                      child: Text(
                        'INICIAR',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05, // Ajusta o tamanho da fonte do botão
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05), // Ajusta o espaço inferior
              ],
            ),
          ),
        ],
      ),
    );
  }
}
