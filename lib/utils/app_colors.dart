import 'package:flutter/material.dart';

class AppColors {
  // Cores principais
  static const Color primary = Color(0xFF44A301);
  static const Color primaryDark = Color(0xFF44A301); // Verde escuro
  static const Color primaryLight = Color(0xFF44A301); // Verde claro

  // Cores secundárias
  static const Color secondary = Color(
    0xFFD09B2C,
  ); // Amarelo mostarda (baseado na logo)
  static const Color success = Color(0xFF6A8A3A); // Verde sucesso
  static const Color warning = Color(0xFFD09B2C); // Amarelo mostarda
  static const Color error = Color(0xFFB00020); // Vermelho padrão
  static const Color info = Color(0xFF4B5F2A); // Verde escuro

  // Cores de texto
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Cores de fundo
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Cores de gradiente
  static const List<Color> primaryGradient = [
    Color(0xFF44A301),
    Color(0xFF44A301),
    Color(0xFF44A301),
  ];

  static const List<Color> successGradient = [
    Color(0xFF44A301),
    Color(0xFF44A301),
  ];

  static const List<Color> warningGradient = [
    Color(0xFFD09B2C),
    Color(0xFFB8860B),
  ];

  // Cores de sombra
  static Color shadowLight = Colors.black.withOpacity(0.05);
  static Color shadowMedium = Colors.black.withOpacity(0.1);
  static Color shadowDark = Colors.black.withOpacity(0.2);
}
