import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  static const Color bg = Color(0xFF0D0D1A);
  static const Color surface = Color(0xFF16162A);
  static const Color card = Color(0xFF1E1E35);
  static const Color accent = Color(0xFF7C3AED);
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color correct = Color(0xFF22C55E);
  static const Color wrong = Color(0xFFEF4444);
  static const Color textPrimary = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color gold = Color(0xFFFBBF24);

  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.dark(
      primary: accent,
      secondary: accentBlue,
      surface: surface,
    ),
    textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
    useMaterial3: true,
  );
}

// ─── Music Service ────────────────────────────────────────────────────────────
class MusicService {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal();

  static const String _prefKey = 'music_enabled';
  final AudioPlayer _player = AudioPlayer();
  bool _isMusicOn = true;
  bool _isInitialized = false;

  bool get isMusicOn => _isMusicOn;

  /// Call once at app start (or before first use)
  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;
    final prefs = await SharedPreferences.getInstance();
    _isMusicOn = prefs.getBool(_prefKey) ?? true;
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0.5);
    if (_isMusicOn) await _play();
  }

  Future<void> _play() async {
    try {
      await _player.play(AssetSource('music.mp3'));
    } catch (_) {}
  }

  Future<void> toggle() async {
    _isMusicOn = !_isMusicOn;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, _isMusicOn);
    if (_isMusicOn) {
      await _play();
    } else {
      await _player.stop();
    }
  }

  Future<void> pause() async => await _player.pause();
  Future<void> resume() async {
    if (_isMusicOn) await _player.resume();
  }

  Future<void> stop() async => await _player.stop();
}

// ─── Emoji Sets ───────────────────────────────────────────────────────────────
class EmojiSet {
  final List<String> pool;
  final List<String> odds;
  const EmojiSet({required this.pool, required this.odds});
}

const List<EmojiSet> kEmojiSets = [
  EmojiSet(pool: ['🔴', '🟠', '🟡', '🟢', '🔵', '🟣'], odds: ['⬛', '⬜', '🟤']),
  EmojiSet(pool: ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊'], odds: ['🐊', '🦈', '🦅']),
  EmojiSet(pool: ['🍎', '🍊', '🍋', '🍇', '🍓', '🍑'], odds: ['🥦', '🥕', '🌽']),
  EmojiSet(pool: ['⭐', '🌟', '✨', '💫', '🌠'], odds: ['🌙', '☀️', '🌈']),
  EmojiSet(pool: ['🚗', '🚕', '🚙', '🚌', '🚎'], odds: ['✈️', '🚢', '🚂']),
  EmojiSet(pool: ['⚽', '🏀', '🏈', '⚾', '🎾', '🏐'], odds: ['🎮', '🎲', '🃏']),
  EmojiSet(pool: ['😀', '😁', '😂', '🤣', '😃', '😄'], odds: ['😡', '😭', '🤢']),
  EmojiSet(pool: ['🌹', '🌺', '🌸', '🌼', '🌻', '💐'], odds: ['🍄', '🌵', '🪨']),
  EmojiSet(pool: ['🎵', '🎶', '🎼', '🎹', '🎸', '🎺'], odds: ['📚', '🖊️', '📐']),
  EmojiSet(pool: ['🏠', '🏡', '🏢', '🏣', '🏤', '🏥'], odds: ['⛺', '🛖', '🏕️']),
];

const List<int> kGridSizes = [4, 6, 9, 12, 16, 20, 25];

class GameConfig {
  final int gridCount;
  final double timerSeconds;
  final int level;

  const GameConfig({
    required this.gridCount,
    required this.timerSeconds,
    required this.level,
  });

  static GameConfig forLevel(int level) {
    if (level <= 3) return GameConfig(gridCount: 4, timerSeconds: 20, level: level);
    if (level <= 6) return GameConfig(gridCount: 6, timerSeconds: 18, level: level);
    if (level <= 10) return GameConfig(gridCount: 9, timerSeconds: 15, level: level);
    if (level <= 15) return GameConfig(gridCount: 12, timerSeconds: 13, level: level);
    if (level <= 20) return GameConfig(gridCount: 16, timerSeconds: 11, level: level);
    return GameConfig(gridCount: 25, timerSeconds: 9, level: level);
  }
}