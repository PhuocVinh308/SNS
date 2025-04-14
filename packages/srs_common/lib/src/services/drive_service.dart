import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib_1.dart' as drive;
import 'package:srs_common/srs_common_lib_2.dart' as auth;
import 'package:srs_common/srs_common_lib_3.dart' as http;

class DriveService {
  static const _scopes = [drive.DriveApi.driveFileScope];
  late drive.DriveApi _driveApi;

  Future<void> initialize() async {
    // Load service account credentials from assets
    final credentials = await _getServiceAccountCredentials();
    final client = await auth.clientViaServiceAccount(credentials, _scopes);
    _driveApi = drive.DriveApi(client);
  }

  Future<auth.ServiceAccountCredentials> _getServiceAccountCredentials() async {
    // final jsonString = await rootBundle.loadString('assets/resource/service_account.json');
    final model = CustomGlobals().driveServiceModel;
    final data = model.toJson();
    String formattedKey = _decodeKey(data['key']);
    return auth.ServiceAccountCredentials.fromJson(formattedKey);
  }

  Future<String> uploadFile(File file, {String? folderId}) async {
    final stream = http.ByteStream(file.openRead());
    final length = await file.length();

    final driveFile = drive.File();
    driveFile.name = file.path.split('/').last;

    // Set parent folder if provided
    if (folderId != null) {
      driveFile.parents = [folderId];
    }

    final response = await _driveApi.files.create(
      driveFile,
      uploadMedia: drive.Media(stream, length),
    );

    // Make the file publicly readable
    await _driveApi.permissions.create(
      drive.Permission()
        ..role = 'reader'
        ..type = 'anyone',
      response.id!,
    );

    return response.id!;
  }

  Future<String> uploadFileUint8List(
    Uint8List fileBytes,
    String fileName, {
    String? folderId,
  }) async {
    final driveFile = drive.File()
      ..name = fileName
      ..parents = folderId != null ? [folderId] : null;

    final media = drive.Media(
      http.ByteStream.fromBytes(fileBytes),
      fileBytes.length,
    );

    final response = await _driveApi.files.create(
      driveFile,
      uploadMedia: media,
    );

    // Cấp quyền truy cập công khai (nếu cần)
    await _driveApi.permissions.create(
      drive.Permission()
        ..role = 'reader'
        ..type = 'anyone',
      response.id!,
    );

    return response.id!;
  }

  Future<String> getFileUrl(String fileId) async {
    return 'https://drive.google.com/uc?export=view&id=$fileId';
  }

  String _encodeKey(String key) {
    return base64Encode(utf8.encode(key));
  }

  String _decodeKey(String key) {
    return utf8.decode(base64Decode(key));
  }
}
