import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_daily_weather_breakdown.dart';
import 'weather_detail_state.dart';

class WeatherDetailCubit extends Cubit<WeatherDetailState> {
  final GetDailyWeatherBreakdown _getDaily;
  WeatherDetailCubit(this._getDaily) : super(const WeatherDetailState());

  Future<void> load() async {
    emit(state.copyWith(status: WeatherDetailStatus.loading));
    try {
      final days = await _getDaily();
      emit(state.copyWith(status: WeatherDetailStatus.success, days: days, selectedIndex: 0));
    } catch (e) {
      emit(state.copyWith(status: WeatherDetailStatus.failure, error: e.toString()));
    }
  }

  void select(int index) {
    if (index < 0 || index >= state.days.length) return;
    emit(state.copyWith(selectedIndex: index));
  }
}
