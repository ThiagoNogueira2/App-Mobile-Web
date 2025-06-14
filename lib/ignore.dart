//Maneira que iremos lidar com a responsividade. Entretanto teremos que avaliar os formatos para ficar ideal.

// import 'package:flutter/material.dart';

// class ImagemResponsiva extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double larguraTela = MediaQuery.of(context).size.width;

//     String imagem;

//     if (larguraTela <= 400) {
//       imagem = 'assets/imagens/imagem_pequena.png';
//     } else if (larguraTela > 400 && larguraTela <= 600) {
//       imagem = 'assets/imagens/imagem_media.png';
//     } else if (larguraTela > 600 && larguraTela <= 800) {
//       imagem = 'assets/imagens/imagem_grande.png';
//     } else if (larguraTela > 800 && larguraTela <= 1000) {
//       imagem = 'assets/imagens/imagem_extra_grande.png';
//     } else {
//       imagem = 'assets/imagens/imagem_ultra.png';
//     }

//     return Image.asset(imagem);
//   }
// }
