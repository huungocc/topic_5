import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:phase_5/flavors/flavor_config.dart';
import 'package:phase_5/main_common.dart';
import 'package:phase_5/camera/take_picture_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            Text(FlavorConfig.instance.name, style: TextStyle(fontSize: 30),),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/fcmScreen');
              },
              child: const Text('FCM'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/animationScreen');
              },
              child: const Text('Animation'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/designScreen');
              },
              child: const Text('Design'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/effectScreen');
              },
              child: const Text('Effect'),
            ),
            ElevatedButton(
              onPressed: () async {
                final cameras = await availableCameras();
                if (cameras.isEmpty) {
                  // Chạy code thay thế
                  print('No cameras available');
                  return;
                }

                if (!context.mounted) return;

                Navigator.of(context).push(
                  createRoute(TakePictureScreen(cameras: cameras)),
                );
              },
              child: const Text('Camera'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/videoPlayerScreen');
              },
              child: const Text('Video'),
            ),
          ],
        ),
      ),
    );
  }
}
