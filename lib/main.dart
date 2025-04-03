import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'registrer.dart'; // Adicionando a importação do register.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://sxkswxpzhkjqbfccmeam.supabase.co', //Mesma chave sendo chamada
    // Chave pegada do meu banco de dados, está sendo interligada de acordo com isso
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN4a3N3eHB6aGtqcWJmY2NtZWFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM2ODEyNTYsImV4cCI6MjA1OTI1NzI1Nn0.yWXoehqNvf9fWXPiBTh0Q7ABieIbm1OF2J1TrscnFLU', // Chave anônima do seu projeto
  );

  runApp(MyApp()); //Aqui nos temos meu aplicativo sendo chamado
  //De acordo com o registrer irá ter a construção do app com o forms
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RegisterScreen(), //
    );
  }
}
