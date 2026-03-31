import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class GameState {
  final List<String> items;
  final int oddIndex;
  final GameConfig config;
  final int score;
  final int lives;
  final int level;
  final int? tappedIndex;   // null = not tapped yet
  final bool isCorrect;

  const GameState({
    required this.items,
    required this.oddIndex,
    required this.config,
    required this.score,
    required this.lives,
    required this.level,
    this.tappedIndex,
    this.isCorrect = false,
  });

  bool get hasAnswered => tappedIndex != null;

  static GameState generate({required int level, required int score, required int lives}) {
    final rng = Random();
    final config = GameConfig.forLevel(level);
    final setIndex = rng.nextInt(kEmojiSets.length);
    final emojiSet = kEmojiSets[setIndex];

    final commonEmoji = emojiSet.pool[rng.nextInt(emojiSet.pool.length)];
    final oddEmoji = () {
      String odd;
      do {
        odd = emojiSet.odds[rng.nextInt(emojiSet.odds.length)];
      } while (odd == commonEmoji);
      return odd;
    }();

    final items = List<String>.filled(config.gridCount, commonEmoji);
    final oddIndex = rng.nextInt(config.gridCount);
    items[oddIndex] = oddEmoji;

    return GameState(
      items: items,
      oddIndex: oddIndex,
      config: config,
      score: score,
      lives: lives,
      level: level,
    );
  }

  GameState copyWith({
    int? tappedIndex,
    bool? isCorrect,
    int? score,
    int? lives,
  }) {
    return GameState(
      items: items,
      oddIndex: oddIndex,
      config: config,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      level: level,
      tappedIndex: tappedIndex ?? this.tappedIndex,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}

class ScoreService {
  static const _key = 'highscore';

  static Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  static Future<void> saveIfHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_key) ?? 0;
    if (score > current) await prefs.setInt(_key, score);
  }
}
