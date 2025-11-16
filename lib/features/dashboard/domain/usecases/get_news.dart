import 'package:weatherapp/features/dashboard/domain/entities/news_item.dart';
import 'package:weatherapp/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetNews {
  final DashboardRepository repository;
  const GetNews(this.repository);

  Future<List<NewsItem>> call() => repository.fetchNews();
}
