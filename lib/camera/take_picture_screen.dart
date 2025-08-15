import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phase_5/camera/display_picture_screen.dart';
import 'package:phase_5/camera/display_video_screen.dart';

enum CameraMode { photo, video }

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  CameraMode _currentMode = CameraMode.photo;
  bool _isRecording = false;
  final ImagePicker _picker = ImagePicker();
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.cameras[_selectedCameraIndex],
      ResolutionPreset.ultraHigh,
    );

    _initializeControllerFuture = _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      await _controller.pausePreview();

      if (mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(imagePath: image.path),
          ),
        );
      }

      _initializeCamera();

    } catch (e) {
      print('Lỗi khi chụp ảnh: $e');
    }
  }


  Future<void> _startVideoRecording() async {
    if (_isRecording) return;

    try {
      await _initializeControllerFuture;
      await _controller.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Lỗi khi bắt đầu quay video: $e');
    }
  }

  Future<void> _stopVideoRecording() async {
    if (!_isRecording) return;

    try {
      setState(() {
        _isRecording = false;
      });

      final XFile rawVideo = await _controller.stopVideoRecording();

      // Đặt lại tên file (chuyển từ .temp sang .mp4)
      final String newPath = '${(await getTemporaryDirectory()).path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Copy sang file mới có đuôi .mp4
      final File newVideo = await File(rawVideo.path).copy(newPath);

      await _controller.pausePreview();

      if (mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayVideoScreen(videoPath: newVideo.path),
          ),
        );
      }

      _initializeCamera();

    } catch (e) {
      print('Lỗi khi dừng quay video: $e');
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _switchCamera() async {
    if (_isRecording) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;

    await _controller.dispose();
    await _initializeCamera();
    if (mounted) setState(() {});
  }


  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (pickedFile != null && mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                DisplayPictureScreen(imagePath: pickedFile.path),
          ),
        );
      }
    } catch (e) {
      print('Lỗi khi chọn ảnh: $e');
    }
  }

  Future<void> _pickVideoFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedFile != null && mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                DisplayVideoScreen(videoPath: pickedFile.path),
          ),
        );
      }
    } catch (e) {
      print('Lỗi khi chọn video: $e');
    }
  }

  void _onPickFile() {
    if (_isRecording) return;

    switch (_currentMode) {
      case CameraMode.photo:
        _pickImageFromGallery();
        break;
      case CameraMode.video:
        _pickVideoFromGallery();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                /// Camera preview
                Positioned.fill(child: CameraPreview(_controller)),

                /// Mode switch buttons
                Positioned(
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildModeButton(
                          'Ảnh',
                          CameraMode.photo,
                          Icons.camera_alt,
                        ),
                        const SizedBox(width: 20),
                        _buildModeButton(
                          'Video',
                          CameraMode.video,
                          Icons.videocam,
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// Pick file button
                      FloatingActionButton(
                        heroTag: "gallery",
                        onPressed: _onPickFile,
                        backgroundColor: _isRecording
                            ? Colors.grey
                            : Colors.white.withValues(alpha: 0.9),
                        foregroundColor: Colors.black,
                        mini: true,
                        child: const Icon(Icons.photo_library),
                      ),

                      /// Capture button
                      _buildCaptureButton(),

                      /// Change camera button
                      FloatingActionButton(
                        heroTag: "switch_camera",
                        onPressed: _switchCamera,
                        backgroundColor: _isRecording
                            ? Colors.grey
                            : Colors.white.withValues(alpha: 0.9),
                        foregroundColor: Colors.black,
                        mini: true,
                        child: const Icon(Icons.change_circle_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildModeButton(String text, CameraMode mode, IconData icon) {
    final bool isSelected = _currentMode == mode;
    return GestureDetector(
      onTap: _isRecording
          ? null
          : () {
              setState(() {
                _currentMode = mode;
              });
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.black54,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    if (_currentMode == CameraMode.photo) {
      return GestureDetector(
        onTap: _capturePhoto,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Icon(Icons.camera_alt, size: 30),
        ),
      );
    } else {
      return GestureDetector(
        onTap: _isRecording ? _stopVideoRecording : _startVideoRecording,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isRecording ? Colors.red : Colors.white,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Icon(
            _isRecording ? Icons.stop : Icons.videocam,
            color: _isRecording ? Colors.white : Colors.black,
            size: 35,
          ),
        ),
      );
    }
  }
}
