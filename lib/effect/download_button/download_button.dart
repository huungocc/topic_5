import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phase_5/effect/download_button/download_controller.dart';

class DownloadButton extends StatelessWidget {
  final DownloadController controller;
  final VoidCallback onPressed;

  const DownloadButton({
    super.key,
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 32,
            decoration: _getDecoration(),
            child: _buildContent(),
          ),
        );
      },
    );
  }

  ShapeDecoration _getDecoration() {
    if (controller.status == DownloadStatus.downloading) {
      return const ShapeDecoration(
        shape: CircleBorder(),
        color: Colors.transparent,
      );
    }
    return ShapeDecoration(
      shape: const StadiumBorder(),
      color: Colors.grey.shade200,
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        /// Text content (GET/OPEN) with fade animation
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: controller.status == DownloadStatus.downloading
                ? 0.0
                : 1.0,
            curve: Curves.ease,
            child: Center(
              child: Text(
                controller.status == DownloadStatus.downloaded ? 'OPEN' : 'GET',
                style: const TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        /// Progress indicator with fade animation
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: controller.status == DownloadStatus.downloading
                ? 1.0
                : 0.0,
            curve: Curves.ease,
            child: Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: controller.progress),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, progress, child) {
                        return CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 2,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            CupertinoColors.activeBlue,
                          ),
                        );
                      },
                    ),
                    const Icon(
                      Icons.stop,
                      size: 14,
                      color: CupertinoColors.activeBlue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}