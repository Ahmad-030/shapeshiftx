import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../utils/constants.dart';
import 'MenuScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMenu();
  }

  Future<void> _navigateToMenu() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => const MenuScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          // Radial glow
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  AppTheme.accent.withOpacity(0.10),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Lottie animation ──────────────────────────────────────
                SizedBox(
                  width: 240,
                  height: 240,
                  child: Lottie.asset(
                    'assets/shapes.json',
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ).animate().fadeIn(duration: 600.ms).scale(
                  begin: const Offset(0.6, 0.6),
                  duration: 700.ms,
                  curve: Curves.elasticOut,
                ),

                const SizedBox(height: 16),

                // App title with gradient
                Text(
                  'ShapeShiftX',
                  style: GoogleFonts.nunito(
                    fontSize: 46,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [AppTheme.accentLight, AppTheme.accentBlue],
                      ).createShader(const Rect.fromLTWH(0, 0, 320, 60)),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(
                  begin: 0.3,
                  end: 0,
                  delay: 400.ms,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),

                const SizedBox(height: 8),

                Text(
                  'Find the odd one out!',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ).animate().fadeIn(delay: 700.ms, duration: 500.ms),

                const SizedBox(height: 56),

                // Loading dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.accentLight.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .fadeIn(delay: (900 + i * 150).ms, duration: 300.ms)
                        .then()
                        .fadeOut(duration: 500.ms)
                        .then()
                        .fadeIn(duration: 500.ms);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}