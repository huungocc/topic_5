import 'package:flutter/cupertino.dart';

class AppItem {
  final String name;
  final String description;
  final DownloadController controller = DownloadController();

  AppItem({required this.name, required this.description});
}

enum DownloadStatus { notDownloaded, downloading, downloaded }

class DownloadController with ChangeNotifier {
  DownloadStatus _status = DownloadStatus.notDownloaded;
  double _progress = 0.0;
  bool _isDownloading = false;

  DownloadStatus get status => _status;
  double get progress => _progress;

  Future<void> startDownload() async {
    if (_status != DownloadStatus.notDownloaded) return;

    _isDownloading = true;
    _status = DownloadStatus.downloading;
    notifyListeners();

    // Simulate download progress
    final progressSteps = [0.15, 0.45, 0.8, 1.0];
    for (final step in progressSteps) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!_isDownloading) return;

      _progress = step;
      notifyListeners();
    }

    _status = DownloadStatus.downloaded;
    _isDownloading = false;
    notifyListeners();
  }

  void stopDownload() {
    _isDownloading = false;
    _status = DownloadStatus.notDownloaded;
    _progress = 0.0;
    notifyListeners();
  }
}