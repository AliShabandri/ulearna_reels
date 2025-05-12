import 'package:equatable/equatable.dart';

class Reel extends Equatable {
  final int id;
  final String title;
  final String url;
  final String cdnurl;
   final String thumbcdnurl;
  final String description;
  final String videoUrl;
  final int likes;
  final int comments;
  final int shares;
  final String authorName;
  final String authorImageUrl;
  final DateTime createdAt;

  const Reel({
    required this.id,
    required this.title,
    required this.url,
    required this.cdnurl,
     required this.thumbcdnurl,
    required this.description,
    required this.videoUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.authorName,
    required this.authorImageUrl,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
    id,
    title,
    url,
    description,
   cdnurl,
   thumbcdnurl,
    videoUrl,
    likes,
    comments,
    shares,
    authorName,
    authorImageUrl,
    createdAt,
  ];
}
