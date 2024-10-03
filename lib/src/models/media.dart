
class TaficloudError extends Error {
  final int code;
  final String message;

  TaficloudError({required this.code, required this.message});

  factory TaficloudError.fromJson(Map<String, dynamic> json) {
    return TaficloudError(
      code: json['statusCode'],
      message: json['message'],
    );
  }

  @override
  String toString() {
    return 'TaficloudError(code: $code, message: $message)';
  }
}

class Media {
  final int id;
  final String name;
  final String url;
  final int organizationId;
  final String key;
  final String? mimetype;
  final double? size;

  const Media({
    required this.id,
    required this.name,
    required this.url,
    required this.organizationId,
    required this.key,
    this.mimetype,
    this.size,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      organizationId: json['organizationId'],
      key: json['key'],
      mimetype: json['mimetype'],
      size: json['size']?.toDouble(),
    );
  }

  @override
  String toString() {
    return 'Media(id: $id, name: $name, url: $url, organizationId: $organizationId, key: $key, mimetype: $mimetype, size: $size)';
  }
}

class MediaMetadata {
  final String? format;
  final double? width;
  final double? height;
  final String? space;
  final double? channels;
  final String? depth;
  final double? density;
  final bool? isProgressive;
  final bool? hasProfile;
  final bool? hasAlpha;

  const MediaMetadata({
    this.format,
    this.width,
    this.height,
    this.space,
    this.channels,
    this.depth,
    this.density,
    this.isProgressive,
    this.hasProfile,
    this.hasAlpha,
  });

  factory MediaMetadata.fromJson(Map<String, dynamic> json) {
    return MediaMetadata(
      format: json['format'],
      width: json['width']?.toDouble(),
      height: json['height']?.toDouble(),
      space: json['space'],
      channels: json['channels']?.toDouble(),
      depth: json['depth'],
      density: json['density']?.toDouble(),
      isProgressive: json['is_progressive'],
      hasProfile: json['has_profile'],
      hasAlpha: json['has_alpha'],
    );
  }

  @override
  String toString() {
    return 'MediaMetadata{format: $format, width: $width, height: $height, space: $space, channels: $channels, depth: $depth, density: $density, isProgressive: $isProgressive, hasProfile: $hasProfile, hasAlpha: $hasAlpha}';
  }
}