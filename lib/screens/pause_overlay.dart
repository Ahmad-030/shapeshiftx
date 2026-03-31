import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onQuit;

  const PauseOverlay({super.key, required this.onResume, required this.onQuit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppTheme.accentLight.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accent.withOpacity(0.3),
              blurRadius: 40,
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⏸️', style: TextStyle(fontSize: 52))
                .animate()
                .scale(begin: const Offset(0.5, 0.5), duration: 400.ms, curve: Curves.elasticOut),

            const SizedBox(height: 12),

            Text(
              'PAUSED',
              style: GoogleFonts.nunito(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
                letterSpacing: 3,
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 8),

            Text(
              'Take a breather...',
              style: GoogleFonts.nunito(color: AppTheme.textSecondary, fontSize: 14),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 32),

            _PauseButton(
              label: 'Resume',
              emoji: '▶️',
              isPrimary: true,
              onTap: onResume,
              delay: 300,
            ),

            const SizedBox(height: 12),

            _PauseButton(
              label: 'Quit to Menu',
              emoji: '🏠',
              onTap: onQuit,
              delay: 400,
            ),
          ],
        ),
      ).animate().scale(
            begin: const Offset(0.85, 0.85),
            duration: 350.ms,
            curve: Curves.easeOut,
          ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isPrimary;
  final int delay;
  final VoidCallback onTap;

  const _PauseButton({
    required this.label,
    required this.emoji,
    required this.onTap,
    required this.delay,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(colors: [AppTheme.accent, AppTheme.accentBlue])
              : null,
          color: isPrimary ? null : AppTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPrimary ? Colors.transparent : AppTheme.accentLight.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.2, delay: delay.ms, duration: 300.ms);
  }
}
