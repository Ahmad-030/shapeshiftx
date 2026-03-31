import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../models/game_state.dart';
import 'game_screen.dart';
import 'highscore_screen.dart';
import 'about_screen.dart';
import 'privacy_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  int _highScore = 0;
  final List<String> _floatingEmojis = ['🔴', '⭐', '🍎', '🚗', '⚽', '😀', '🌹', '🔵'];

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final hs = await ScoreService.getHighScore();
    if (mounted) setState(() => _highScore = hs);
  }

  void _startGame() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const GameScreen(),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          // Floating background emojis
          ..._floatingEmojis.asMap().entries.map((e) {
            final i = e.key;
            final emoji = e.value;
            final positions = [
              const Offset(0.05, 0.08), const Offset(0.85, 0.12),
              const Offset(0.15, 0.75), const Offset(0.80, 0.70),
              const Offset(0.50, 0.05), const Offset(0.92, 0.45),
              const Offset(0.02, 0.45), const Offset(0.70, 0.90),
            ];
            final pos = positions[i % positions.length];
            return Positioned(
              left: MediaQuery.of(context).size.width * pos.dx,
              top: MediaQuery.of(context).size.height * pos.dy,
              child: Text(emoji, style: const TextStyle(fontSize: 32))
                  .animate(onPlay: (c) => c.repeat())
                  .fadeIn(duration: 800.ms, delay: (i * 120).ms)
                  .then()
                  .shimmer(duration: 3000.ms, delay: (i * 200).ms)
                  .moveY(
                    begin: 0,
                    end: -12,
                    duration: 2400.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .moveY(begin: -12, end: 0, duration: 2400.ms, curve: Curves.easeInOut),
            );
          }),

          // Background gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  AppTheme.accent.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Logo emoji cluster
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ['🔴', '🔴', '⭐', '🔴']
                        .asMap()
                        .entries
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                e.value,
                                style: TextStyle(
                                  fontSize: e.key == 2 ? 42 : 32,
                                ),
                              )
                                  .animate()
                                  .fadeIn(delay: (e.key * 100 + 200).ms, duration: 500.ms)
                                  .scale(
                                    begin: const Offset(0.5, 0.5),
                                    delay: (e.key * 100 + 200).ms,
                                    duration: 500.ms,
                                    curve: Curves.elasticOut,
                                  ),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'ShapeShiftX',
                    style: GoogleFonts.nunito(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [AppTheme.accentLight, AppTheme.accentBlue],
                        ).createShader(const Rect.fromLTWH(0, 0, 300, 50)),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideY(begin: 0.3, delay: 400.ms, duration: 600.ms, curve: Curves.easeOut),

                  const SizedBox(height: 8),

                  Text(
                    'Find the odd one out!',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 500.ms),

                  const SizedBox(height: 32),

                  // High score badge
                  if (_highScore > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.gold.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(
                            'Best: $_highScore pts',
                            style: GoogleFonts.nunito(
                              color: AppTheme.gold,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 500.ms)
                        .scale(begin: const Offset(0.8, 0.8), delay: 700.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 48),

                  // Play button
                  _MenuButton(
                    label: 'PLAY',
                    emoji: '🎮',
                    isPrimary: true,
                    delay: 800,
                    onTap: _startGame,
                  ),

                  const SizedBox(height: 14),

                  _MenuButton(
                    label: 'High Scores',
                    emoji: '🏆',
                    delay: 900,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HighscoreScreen()),
                    ),
                  ),

                  const SizedBox(height: 14),

                  _MenuButton(
                    label: 'About',
                    emoji: '💡',
                    delay: 1000,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    ),
                  ),

                  const SizedBox(height: 14),

                  _MenuButton(
                    label: 'Privacy Policy',
                    emoji: '🔒',
                    delay: 1100,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    'v1.0.0 · Corey Matthew Crandal',
                    style: GoogleFonts.nunito(
                      color: AppTheme.textSecondary.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ).animate().fadeIn(delay: 1200.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isPrimary;
  final int delay;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.emoji,
    required this.delay,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [AppTheme.accent, AppTheme.accentBlue],
                )
              : null,
          color: isPrimary ? null : AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary
                ? Colors.transparent
                : AppTheme.accentLight.withOpacity(0.2),
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppTheme.accent.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  )
                ]
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
                fontSize: isPrimary ? 20 : 17,
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
        .slideX(begin: -0.1, delay: delay.ms, duration: 400.ms, curve: Curves.easeOut);
  }
}
