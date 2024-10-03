
# Taficloud Dart SDK

The Taficloud Dart SDK provides functionalities for interacting with the Taficloud API. It allows you to upload, download, and manage media files.

## Features

- Upload a file (regular or Base64 encoded).
- Fetch media metadata.
- Convert media format.
- Merge multiple files.
- Compress an image.

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  taficloud_flutter: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Getting Started

To get started, you need to create an instance of the `Taficloud` class by passing your API key.

```dart
import 'package:taficloud_sdk/taficloud_sdk.dart';

final taficloud = Taficloud(apiKey: 'your-api-key');
```

## Usage

### 1. **Upload File**

```dart
import 'dart:io';
import 'package:taficloud_sdk/taficloud_sdk.dart';

Future<Media> uploadFile(File file) async {
  final response = await taficloud.upload(file: file, fileName: 'myfile.png', folder: 'uploads');
  print('Uploaded file URL: ${response.data.url}');
}
```

### 2. **Upload Base64 Encoded File**

```dart
import 'dart:convert';
import 'package:taficloud_sdk/taficloud_sdk.dart';

Future<Media> uploadBase64File(String base64String) async {
  final response = await taficloud.uploadBase64(file: base64String, fileName: 'myfile.png', folder: 'uploads');
  print('Uploaded file URL: ${response.data.url}');
}
```

### 3. **Fetch Media Metadata**

```dart
Future<MediaMetaData> fetchMediaMetadata(String mediaKey) async {
  final response = await taficloud.fetchMediaMetadata(mediaKey: mediaKey);
  print('Media Metadata: ${response.data}');
}
```

### 4. **Convert Media Format**

```dart
Future<MediaMetadata> convertMediaFormat(String mediaKey, String format) async {
  final response = await taficloud.convertMedia(mediaKey: mediaKey, format: format);
  print('Converted Media URL: ${response.data.url}');
}
```

### 5. **Merge Files**

```dart
import 'dart:io';

Future<Media> mergeFiles(List<File> files) async {
  final response = await taficloud.mergeFiles(files: files, fileName: 'merged_file.pdf');
  print('Merged file URL: ${response.data.url}');
}
```

### 6. **Upload Base64**

```dart
import 'dart:io';

Future<Uint8List> compressImage(File file) async{
  final compressedImage = await taficloud.compressImage(File("file.jpg"));
  print('Compressed Image URL: ${compressedImage.data.url}');
}
```

## License

[LICENSE](./LICENSE)
