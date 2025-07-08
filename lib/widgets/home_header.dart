import 'package:flutter/material.dart';
import 'package:projectflutter/utils/app_colors.dart';

class HomeHeader extends StatefulWidget {
  final String nomeUsuario;
  final bool notificacaoEvento;
  final bool notificacaoProva;
  final List<Map<String, dynamic>>? eventosHoje;
  final List<Map<String, dynamic>>? provasHoje;

  const HomeHeader({
    super.key,
    required this.nomeUsuario,
    this.notificacaoEvento = false,
    this.notificacaoProva = false,
    this.eventosHoje,
    this.provasHoje,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool _showBanner = false;

  void _showNotificationBanner() {
    setState(() {
      _showBanner = true;
    });
  }

  void _hideBanner() {
    setState(() {
      _showBanner = false;
    });
  }

  @override
  void didUpdateWidget(covariant HomeHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se mudou a notificação, esconder o banner
    if (widget.notificacaoEvento != oldWidget.notificacaoEvento ||
        widget.notificacaoProva != oldWidget.notificacaoProva) {
      _showBanner = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_showBanner &&
            (widget.notificacaoEvento || widget.notificacaoProva)) {
          _hideBanner();
        }
      },
      child: Container(
        height: 320,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
              AppColors.primaryLight,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Banner fixo no topo, aparece só ao clicar no sino
            if (_showBanner &&
                (widget.notificacaoEvento || widget.notificacaoProva))
              Positioned(
                top: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.notificacaoEvento && widget.eventosHoje != null)
                      Container(
                        constraints: const BoxConstraints(maxWidth: 260),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFFDE9A9),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.event,
                              color: Color(0xFF856404),
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '🎉 Hoje você tem o seguinte evento:',
                                    style: TextStyle(
                                      color: Color(0xFF856404),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      height: 1.3,
                                    ),
                                  ),
                                  ...widget.eventosHoje!.map(
                                    (evento) => Text(
                                      '- ${evento['nome_evento'] ?? 'Evento'} (${evento['hora_inicio'] ?? '--:--'})',
                                      style: const TextStyle(
                                        color: Color(0xFF856404),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (widget.notificacaoProva && widget.provasHoje != null)
                      Container(
                        constraints: const BoxConstraints(maxWidth: 260),
                        margin:
                            widget.notificacaoEvento
                                ? const EdgeInsets.only(top: 10)
                                : null,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8D7DA),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFF1B0B7),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.assignment_turned_in,
                              color: Color(0xFF721C24),
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '📝 Hoje você tem a seguinte prova:',
                                    style: TextStyle(
                                      color: Color(0xFF721C24),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      height: 1.3,
                                    ),
                                  ),
                                  ...widget.provasHoje!.map(
                                    (prova) => Text(
                                      '- ${prova['materias']?['nome'] ?? 'Prova'} (${prova['hora_inicio'] ?? '--:--'})',
                                      style: const TextStyle(
                                        color: Color(0xFF721C24),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            // Elementos decorativos
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Conteúdo principal
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho com notificação
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Olá! 👋',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.nomeUsuario,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            if (!_showBanner)
                              InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  if (widget.notificacaoEvento ||
                                      widget.notificacaoProva) {
                                    _showNotificationBanner();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.notifications_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            if (!_showBanner &&
                                (widget.notificacaoProva ||
                                    widget.notificacaoEvento))
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Badge do semestre
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Semestre Outono 2025',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Status/Localização
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Campus Principal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Centro Universitário Cidade Verde',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
