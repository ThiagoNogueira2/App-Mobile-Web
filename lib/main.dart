//Retornar Segunda-Feira e aprimorar o CSS.
//Estilos pegar do Figma https://www.figma.com/proto/cv1L1sXtiqvwtd2twQHK1u/Untitled?node-id=43-41&t=6PMs2qkGmWoDHfS2-1&scaling=min-zoom&content-scaling=fixed&page-id=41%3A29&starting-point-node-id=43%3A41

import 'package:flutter/material.dart';
import 'package:projectflutter/pages/welcome_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // Adicionado para evitar erro com async no main
  await Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5laWVkcW9wemRuaWV2Z21mYm10Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM3ODYxMjcsImV4cCI6MjA1OTM2MjEyN30.wD9Qa5qwmstJVofDIT2hpMoxvrIDzH_uyN-IGigehC0',
    url: 'https://neiedqopzdnievgmfbmt.supabase.co',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(), //começa na tela de boas-vindas
    ); // <-- Fechamento correto do widget
  }
}
