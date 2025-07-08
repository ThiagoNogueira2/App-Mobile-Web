import 'package:flutter/material.dart';
import 'package:projectflutter/utils/app_colors.dart';

class QuickAccessButtons extends StatelessWidget {
  final VoidCallback onAgendaTap;

  const QuickAccessButtons({super.key, required this.onAgendaTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickAccessButton(
              Icons.calendar_today_rounded,
              'Próximas\nAulas',
              const Color(0xFF2563EB), // azul vivo
              onAgendaTap,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildQuickAccessButton(
              Icons.meeting_room_rounded,
              'Localizar\nSala',
              const Color(0xFF10B981),
              () {},
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildQuickAccessButton(
              Icons.map_rounded,
              'Mapa do\nCampus',
              const Color(0xFFF59E0B),
              () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 28, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
