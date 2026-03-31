import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../models/game_state.dart';

class HighscoreScreen extends StatefulWidget {
  const HighscoreScreen({super.key});

  @override
  State<HighscoreScreen> createState() => _HighscoreScreenState();
}

class _HighscoreScreenState extends State<HighscoreScreen> {
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    ScoreService.getHighScore().then((v) => setState(() => _highScore = v));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'High Scores',
          style: GoogleFonts.nunito(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 80))
                  .animate()
                  .scale(begin: const Offset(0, 0), duration: 600.ms, curve: Curves.elasticOut)
                  .then()
                  .shimmer(duration: 2000.ms, color: AppTheme.gold),

              const SizedBox(height: 24),

              Text(
                'Your Best',
                style: GoogleFonts.nunito(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 8),

              Text(
                '$_highScore',
                style: GoogleFonts.nunito(
                  fontSize: 72,
                  fontWeight: FontWeight.w900,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [AppTheme.gold, Color(0xFFFDE68A)],
                    ).createShader(const Rect.fromLTWH(0, 0, 200, 80)),
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 500.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    delay: 500.ms,
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),

              Text(
                'points',
                style: GoogleFonts.nunito(
                  color: AppTheme.textSecondary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ).animate().fadeIn(delay: 700.ms),

              const SizedBox(height: 48),

              if (_highScore == 0)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'No score yet!\nPlay a game to set your record. 🎮',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      color: AppTheme.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                ).animate().fadeIn(delay: 800.ms)
              else
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('⭐', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          Text(
                            'Keep playing to beat your record!',
                            style: GoogleFonts.nunito(
                              color: AppTheme.gold,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, delay: 800.ms),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
