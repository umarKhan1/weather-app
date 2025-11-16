import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/features/dashboard/domain/usecases/get_news.dart';
import 'package:weatherapp/features/dashboard/domain/usecases/get_weather_overview.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:weatherapp/features/dashboard/domain/usecases/get_weather_forecast.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetWeatherOverview _getWeatherOverview;
  final GetNews _getNews;
  final GetWeatherForecast _getWeatherForecast;
  final Future<void> Function()? _getLocationAndPersist;
  DashboardCubit({
    required GetWeatherOverview getWeatherOverview,
    required GetNews getNews,
    required GetWeatherForecast getWeatherForecast,
    Future<void> Function()? getLocationAndPersist,
  })  : _getWeatherOverview = getWeatherOverview,
        _getNews = getNews,
        _getWeatherForecast = getWeatherForecast,
        _getLocationAndPersist = getLocationAndPersist,
        super(const DashboardState());

  Future<void> load() async {
    emit(state.copyWith(status: DashboardStatus.loading, error: null));
    try {
      // Fetch and persist location first (no-op if not provided or denied)
      final fn = _getLocationAndPersist;
      if (fn != null) {
        await fn();
      }

      final overview = await _getWeatherOverview();
      final news = await _getNews();
      final forecast = await _getWeatherForecast();
      emit(state.copyWith(status: DashboardStatus.success, overview: overview, news: news, forecast: forecast));
    } catch (e) {
      emit(state.copyWith(status: DashboardStatus.failure, error: e.toString()));
    }
  }
}
