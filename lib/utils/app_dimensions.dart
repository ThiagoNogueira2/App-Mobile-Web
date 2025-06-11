import 'package:flutter/material.dart';

class AppDimensions {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockWidth;
  static late double blockHeight;

  // Inicializa com o contexto da tela atual
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;
  }

  // Exemplo de medidas reutilizáveis
  static double get paddingSmall => blockWidth * 5;
  static double get paddingMedium => blockWidth * 10;
  static double get paddingLarge => blockWidth * 6;

  static double get fontSmall => blockWidth * 3.5;
  static double get fontMedium => blockWidth * 4.2;
  static double get fontLarge => blockWidth * 5.5;

  static double get avatarRadius => blockWidth * 8;
  static double get buttonHeight => blockHeight * 6;
}
