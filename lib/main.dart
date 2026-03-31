import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shapeshiftx/screens/splash_screen.dart';
import 'utils/constants.dart';
import 'screens/MenuScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const ShapeShiftXApp());
}

class ShapeShiftXApp extends StatelessWidget {
  const ShapeShiftXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShapeShiftX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}