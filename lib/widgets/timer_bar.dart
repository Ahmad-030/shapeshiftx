import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TimerBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final bool isLow;

  const TimerBar({super.key, required this.progress, this.isLow = false});

  @override
  Widget build(BuildContext context) {
    final color = isLow
        ? AppTheme.wrong
        : progress > 0.5
            ? AppTheme.correct
            : AppTheme.gold;

    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AnimatedFractionallySizedBox(
          duration: const Duration(milliseconds: 100),
          alignment: Alignment.centerLeft,
          widthFactor: progress.clamp(0.0, 1.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isLow
                    ? [AppTheme.wrong, Colors.orange]
                    : [color, color.withOpacity(0.7)],
              ),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.5), blurRadius: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
