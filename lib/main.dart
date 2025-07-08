//Retornar Segunda-Feira e aprimorar o CSS.
//Retornar Segunda-Feira e aprimorar o CSS.
//Estilos pegar do Figma https://www.figma.com/proto/cv1L1sXtiqvwtd2twQHK1u/Untitled?node-id=43-41&t=6PMs2qkGmWoDHfS2-1&scaling=min-zoom&content-scaling=fixed&page-id=41%3A29&starting-point-node-id=43%3A41

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projectflutter/routes/routes.dart';
import 'package:projectflutter/services/preload_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://neiedqopzdnievgmfbmt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5laWVkcW9wemRuaWV2Z21mYm10Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM3ODYxMjcsImV4cCI6MjA1OTM2MjEyN30.wD9Qa5qwmstJVofDIT2hpMoxvrIDzH_uyN-IGigehC0',
  );

  // Inicia pré-carregamento em background
  PreloadService().preloadData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu App Flutter',
      theme: ThemeData(
        primaryColor: const Color(0xFF6A8A3A), // Verde principal
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF6A8A3A),
          secondary: const Color(0xFFD09B2C), // Amarelo mostarda
          background: const Color(0xFFF8FAFC),
          surface: Colors.white,
          error: const Color(0xFFB00020),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6A8A3A),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF4B5F2A)),
          bodyMedium: TextStyle(color: Color(0xFF4B5F2A)),
          titleLarge: TextStyle(color: Color(0xFF6A8A3A)),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF6A8A3A),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      initialRoute: AppRoutes.welcome,
      routes: AppRoutes.routes,
    );
  }
}
