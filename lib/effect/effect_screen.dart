import 'package:flutter/material.dart';
import 'package:phase_5/effect/download_button_screen.dart';
import 'package:phase_5/effect/parallax_scrolling_screen.dart';
import 'package:phase_5/effect/shimmer_loading_screen.dart';
import 'package:phase_5/effect/staggered_menu_screen.dart';
import 'package:phase_5/main_common.dart';

class EffectScreen extends StatelessWidget {
  const EffectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 5,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(createRoute(DownloadButtonScreen()));
                },
                child: Text('Download Button'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(createRoute(ParallaxScrollingScreen()));
                },
                child: Text('Parallax Scrolling'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(createRoute(ShimmerLoadingScreen()));
                },
                child: Text('Shimmer Loading'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(createRoute(StaggeredMenuScreen()));
                },
                child: Text('Staggered Menu'),
              ),
            ]
        ),
      ),
    );
  }
}
