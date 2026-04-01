import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../utils/constants.dart';
import '../models/game_state.dart';
import 'game_screen.dart';
import 'highscore_screen.dart';
import 'about_screen.dart';
import 'privacy_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  int _highScore = 0;
  bool _isMusicOn = true;
  final List<String> _floatingEmojis = ['🔴', '⭐', '🍎', '🚗', '⚽', '😀', '🌹', '🔵'];

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _syncMusicState();
  }

  Future<void> _loadHighScore() async {
    final hs = await ScoreService.getHighScore();
    if (mounted) setState(() => _highScore = hs);
  }

  void _syncMusicState() {
    setState(() => _isMusicOn = MusicService().isMusicOn);
  }

  Future<void> _toggleMusic() async {
    await MusicService().toggle();
    if (mounted) setState(() => _isMusicOn = MusicService().isMusicOn);
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

          // ── Music toggle button (top-right) ──────────────────────────────
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 16),
                child: GestureDetector(
                  onTap: _toggleMusic,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isMusicOn
                            ? AppTheme.accentLight.withOpacity(0.4)
                            : AppTheme.textSecondary.withOpacity(0.2),
                      ),
                      boxShadow: _isMusicOn
                          ? [BoxShadow(color: AppTheme.accent.withOpacity(0.3), blurRadius: 10)]
                          : null,
                    ),
                    child: Icon(
                      _isMusicOn ? Icons.music_note_rounded : Icons.music_off_rounded,
                      color: _isMusicOn ? AppTheme.accentLight : AppTheme.textSecondary,
                      size: 22,
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms).scale(
                  begin: const Offset(0.7, 0.7),
                  delay: 300.ms,
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                ),
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

                  // ── Lottie animation ────────────────────────────────────
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      'assets/shapes.json',
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 600.ms)
                      .scale(
                    begin: const Offset(0.5, 0.5),
                    delay: 100.ms,
                    duration: 700.ms,
                    curve: Curves.elasticOut,
                  ),

                  const SizedBox(height: 8),

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
                  ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

                  const SizedBox(height: 24),

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

                  const SizedBox(height: 36),

                  // Buttons
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