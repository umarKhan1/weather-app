import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/constants/app_images.dart';
import 'package:weatherapp/core/extensions/spacing_extensions.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:weatherapp/features/dashboard/presentation/widgets/news_card.dart';
import 'package:weatherapp/features/dashboard/presentation/widgets/weather_overview_card.dart';
import 'package:weatherapp/features/dashboard/presentation/widgets/weather_forecast_card.dart';
import 'package:weatherapp/features/dashboard/presentation/widgets/dashboard_shimmer.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          drawer: const Drawer(),
          appBar: AppBar(
            title: Text(
              state.overview?.location.split(',').first ?? 'Loading...',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16).sp,
              ),
            ),
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: Image.asset(AppImages.drawerIcon, width: 24.w, height: 24.w),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                icon: Image.asset(AppImages.searchIcon, width: 24.w, height: 24.w),
                onPressed: () {},
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().load(),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              children: [
                if (state.status == DashboardStatus.loading)
                  const DashboardShimmer(),
                if (state.status == DashboardStatus.failure)
                  Text(state.error ?? 'Error', style: theme.textTheme.bodyMedium),
                if (state.overview != null) WeatherOverviewCard(data: state.overview!),
                16.vGap,
                if (state.forecast.isNotEmpty)
                  WeatherForecastCard(
                    subtitle: state.overview?.condition ?? 'Forecast',
                    title: _formatForecastTitle(state),
                    items: state.forecast.take(6).map((e) => HourlyForecast(
                          time: _formatHour(e.time),
                          condition: e.condition,
                          temperatureF: e.temperatureF,
                        )).toList(),
                    onFilterTap: () {},
                  ),
                24.vGap,
                Text(
                  'News',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16).sp,
                  ),
                ),
                12.vGap,
                for (final item in state.news) NewsCard(item: item),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatHour(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h $ampm';
  }

  String _formatForecastTitle(DashboardState state) {
    final now = state.forecast.first.time;
    // Example: August, 10th 2020
    final monthNames = [
      'January','February','March','April','May','June','July','August','September','October','November','December'
    ];
    final month = monthNames[now.month - 1];
    final day = now.day;
    final year = now.year;
    final suffix = _daySuffix(day);
    return '$month, $day$suffix $year';
  }

  String _daySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
