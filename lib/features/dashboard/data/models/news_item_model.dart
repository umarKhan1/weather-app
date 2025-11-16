import 'package:weatherapp/features/dashboard/domain/entities/news_item.dart';

class NewsItemModel extends NewsItem {
  const NewsItemModel({
    required super.id,
    required super.title,
    required super.source,
    required super.publishedAt,
    required super.imagePath,
  });

  factory NewsItemModel.fromJson(Map<String, dynamic> json) => NewsItemModel(
        id: json['id'] as String,
        title: json['title'] as String,
        source: json['source'] as String,
        publishedAt: DateTime.parse(json['publishedAt'] as String),
        imagePath: json['imagePath'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'source': source,
        'publishedAt': publishedAt.toIso8601String(),
        'imagePath': imagePath,
      };
}
