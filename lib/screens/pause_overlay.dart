import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class PauseOverlay extends StatefulWidget {
  final VoidCallback onResume;
  final VoidCallback onQuit;

  const PauseOverlay({super.key, required this.onResume, required this.onQuit});

  @override
  State<PauseOverlay> createState() => _PauseOverlayState();
}

class _PauseOverlayState extends State<PauseOverlay> {
  bool _isMusicOn = true;

  @override
  void initState() {
    super.initState();
    _isMusicOn = MusicService().isMusicOn;
  }

  Future<void> _toggleMusic() async {
    await MusicService().toggle();
    if (mounted) setState(() => _isMusicOn = MusicService().isMusicOn);
  }

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

            const SizedBox(height: 24),

            // ── Music toggle row ────────────────────────────────────────────
            GestureDetector(
              onTap: _toggleMusic,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _isMusicOn
                        ? AppTheme.accentLight.withOpacity(0.35)
                        : AppTheme.textSecondary.withOpacity(0.15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isMusicOn ? Icons.music_note_rounded : Icons.music_off_rounded,
                          color: _isMusicOn ? AppTheme.accentLight : AppTheme.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Music',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    // Toggle pill
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 46,
                      height: 26,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: _isMusicOn
                            ? AppTheme.accent
                            : AppTheme.textSecondary.withOpacity(0.3),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        alignment: _isMusicOn ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, delay: 250.ms, duration: 300.ms),

            const SizedBox(height: 16),

            _PauseButton(
              label: 'Resume',
              emoji: '▶️',
              isPrimary: true,
              onTap: widget.onResume,
              delay: 300,
            ),

            const SizedBox(height: 12),

            _PauseButton(
              label: 'Quit to Menu',
              emoji: '🏠',
              onTap: widget.onQuit,
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