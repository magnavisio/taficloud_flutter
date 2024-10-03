import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:taficloud_flutter/src/models/media.dart';
import 'package:http_parser/http_parser.dart';

class Taficloud {
  final String apiKey;

  static const _baseurl = 'https://stash.taficloud.com/media';

  Taficloud({required this.apiKey});

  Future<Media> uploadFile(File file, String fileName, {String? folder}) async {
    final response = await _makeRequest(
      'POST',
      'upload',
      files: [
        MultipartFile('file', file.openRead(), file.lengthSync(),
            filename: fileName,
          contentType: MediaType.parse(
              lookupMimeType(file.path) ?? 'application/octet-stream'),
        )
      ],
      formFields: folder != null ? {'folder': folder} : null,
    );
    return Media.fromJson(response["data"]);
  }

  Future<MediaMetadata> getMediaMetadata(String key) async {
    final response = await _makeRequest('GET', 'metadata/?mediaKey=$key');
    return MediaMetadata.fromJson(response["data"]);
  }

  Future<Media> convertMedia(String key, String format) async {
    final response = await _makeRequest(
      'POST',
      'convert',
      formFields: {'mediaKey': key, 'format': format},
    );
    return Media.fromJson(response["data"]);
  }

  Future<List<Media>> uploadFiles(List<File> files, {String? folder}) async {
    final response = await _makeRequest(
      'POST',
      'upload/multiple',
      files: files
          .asMap()
          .entries
          .map(
            (e) => MultipartFile(
              'files',
              e.value.openRead(),
              e.value.lengthSync(),
              filename: "file-${e.key}",
              contentType: MediaType.parse(
                  lookupMimeType(e.value.path) ?? 'application/octet-stream'),
            ),
          )
          .toList(),
      formFields: folder != null ? {'folder': folder} : null,
    );
    return (response["data"]["media"] as List)
        .map((e) => Media.fromJson(e))
        .toList();
  }

  Future<Media> uploadBase64(String base64String, String mimetype,
      {String? folder}) async {
    final response = await _makeRequest(
      'POST',
      'upload/base64',
      formFields: {
        'file': base64String,
        'mimetype': mimetype,
        if (folder != null) 'folder': folder,
      },
    );
    return Media.fromJson(response["data"]);
  }

  Future<Media> mergePdfs(List<File> pdfs, {String? folder}) async {
    final response = await _makeRequest(
      'POST',
      'merge',
      files: pdfs
          .asMap()
          .entries
          .map((e) => MultipartFile(
                'files',
                e.value.openRead(),
                e.value.lengthSync(),
                filename: "file-${e.key}",
                contentType: MediaType.parse(
                    lookupMimeType(e.value.path) ?? 'application/octet-stream'),
              ))
          .toList(),
      formFields: folder != null ? {'folder': folder} : null,
    );
    return Media.fromJson(response["data"]);
  }

  Future<Uint8List> compressImage(File file) async {
    final uri = Uri.parse('$_baseurl/compress-img-file');
    var request = MultipartRequest('POST', uri);

    request.files.add(MultipartFile(
      'file',
      file.openRead(),
      file.lengthSync(),
      filename: file.path,
      contentType: MediaType.parse(
          lookupMimeType(file.path) ?? 'application/octet-stream'),
    ));
    request.headers['Authorization'] = 'Bearer $apiKey';

    var response = await request.send();

    if ([200, 201].contains(response.statusCode)) {
      return await response.stream.toBytes();
    } else {
      final error = jsonDecode((await Response.fromStream(response)).body);
      throw TaficloudError(
          code: response.statusCode,
          message: error?['message'] ?? 'Unknown error');
    }
  }

  Future<Map<String, dynamic>> _makeRequest(
    String method,
    String path, {
    Map<String, String>? formFields,
    List<MultipartFile> files = const [],
  }) async {
    try {
      final uri = Uri.parse('$_baseurl/$path');
      final request = MultipartRequest(method, uri);
      request.headers['Authorization'] = 'Bearer $apiKey';

      if (formFields != null) {
        request.fields.addAll(formFields);
      }
      request.files.addAll(files);

      final streamedResponse = await request.send();
      final response = await Response.fromStream(streamedResponse);

      if ([200, 201].contains(response.statusCode)) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw TaficloudError(
            code: response.statusCode,
            message: error?['message'] ?? 'Unknown error');
      }
    } catch (e) {
      rethrow;
    }
  }
}
