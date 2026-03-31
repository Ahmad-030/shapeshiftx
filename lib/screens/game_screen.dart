import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../models/game_state.dart';
import '../widgets/grid_item.dart';
import '../widgets/timer_bar.dart';
import 'gameover_screen.dart';
import 'pause_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameState _state;
  Timer? _timer;
  double _timeLeft = 20;
  bool _isPaused = false;
  bool _transitioning = false;

  // For shake/flash animation keys
  final _gridKey = GlobalKey();
  int _roundKey = 0; // force grid rebuild each round

  static const int _maxLives = 3;

  @override
  void initState() {
    super.initState();
    _newRound(level: 1, score: 0, lives: _maxLives);
  }

  void _newRound({required int level, required int score, required int lives}) {
    _timer?.cancel();
    final newState = GameState.generate(level: level, score: score, lives: lives);
    setState(() {
      _state = newState;
      _timeLeft = newState.config.timerSeconds;
      _transitioning = false;
      _roundKey++;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (_isPaused || _state.hasAnswered) return;
      setState(() {
        _timeLeft -= 0.1;
        if (_timeLeft <= 0) {
          _timeLeft = 0;
          t.cancel();
          _onTimeUp();
        }
      });
    });
  }

  void _onTimeUp() {
    final newLives = _state.lives - 1;
    if (newLives <= 0) {
      _gameOver();
    } else {
      setState(() {
        _state = _state.copyWith(lives: newLives, tappedIndex: -1, isCorrect: false);
      });
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) _newRound(level: _state.level, score: _state.score, lives: newLives);
      });
    }
  }

  void _onTap(int index) {
    if (_state.hasAnswered || _transitioning) return;
    _timer?.cancel();
    final isCorrect = index == _state.oddIndex;
    final newScore = isCorrect ? _state.score + 10 + _state.level * 2 : _state.score;
    final newLives = isCorrect ? _state.lives : _state.lives - 1;

    setState(() {
      _state = _state.copyWith(
        tappedIndex: index,
        isCorrect: isCorrect,
        score: newScore,
        lives: newLives,
      );
      _transitioning = true;
    });

    if (newLives <= 0 && !isCorrect) {
      Future.delayed(const Duration(milliseconds: 1000), _gameOver);
    } else {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) {
          _newRound(
            level: isCorrect ? _state.level + 1 : _state.level,
            score: newScore,
            lives: newLives,
          );
        }
      });
    }
  }

  void _gameOver() {
    _timer?.cancel();
    ScoreService.saveIfHighScore(_state.score);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => GameOverScreen(
          score: _state.score,
          level: _state.level,
        ),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  void _pauseGame() {
    _timer?.cancel();
    setState(() => _isPaused = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PauseOverlay(
        onResume: () {
          Navigator.of(context).pop();
          setState(() => _isPaused = false);
          if (!_state.hasAnswered) _startTimer();
        },
        onQuit: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  int get _crossAxisCount {
    final n = _state.config.gridCount;
    if (n <= 4) return 2;
    if (n <= 9) return 3;
    if (n <= 16) return 4;
    return 5;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _timeLeft / _state.config.timerSeconds;
    final isLowTime = _timeLeft < 5;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  // Lives
                  Row(
                    children: List.generate(
                      _maxLives,
                      (i) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          i < _state.lives ? '❤️' : '🖤',
                          style: const TextStyle(fontSize: 22),
                        ).animate(key: ValueKey('life_${_state.lives}_$i')).scale(
                              begin: i < _state.lives
                                  ? const Offset(1.0, 1.0)
                                  : const Offset(1.3, 1.3),
                              end: const Offset(1.0, 1.0),
                              duration: 300.ms,
                              curve: Curves.easeOut,
                            ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Score
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.accentLight.withOpacity(0.2)),
                    ),
                    child: Text(
                      '${_state.score} pts',
                      style: GoogleFonts.nunito(
                        color: AppTheme.accentLight,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ).animate(key: ValueKey(_state.score)).scale(
                        begin: const Offset(1.15, 1.15),
                        end: const Offset(1.0, 1.0),
                        duration: 300.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(width: 10),

                  // Pause
                  GestureDetector(
                    onTap: _pauseGame,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.pause_rounded, color: AppTheme.textSecondary, size: 22),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, duration: 400.ms),

            // Level label
            Text(
              'LEVEL ${_state.level}',
              style: GoogleFonts.nunito(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 2.5,
              ),
            ).animate(key: ValueKey('level_${_state.level}')).fadeIn(duration: 300.ms),

            const SizedBox(height: 8),

            // Timer bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TimerBar(
                progress: progress,
                isLow: isLowTime,
              ),
            ),

            if (isLowTime)
              Text(
                '${_timeLeft.ceil()}s',
                style: GoogleFonts.nunito(
                  color: AppTheme.wrong,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .fadeIn(duration: 200.ms)
                  .then()
                  .fadeOut(duration: 200.ms),

            const SizedBox(height: 16),

            // Instruction
            Text(
              'Tap the odd one out!',
              style: GoogleFonts.nunito(
                color: AppTheme.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ).animate(key: ValueKey(_roundKey)).fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  key: ValueKey('grid_$_roundKey'),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _state.items.length,
                  itemBuilder: (ctx, i) {
                    TapState tapState = TapState.idle;
                    if (_state.hasAnswered) {
                      if (i == _state.oddIndex) {
                        tapState = TapState.correct;
                      } else if (i == _state.tappedIndex && !_state.isCorrect) {
                        tapState = TapState.wrong;
                      }
                    }

                    return GridItem(
                      emoji: _state.items[i],
                      tapState: tapState,
                      delay: (i * 40).ms,
                      onTap: () => _onTap(i),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
