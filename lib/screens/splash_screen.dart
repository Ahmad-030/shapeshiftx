import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
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
    await Future.delayed(const Duration(milliseconds: 2600));
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
          // Radial glow matching your menu screen style
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
                // Emoji cluster — same as your menu screen logo
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
                        fontSize: e.key == 2 ? 48 : 36,
                      ),
                    )
                        .animate()
                        .scale(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(1.0, 1.0),
                      delay: (e.key * 120).ms,
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    )
                        .fadeIn(delay: (e.key * 120).ms, duration: 400.ms),
                  ))
                      .toList(),
                ),

                const SizedBox(height: 24),

                // App title with gradient — matches your menu
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
                    .fadeIn(delay: 500.ms, duration: 600.ms)
                    .slideY(
                  begin: 0.3,
                  end: 0,
                  delay: 500.ms,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),

                const SizedBox(height: 10),

                Text(
                  'Find the odd one out!',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ).animate().fadeIn(delay: 800.ms, duration: 500.ms),

                const SizedBox(height: 60),

                // Subtle loading dots
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
                        .fadeIn(delay: (1000 + i * 150).ms, duration: 300.ms)
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