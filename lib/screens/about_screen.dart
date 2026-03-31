import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          'About',
          style: GoogleFonts.nunito(color: AppTheme.textPrimary, fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),

            // Logo cluster
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['🔴', '🔴', '⭐', '🔴']
                  .asMap()
                  .entries
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        e.value,
                        style: TextStyle(fontSize: e.key == 2 ? 44 : 32),
                      )
                          .animate()
                          .fadeIn(delay: (e.key * 100).ms, duration: 400.ms)
                          .scale(
                            begin: const Offset(0.4, 0.4),
                            delay: (e.key * 100).ms,
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                          ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              'ShapeShiftX',
              style: GoogleFonts.nunito(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [AppTheme.accentLight, AppTheme.accentBlue],
                  ).createShader(const Rect.fromLTWH(0, 0, 260, 44)),
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.2, delay: 400.ms),

            const SizedBox(height: 6),

            Text(
              'Find the odd one out!',
              style: GoogleFonts.nunito(color: AppTheme.textSecondary, fontSize: 15),
            ).animate().fadeIn(delay: 500.ms),

            const SizedBox(height: 32),

            // About card
            _AboutCard(
              emoji: '🎮',
              title: 'What is ShapeShiftX?',
              body:
                  'ShapeShiftX is a fast-paced casual puzzle game where you must spot the odd one out in a grid of objects. Test your observation speed before the timer runs out!',
              delay: 600,
            ),

            const SizedBox(height: 14),

            _AboutCard(
              emoji: '⚡',
              title: 'How to Play',
              body:
                  'You\'ll see a grid of similar objects — one is different. Tap the odd one out as quickly as possible. Correct answers earn points and advance you to harder levels. Wrong taps or time-outs cost a life. You have 3 lives per game.',
              delay: 700,
            ),

            const SizedBox(height: 14),

            _AboutCard(
              emoji: '📈',
              title: 'Difficulty Scaling',
              body:
                  'Grids grow larger, timers get shorter, and differences become subtler as you level up. See how far you can go!',
              delay: 800,
            ),

            const SizedBox(height: 14),

            _AboutCard(
              emoji: '🏆',
              title: 'Scoring',
              body:
                  'Each correct answer earns 10 base points plus a level bonus. Your high score is saved locally on your device.',
              delay: 900,
            ),

            const SizedBox(height: 28),

            // Divider
            Container(height: 1, color: AppTheme.accentLight.withOpacity(0.1))
                .animate()
                .fadeIn(delay: 1000.ms),

            const SizedBox(height: 24),

            // Developer section
            Text(
              'Developer',
              style: GoogleFonts.nunito(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 1000.ms),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.accentLight.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  const Text('👨‍💻', style: TextStyle(fontSize: 40))
                      .animate()
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        delay: 1100.ms,
                        duration: 500.ms,
                        curve: Curves.elasticOut,
                      ),
                  const SizedBox(height: 10),
                  Text(
                    'Corey Matthew Crandal',
                    style: GoogleFonts.nunito(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'coreymatthewcrandal7@gmail.com',
                    style: GoogleFonts.nunito(
                      color: AppTheme.accentLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 1050.ms, duration: 500.ms)
                .slideY(begin: 0.2, delay: 1050.ms),

            const SizedBox(height: 24),


            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String body;
  final int delay;

  const _AboutCard({
    required this.emoji,
    required this.title,
    required this.body,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.accentLight.withOpacity(0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: GoogleFonts.nunito(
                    color: AppTheme.textSecondary,
                    fontSize: 13.5,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 400.ms)
        .slideX(begin: -0.08, delay: delay.ms, duration: 400.ms, curve: Curves.easeOut);
  }
}
