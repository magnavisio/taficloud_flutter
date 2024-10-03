import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:taficloud_flutter/src/models/media.dart';
import 'package:taficloud_flutter/src/taficloud.dart';

void main() {
  group("Taficloud", () {
    const apikey = "YOUR_API_KEY";
    const mediaKey =
        "magnavisio/Cloud upload-d69c355e85cf6cc17810a3bc11cedcba6.png";
    const base64Sample = "data:image/png;base64,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";

    test("uploadFile successfully", () async {
      final taficloud = Taficloud(apiKey: apikey);
      final media = await taficloud.uploadFile(
        File("test.png"),
        "test.npg",
        folder: "test",
      );
      expect(
        media,
        isA<Media>().having(
          (media) => media.url.isNotEmpty,
          "has valid url",
          equals(true),
        ),
      );
    });

    test("uploadFile failed when wrong apikey is passed", () async {
      final taficloud = Taficloud(apiKey: "8483848884");
      try {
        await taficloud.uploadFile(
          File("test.png"),
          "test.npg",
          folder: "test",
        );
      } catch (e) {
        expect(
          e,
          isA<TaficloudError>().having(
            (error) => error.code,
            "has code",
            equals(403),
          ),
        );
      }
    });

    test("getMediaMetadata successfully", () async {
      final taficloud = Taficloud(apiKey: apikey);
      final metadata = await taficloud.getMediaMetadata(mediaKey);
      expect(
        metadata,
        isA<MediaMetadata>().having(
          (metadata) => metadata.format,
          "has format",
          equals("jpeg"),
        ),
      );
    });

    test("getMediaMetadata failed when wrong key is passed", () async {
      final taficloud = Taficloud(apiKey: apikey);
      try {
        await taficloud.getMediaMetadata("wrong-key");
      } catch (e) {
        expect(
          e,
          isA<TaficloudError>().having(
            (error) => error.code,
            "has code",
            equals(400),
          ),
        );
      }
    });

    test("convert media successfully", () async {
      final taficloud = Taficloud(apiKey: apikey);
      final convertedMedia = await taficloud.convertMedia(mediaKey, "jpeg");
      expect(
        convertedMedia,
        isA<Media>().having(
          (media) => media.url.isNotEmpty,
          "has valid url",
          equals(true),
        ),
      );
    });

    test("convert media failed when wrong key is passed", () async {
      final taficloud = Taficloud(apiKey: apikey);
      try {
        await taficloud.convertMedia("wrong-key", "jpeg");
      } catch (e) {
        expect(
          e,
          isA<TaficloudError>().having(
            (error) => error.code,
            "has code",
            equals(400),
          ),
        );
      }
    });

    test("upload multiple files", () async {
      final taficloud = Taficloud(apiKey: apikey);
      final media = await taficloud.uploadFiles(
        [
          File("test.png"),
          File("test.png"),
        ],
        folder: "test",
      );
      expect(
        media,
        isA<List<Media>>().having(
          (media) => media.length,
          "has length",
          equals(2),
        ),
      );
    });

    test("upload base64 file", () async {
      final taficloud = Taficloud(apiKey: apikey);
      final media = await taficloud.uploadBase64(
        base64Sample,
        "image/png",
        folder: "test",
      );
      expect(
        media,
        isA<Media>().having(
          (media) => media.url.isNotEmpty,
          "has valid url",
          equals(true),
        ),
      );
    });

    test("compress image", () async {
      final taficloud = Taficloud(apiKey: apikey);
      final compressedImage = await taficloud.compressImage(File("test_2.jpg"));
      expect(
        compressedImage,
        isA<Uint8List>(),
      );
    });
  });
}
