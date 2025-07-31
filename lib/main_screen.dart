import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:phase_5/flavors/flavor_config.dart';
import 'package:phase_5/main_common.dart';
import 'package:phase_5/camera/take_picture_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Text(FlavorConfig.instance.name, style: TextStyle(fontSize: 30),),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/fcmScreen');
            },
            child: Text('FCM'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/animationScreen');
            },
            child: Text('Animation'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/designScreen');
            },
            child: Text('Design'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/effectScreen');
            },
            child: Text('Effect'),
          ),
          ElevatedButton(
            onPressed: () async {
              final cameras = await availableCameras();
              final firstCamera = cameras.first;

              Navigator.of(context).push(createRoute(TakePictureScreen(camera: firstCamera)));
            },
            child: Text('Camera'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/videoPlayerScreen');
            },
            child: Text('Video'),
          ),
        ],
      ),
    );
  }
}
