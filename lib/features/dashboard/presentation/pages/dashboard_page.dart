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
                  const Center(child: CircularProgressIndicator()),
                if (state.status == DashboardStatus.failure)
                  Text(state.error ?? 'Error', style: theme.textTheme.bodyMedium),
                if (state.overview != null) WeatherOverviewCard(data: state.overview!),
           
                24.vGap,
                Text(
                  'News',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16).sp,
                  ),
                ),
                12.vGap,
                for (final item in state.news) NewsCard(item: item),
                   16.vGap,
                WeatherForecastCard(
                  subtitle: state.overview?.condition ?? 'Partly Cloudy',
                  title: 'August, 10th 2020',
                  items: const [
                    HourlyForecast(time: '10 AM', condition: 'Sunny', temperatureF: 71),
                    HourlyForecast(time: '11 AM', condition: 'Partly Cloudy', temperatureF: 73),
                    HourlyForecast(time: '12 PM', condition: 'Cloudy', temperatureF: 74),
                    HourlyForecast(time: '1 PM', condition: 'Rain', temperatureF: 72),
                    HourlyForecast(time: '2 PM', condition: 'Sunny', temperatureF: 75),
                    HourlyForecast(time: '3 PM', condition: 'Partly Cloudy', temperatureF: 76),
                  ],
                  onFilterTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
