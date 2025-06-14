import 'package:flutter/material.dart';
import '../pages/welcome_page.dart';
import '../pages/login_pages.dart';
import '../pages/register_page.dart';
import '../pages/home_pages.dart';

//Criando as rotas para chamar elas, em ocasioes especificas dentro do app
class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    welcome: (context) => const WelcomePage(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    home: (context) => const PaginaInicial(),
  };
}
