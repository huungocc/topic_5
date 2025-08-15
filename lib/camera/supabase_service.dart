import 'dart:io';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class SupabaseService {
  static const String _supabaseUrl = 'https://prqlrbkvrrqinwjnjqqu.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBycWxyYmt2cnJxaW53am5qcXF1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI0ODY5NzYsImV4cCI6MjA2ODA2Mjk3Nn0.2YkPuaci2h6QbCPAiQ19VURQKYAdf9IS289_9E88C-Y';
  static const String _bucketName = 'phase_5';

  static SupabaseClient? _client;

  static SupabaseClient get client {
    _client ??= SupabaseClient(_supabaseUrl, _supabaseAnonKey);
    return _client!;
  }

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  // Upload file to Supabase Storage
  static Future<String?> uploadFile(String filePath, String fileType) async {
    try {
      final file = File(filePath);
      final fileName = '${const Uuid().v4()}${path.extension(filePath)}';
      final folder = fileType == 'image' ? 'images' : 'videos';
      final fullPath = '$folder/$fileName';

      final bytes = await file.readAsBytes();

      final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';

      await client.storage.from(_bucketName).uploadBinary(
        fullPath,
        bytes,
        fileOptions: FileOptions(
          contentType: mimeType,
          upsert: false,
        ),
      );

      final publicUrl = client.storage
          .from(_bucketName)
          .getPublicUrl(fullPath);

      // Lưu metadata vào database
      await _saveFileMetadata(fileName, fullPath, publicUrl, fileType);

      return publicUrl;
    } catch (e) {
      print('Lỗi upload file: $e');
      return null;
    }
  }

  // Lưu metadata của file vào database
  static Future<void> _saveFileMetadata(
      String fileName,
      String filePath,
      String publicUrl,
      String fileType
      ) async {
    try {
      await client.from('media_files').insert({
        'file_name': fileName,
        'file_path': filePath,
        'public_url': publicUrl,
        'file_type': fileType,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Lỗi lưu metadata: $e');
    }
  }
}