import 'package:flutter/material.dart';
import 'package:phase_5/animation/animation_screen.dart';
import 'package:phase_5/design/design_screen.dart';
import 'package:phase_5/effect/effect_screen.dart';
import 'package:phase_5/fcm/fcm_screen.dart';
import 'package:phase_5/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phase_5/video/video_player_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FCM Demo',
      initialRoute: '/mainScreen',
      routes: {
        '/mainScreen': (context) => MainScreen(),
        '/fcmScreen': (context) => FcmScreen(),
        '/animationScreen': (context) => AnimationScreen(),
        '/designScreen': (context) => DesignScreen(),
        '/videoPlayerScreen': (context) => VideoPlayerScreen(),
        '/effectScreen': (context) => EffectScreen(),
      },
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: Colors.white,
      //     // ···
      //     brightness: Brightness.light,
      //   ),
      //   textTheme: TextTheme(
      //     displayLarge: const TextStyle(
      //       fontSize: 30,
      //       fontWeight: FontWeight.bold,
      //     ),
      //     // ···
      //     titleLarge: GoogleFonts.oswald(
      //       fontSize: 30,
      //       fontStyle: FontStyle.italic,
      //     ),
      //     bodyMedium: GoogleFonts.merriweather(),
      //     displaySmall: GoogleFonts.pacifico(),
      //   ),
      // ),
    );
  }
}