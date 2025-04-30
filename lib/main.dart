//Retornar Segunda-Feira e aprimorar o CSS.
//Estilos pegar do Figma https://www.figma.com/proto/cv1L1sXtiqvwtd2twQHK1u/Untitled?node-id=43-41&t=6PMs2qkGmWoDHfS2-1&scaling=min-zoom&content-scaling=fixed&page-id=41%3A29&starting-point-node-id=43%3A41

import 'package:flutter/material.dart';
import 'package:projectflutter/auth/auth_gate.dart';
import 'package:projectflutter/pages/welcome_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projectflutter/routes/routes.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // Adicionado para evitar erro com async no main
  await Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN4a3N3eHB6aGtqcWJmY2NtZWFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM2ODEyNTYsImV4cCI6MjA1OTI1NzI1Nn0.yWXoehqNvf9fWXPiBTh0Q7ABieIbm1OF2J1TrscnFLU',
    url: 'https://sxkswxpzhkjqbfccmeam.supabase.co',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu App Flutter',
      initialRoute: AppRoutes.welcome,
      routes: AppRoutes.routes,
    );
  }
}
