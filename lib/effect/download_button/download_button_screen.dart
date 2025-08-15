import 'package:flutter/material.dart';
import 'package:phase_5/effect/download_button/download_button.dart';

import 'package:phase_5/effect/download_button/download_controller.dart';

class DownloadButtonScreen extends StatefulWidget {
  const DownloadButtonScreen({super.key});

  @override
  State<DownloadButtonScreen> createState() => _DownloadButtonScreenState();
}

class _DownloadButtonScreenState extends State<DownloadButtonScreen> {
  final List<AppItem> _apps = [
    AppItem(name: 'Spotify', description: 'Music streaming app'),
    AppItem(name: 'Instagram', description: 'Social media platform'),
    AppItem(name: 'WhatsApp', description: 'Messaging app'),
    AppItem(name: 'YouTube', description: 'Video sharing platform'),
    AppItem(name: 'Telegram', description: 'Cloud messaging app'),
  ];

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex -= 1;
      final item = _apps.removeAt(oldIndex);
      _apps.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Store Demo')),
      body: ReorderableListView.builder(
        itemCount: _apps.length,
        onReorder: _onReorder,
        itemBuilder: (context, index) {
          final app = _apps[index];
          return ListTile(
            key: ValueKey(app.name),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.purple.shade400],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.apps, color: Colors.white, size: 24),
            ),
            title: Text(
              app.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(app.description),
            trailing: SizedBox(
              width: 80,
              child: DownloadButton(
                controller: app.controller,
                onPressed: () => _handleButtonPress(app),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleButtonPress(AppItem app) {
    switch (app.controller.status) {
      case DownloadStatus.notDownloaded:
        app.controller.startDownload();
        break;
      case DownloadStatus.downloading:
        app.controller.stopDownload();
        break;
      case DownloadStatus.downloaded:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Opening ${app.name}')));
        break;
    }
  }
}
