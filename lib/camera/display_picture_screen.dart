import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phase_5/camera/supabase_service.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool _isUploading = false;

  Future<void> _uploadImage() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final url = await SupabaseService.uploadFile(widget.imagePath, 'image');

      if (url != null) {
        _showSuccessSnackBar('Ảnh đã được upload thành công');
      } else {
        _showErrorSnackBar('Upload ảnh thất bại');
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
        title: const Text('Ảnh đã chụp'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Image.file(
            File(widget.imagePath),
            fit: BoxFit.contain,
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
        ]
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "upload_image",
        onPressed: () {
          _uploadImage();
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.upload),
      ),
    );
  }
}