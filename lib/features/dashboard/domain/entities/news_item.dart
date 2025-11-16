import 'package:equatable/equatable.dart';

class NewsItem extends Equatable {
  final String id;
  final String title;
  final String source;
  final DateTime publishedAt;
  final String imagePath;

  const NewsItem({
    required this.id,
    required this.title,
    required this.source,
    required this.publishedAt,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [id, title, source, publishedAt, imagePath];
}
