import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phase_5/camera/supabase_service.dart';
import 'package:video_player/video_player.dart';

class DisplayVideoScreen extends StatefulWidget {
  final String videoPath;

  const DisplayVideoScreen({super.key, required this.videoPath});

  @override
  DisplayVideoScreenState createState() => DisplayVideoScreenState();
}

class DisplayVideoScreenState extends State<DisplayVideoScreen> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(File(widget.videoPath));
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.setLooping(true);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _uploadVideo() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final url = await SupabaseService.uploadFile(widget.videoPath, 'video');

      if (url != null) {
        _showSuccessSnackBar('Video đã được upload thành công');
      } else {
        _showErrorSnackBar('Upload video thất bại');
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi upload: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video đã quay'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
                Positioned(
                  left: 30,
                  right: 30,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        heroTag: "play",
                        onPressed: () {
                          if (_videoController.value.isPlaying) {
                            _videoController.pause();
                            setState(() {});
                          } else {
                            _videoController.play();
                            setState(() {});
                          }
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        child: Icon(
                          _videoController.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                      FloatingActionButton(
                        heroTag: "upload_video",
                        onPressed: () {
                          _uploadVideo();
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        child: const Icon(Icons.upload),
                      )
                    ],
                  ),
                ),
                if (_isUploading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}