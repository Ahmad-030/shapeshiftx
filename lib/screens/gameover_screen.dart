import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../models/game_state.dart';
import 'game_screen.dart';
import 'splash_screen.dart';

class GameOverScreen extends StatefulWidget {
  final int score;
  final int level;

  const GameOverScreen({super.key, required this.score, required this.level});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  int _highScore = 0;
  bool _isNewHighScore = false;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final hs = await ScoreService.getHighScore();
    setState(() {
      _highScore = hs;
      _isNewHighScore = widget.score >= hs && widget.score > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          // Background radial
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppTheme.wrong.withOpacity(0.08), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Emoji
                    const Text('💀', style: TextStyle(fontSize: 72))
                        .animate()
                        .scale(
                      begin: const Offset(0, 0),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    )
                        .then()
                        .shake(hz: 2, offset: const Offset(3, 0), duration: 600.ms),

                    const SizedBox(height: 20),

                    Text(
                      'GAME OVER',
                      style: GoogleFonts.nunito(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.wrong,
                        letterSpacing: 3,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 500.ms)
                        .slideY(begin: 0.3, delay: 300.ms),

                    const SizedBox(height: 28),

                    // Score card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppTheme.accentLight.withOpacity(0.15)),
                      ),
                      child: Column(
                        children: [
                          if (_isNewHighScore) ...[
                            Text(
                              '🏆 NEW HIGH SCORE! 🏆',
                              style: GoogleFonts.nunito(
                                color: AppTheme.gold,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                letterSpacing: 1.5,
                              ),
                            )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .shimmer(duration: 1500.ms, color: AppTheme.gold),
                            const SizedBox(height: 12),
                          ],
                          _StatRow(label: 'Score', value: '${widget.score} pts', large: true),
                          const Divider(color: Colors.white10, height: 28),
                          _StatRow(label: 'Level Reached', value: '${widget.level}'),
                          const SizedBox(height: 8),
                          _StatRow(label: 'Best Score', value: '$_highScore pts'),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 500.ms)
                        .slideY(begin: 0.2, delay: 500.ms),

                    const SizedBox(height: 36),

                    // Play again
                    _GOButton(
                      label: 'Play Again',
                      emoji: '🔄',
                      isPrimary: true,
                      delay: 700,
                      onTap: () => Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) => const GameScreen(),
                          transitionsBuilder: (_, a, __, c) =>
                              FadeTransition(opacity: a, child: c),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    _GOButton(
                      label: 'Main Menu',
                      emoji: '🏠',
                      delay: 800,
                      onTap: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const SplashScreen()),
                            (_) => false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final bool large;

  const _StatRow({required this.label, required this.value, this.large = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            color: AppTheme.textSecondary,
            fontSize: large ? 16 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.nunito(
            color: large ? AppTheme.accentLight : AppTheme.textPrimary,
            fontSize: large ? 22 : 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _GOButton extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isPrimary;
  final int delay;
  final VoidCallback onTap;

  const _GOButton({
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(colors: [AppTheme.accent, AppTheme.accentBlue])
              : null,
          color: isPrimary ? null : AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary ? Colors.transparent : AppTheme.accentLight.withOpacity(0.2),
          ),
          boxShadow: isPrimary
              ? [BoxShadow(color: AppTheme.accent.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 6))]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 400.ms)
        .slideY(begin: 0.2, delay: delay.ms, duration: 400.ms);
  }
}