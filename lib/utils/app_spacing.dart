import 'package:flutter/material.dart';

class AppSpacing {
  // Espaçamentos base
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
  
  // Padding padrão
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  
  // Padding horizontal
  static const EdgeInsets paddingHXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHXl = EdgeInsets.symmetric(horizontal: xl);
  
  // Padding vertical
  static const EdgeInsets paddingVXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVXl = EdgeInsets.symmetric(vertical: xl);
  
  // Margens
  static const EdgeInsets marginXs = EdgeInsets.all(xs);
  static const EdgeInsets marginSm = EdgeInsets.all(sm);
  static const EdgeInsets marginMd = EdgeInsets.all(md);
  static const EdgeInsets marginLg = EdgeInsets.all(lg);
  static const EdgeInsets marginXl = EdgeInsets.all(xl);
  
  // Margens horizontais
  static const EdgeInsets marginHXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets marginHSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets marginHMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets marginHLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets marginHXl = EdgeInsets.symmetric(horizontal: xl);
  
  // Margens verticais
  static const EdgeInsets marginVXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets marginVSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets marginVMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets marginVLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets marginVXl = EdgeInsets.symmetric(vertical: xl);
  
  // Espaçamentos específicos
  static const SizedBox spaceXs = SizedBox(height: xs, width: xs);
  static const SizedBox spaceSm = SizedBox(height: sm, width: sm);
  static const SizedBox spaceMd = SizedBox(height: md, width: md);
  static const SizedBox spaceLg = SizedBox(height: lg, width: lg);
  static const SizedBox spaceXl = SizedBox(height: xl, width: xl);
  
  // Espaçamentos verticais
  static const SizedBox spaceVXs = SizedBox(height: xs);
  static const SizedBox spaceVSm = SizedBox(height: sm);
  static const SizedBox spaceVMd = SizedBox(height: md);
  static const SizedBox spaceVLg = SizedBox(height: lg);
  static const SizedBox spaceVXl = SizedBox(height: xl);
  
  // Espaçamentos horizontais
  static const SizedBox spaceHXs = SizedBox(width: xs);
  static const SizedBox spaceHSm = SizedBox(width: sm);
  static const SizedBox spaceHMd = SizedBox(width: md);
  static const SizedBox spaceHLg = SizedBox(width: lg);
  static const SizedBox spaceHXl = SizedBox(width: xl);
  
  // Bordas arredondadas
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusCircular = 50.0;
  
  // Bordas
  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadiusXxl = BorderRadius.all(Radius.circular(radiusXxl));
  static const BorderRadius borderRadiusCircular = BorderRadius.all(Radius.circular(radiusCircular));
} 