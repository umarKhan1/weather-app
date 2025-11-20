import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/extensions/spacing_extensions.dart';
import 'package:weatherapp/features/weather_detail/presentation/cubit/weather_detail_cubit.dart';
import 'package:weatherapp/features/weather_detail/presentation/cubit/weather_detail_state.dart';
import 'package:weatherapp/features/weather_detail/presentation/widgets/detail_header.dart';
import 'package:weatherapp/features/weather_detail/presentation/widgets/forecast_day_tabs.dart';
import 'package:weatherapp/features/weather_detail/presentation/widgets/metric_cards_grid.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:weatherapp/features/weather_detail/data/repositories/weather_detail_repository_impl.dart';
import 'package:weatherapp/features/weather_detail/data/datasources/weather_detail_local_datasource.dart';
import 'package:weatherapp/features/weather_detail/domain/usecases/get_daily_weather_breakdown.dart';

class WeatherDetailPage extends StatelessWidget {
  const WeatherDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, dashState) {
        if (dashState.forecast.isEmpty || dashState.overview == null) {
          return const Scaffold(body: _DetailLoadingShimmer());
        }
        // DI bridge (in real app move to injection layer)
        final repo = WeatherDetailRepositoryImpl(
          local: WeatherDetailLocalDataSourceImpl(() => dashState.forecast),
        );
        return BlocProvider(
          create: (_) => WeatherDetailCubit(GetDailyWeatherBreakdown(repo))..load(),
          child: _WeatherDetailScaffold(
            location: dashState.overview!.location,
            condition: dashState.overview!.condition,
            code: dashState.overview!.code,
          ),
        );
      },
    );
  }
}

class _WeatherDetailScaffold extends StatelessWidget {
  final String location;
  final String condition;
  final int? code;
  const _WeatherDetailScaffold({required this.location, required this.condition, this.code});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: BlocBuilder<WeatherDetailCubit, WeatherDetailState>(
        builder: (context, state) {
          if (state.status == WeatherDetailStatus.loading) {
            return const _DetailLoadingShimmer();
          }
          if (state.status == WeatherDetailStatus.failure) {
            return Center(child: Text(state.error ?? 'Error'));
          }
          final day = state.selectedDay;
          if (day == null) {
            return const Center(child: Text('No data'));
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 380.h, // header + panel space
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [

                      Positioned.fill(child: DetailHeader(location: location, condition: condition, code: code)),
                      Positioned(
                        left: 16.w,
                        right: 16.w,
                        top: 290.h,
                        child: ForecastDayTabs(
                          days: state.days,
                          selectedIndex: state.selectedIndex,
                          onSelect: context.read<WeatherDetailCubit>().select,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Remove separate hourly strip since now inside panel
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 40),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text('Detailed Metrics', style: Theme.of(context).textTheme.titleMedium),
                      16.vGap,
                      MetricCardsGrid(
                        temperatureF: day.hours.isNotEmpty ? day.hours.first.temperatureF : null,
                        pressure: day.hours.isNotEmpty ? day.hours.first.pressure : null,
                        uvIndex: null,
                        humidity: day.hours.isNotEmpty ? day.hours.first.humidity : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailLoadingShimmer extends StatelessWidget {
  const _DetailLoadingShimmer();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            _shimmerBlock(height: 300, radius: 40),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (int i = 0; i < 4; i++) _shimmerBlock(height: 96, radius: 28, width: (MediaQuery.of(context).size.width - 16 * 2 - 16) / 2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBlock({required double height, required double radius, double? width}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
