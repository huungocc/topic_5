import 'package:flutter/material.dart';
import 'package:phase_5/animation/animated_container_screen.dart';
import 'package:phase_5/animation/physic_card_screen.dart';
import 'package:phase_5/main_common.dart';

class AnimationScreen extends StatelessWidget {
  const AnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation'),
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(createRoute(PhysicCardScreen()));
              },
              child: Text('Physic Card'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(createRoute(AnimatedContainerScreen()));
              },
              child: Text('Animated Container'),
            ),
          ]
        ),
      ),
    );
  }
}


