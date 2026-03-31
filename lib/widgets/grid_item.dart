import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';

enum TapState { idle, correct, wrong }

class GridItem extends StatelessWidget {
  final String emoji;
  final TapState tapState;
  final Duration delay;
  final VoidCallback onTap;

  const GridItem({
    super.key,
    required this.emoji,
    required this.tapState,
    required this.delay,
    required this.onTap,
  });

  Color get _borderColor {
    return switch (tapState) {
      TapState.correct => AppTheme.correct,
      TapState.wrong => AppTheme.wrong,
      TapState.idle => AppTheme.accentLight.withOpacity(0.15),
    };
  }

  Color get _bgColor {
    return switch (tapState) {
      TapState.correct => AppTheme.correct.withOpacity(0.18),
      TapState.wrong => AppTheme.wrong.withOpacity(0.18),
      TapState.idle => AppTheme.card,
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget item = GestureDetector(
      onTap: tapState == TapState.idle ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor, width: tapState != TapState.idle ? 2.5 : 1),
          boxShadow: tapState == TapState.correct
              ? [BoxShadow(color: AppTheme.correct.withOpacity(0.35), blurRadius: 14)]
              : tapState == TapState.wrong
              ? [BoxShadow(color: AppTheme.wrong.withOpacity(0.35), blurRadius: 14)]
              : null,
        ),
        child: Center(
          child: Text(emoji, style: const TextStyle(fontSize: 32)),
        ),
      ),
    );

    // Entrance animation
    item = item
        .animate()
        .fadeIn(delay: delay, duration: 300.ms)
        .scale(
      begin: const Offset(0.7, 0.7),
      delay: delay,
      duration: 350.ms,
      curve: Curves.elasticOut,
    );

    // Shake on wrong
    if (tapState == TapState.wrong) {
      item = item
          .animate()
          .shake(hz: 4, offset: const Offset(4, 0), duration: 400.ms);
    }

    // Bounce on correct
    if (tapState == TapState.correct) {
      item = item
          .animate()
          .scale(
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.15, 1.15),
        duration: 200.ms,
        curve: Curves.easeOut,
      )
          .then()
          .scale(
        end: const Offset(1.0, 1.0),
        duration: 200.ms,
        curve: Curves.easeIn,
      );
    }

    return item;
  }
}