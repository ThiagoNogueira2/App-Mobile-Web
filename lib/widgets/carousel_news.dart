import 'dart:async';
import 'package:flutter/material.dart';

class CarouselNews extends StatefulWidget {
  final List<Map<String, dynamic>> noticias;
  final Function(Map<String, dynamic>) onNewsTap;

  const CarouselNews({
    super.key,
    required this.noticias,
    required this.onNewsTap,
  });

  @override
  State<CarouselNews> createState() => _CarouselNewsState();
}

class _CarouselNewsState extends State<CarouselNews> {
  late final PageController _carrosselController;
  Timer? _carrosselTimer;

  @override
  void initState() {
    super.initState();
    _carrosselController = PageController(viewportFraction: 0.85);

    // Timer para auto-scroll do carrossel
    _carrosselTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      if (!_carrosselController.hasClients) return;
      final noticiasLength = widget.noticias.length;
      int nextPage = _carrosselController.page?.round() ?? 0;
      nextPage = (nextPage + 1) % noticiasLength;
      _carrosselController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _carrosselTimer?.cancel();
    _carrosselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        itemCount: widget.noticias.length,
        controller: _carrosselController,
        itemBuilder: (context, index) {
          final noticia = widget.noticias[index];
          return GestureDetector(
            onTap: () => widget.onNewsTap(noticia),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(noticia['img']!, fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Indicador de clique
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.touch_app_rounded,
                          color: Color(0xFF2563EB),
                          size: 16,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 28,
                      right: 16,
                      child: Text(
                        noticia['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black54, blurRadius: 8),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 10,
                      right: 16,
                      child: Text(
                        noticia['desc']!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 