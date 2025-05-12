import 'package:ulearna_reels/core/utils/typedefs.dart';
import 'package:ulearna_reels/domain/entities/reel.dart';

class ReelModel extends Reel {
  const ReelModel({
    required super.id,
    required super.title,
    required super.url,
    required super.cdnurl,
    required super.thumbcdnurl,
    required super.description,
    required super.videoUrl,
    required super.likes,
    required super.comments,
    required super.shares,
    required super.authorName,
    required super.authorImageUrl,
    required super.createdAt,
  });

  factory ReelModel.fromJson(DataMap json) {
    return ReelModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      cdnurl: json['cdn_url'] ?? '',
      thumbcdnurl: json['thumb_cdn_url'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['cdn_url'] ?? '',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      authorName: json['author']?['name'] ?? '',
      authorImageUrl: json['author']?['imageUrl'] ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
    );
  }

  DataMap toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'description': description,
      'videoUrl': videoUrl,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'author': {'name': authorName, 'imageUrl': authorImageUrl},
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ReelsResponse {
  final bool success;
  final String message;
  final int page;
  final int limit;
  final int total;
  final List<ReelModel> data;

  ReelsResponse({
    required this.success,
    required this.message,
    required this.page,
    required this.limit,
    required this.total,
    required this.data,
  });

  factory ReelsResponse.fromJson(DataMap json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? {};

    return ReelsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      page: dataJson['meta_data']?['page'] ?? 1,
      limit: dataJson['meta_data']?['limit'] ?? 10,
      total: dataJson['meta_data']?['total'] ?? 0,
      data:
          dataJson['data'] != null
              ? List<ReelModel>.from(
                (dataJson['data'] as List).map((x) => ReelModel.fromJson(x)),
              )
              : [],
    );
  }
}
