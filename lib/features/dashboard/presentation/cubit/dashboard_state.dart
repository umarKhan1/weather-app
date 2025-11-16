import 'package:equatable/equatable.dart';
import 'package:weatherapp/features/dashboard/domain/entities/news_item.dart';
import 'package:weatherapp/features/dashboard/domain/entities/weather_overview.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final WeatherOverview? overview;
  final List<NewsItem> news;
  final String? error;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.overview,
    this.news = const [],
    this.error,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    WeatherOverview? overview,
    List<NewsItem>? news,
    String? error,
  }) {
    return DashboardState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      news: news ?? this.news,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, overview, news, error];
}
