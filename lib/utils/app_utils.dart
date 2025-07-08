import 'package:flutter/material.dart';

class AppUtils {
  // Formatação de data
  static String formatarData(DateTime data) {
    final diasDaSemana = [
      'Domingo',
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
    ];
    
    final diaDaSemana = diasDaSemana[data.weekday % 7];
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year;

    return '$diaDaSemana, $dia/$mes/$ano';
  }

  static String formatarDataSimples(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year;

    return '$dia/$mes/$ano';
  }

  static String formatarDataHoje() {
    return formatarData(DateTime.now());
  }

  // Formatação de horário
  static String formatarHorario(String? horario) {
    if (horario == null || horario.isEmpty) return '--:--';
    return horario;
  }

  static String formatarHorarioRange(String? inicio, String? fim) {
    final inicioFormatado = formatarHorario(inicio);
    final fimFormatado = formatarHorario(fim);
    return '$inicioFormatado - $fimFormatado';
  }

  // Formatação de período
  static String formatarPeriodo(int? periodo) {
    switch (periodo) {
      case 1:
        return 'Matutino';
      case 2:
        return 'Vespertino';
      case 3:
        return 'Noturno';
      default:
        return 'Não informado';
    }
  }

  // Validações
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidName(String name) {
    return name.trim().length >= 2;
  }

  // Utilitários de string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String pluralize(String singular, int count) {
    return count == 1 ? singular : '${singular}s';
  }

  // Utilitários de data
  static DateTime getInicioSemana(DateTime data) {
    return data.subtract(Duration(days: data.weekday - 1));
  }

  static DateTime getFimSemana(DateTime data) {
    final inicio = getInicioSemana(data);
    return inicio.add(const Duration(days: 4)); // Segunda a sexta
  }

  static bool isHoje(DateTime data) {
    final hoje = DateTime.now();
    return data.year == hoje.year && 
           data.month == hoje.month && 
           data.day == hoje.day;
  }

  static bool isMesmaSemana(DateTime data1, DateTime data2) {
    final inicio1 = getInicioSemana(data1);
    final inicio2 = getInicioSemana(data2);
    return inicio1.isAtSameMomentAs(inicio2);
  }

  // Utilitários de UI
  static void showSnackBar(BuildContext context, String message, {
    Color? backgroundColor,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(
      context, 
      message, 
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 4),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(
      context, 
      message, 
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    );
  }

  // Utilitários de navegação
  static void navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void navigateToAndReplace(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Utilitários de debug
  static void log(String message) {
    print('🔍 [APP_LOG] $message');
  }

  static void logError(String message, [dynamic error]) {
    print('❌ [APP_ERROR] $message');
    if (error != null) {
      print('❌ [APP_ERROR_DETAILS] $error');
    }
  }

  static void logInfo(String message) {
    print('ℹ️ [APP_INFO] $message');
  }

  static void logSuccess(String message) {
    print('✅ [APP_SUCCESS] $message');
  }

  // Utilitários de performance
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }
} 