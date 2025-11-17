import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:weatherapp/core/constants/app_images.dart';
import 'package:weatherapp/core/extensions/spacing_extensions.dart';
import 'package:weatherapp/core/theme/app_colors.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:weatherapp/features/dashboard/presentation/widgets/news_card.dart';
import 'package:weatherapp/features/dashboard/presentation/widgets/weather_overview_card.dart';
import 'package:weatherapp/features/dashboard/presentation/widgets/weather_forecast_card.dart';
import 'package:weatherapp/features/dashboard/presentation/widgets/dashboard_shimmer.dart';
import 'package:weatherapp/features/dashboard/presentation/widgets/locations_menu.dart';
import 'package:weatherapp/core/routing/app_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _drawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
          ),
          child: AdvancedDrawer(
            controller: _drawerController,
            backdropColor: Colors.transparent,

            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 250),
            openScale: 1,
            childDecoration: const BoxDecoration(),
            drawer: LocationsMenu(
              currentLocationName: state.overview?.location,
              controller: _drawerController,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: _MainDashboardBody(
                state: state,
                onMenuTap: () => _drawerController.showDrawer(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MainDashboardBody extends StatelessWidget {
  final DashboardState state;
  final VoidCallback onMenuTap;
  const _MainDashboardBody({required this.state, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FA),
      appBar: AppBar(
        title: Text(
          state.overview?.location.split(',').first ?? 'Loading...',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16).sp,
          ),
        ),
        leading: IconButton(
          icon: Image.asset(AppImages.drawerIcon, width: 24.w, height: 24.w),
          onPressed: onMenuTap,
        ),
        actions: [
          IconButton(
            icon: Image.asset(AppImages.searchIcon, width: 24.w, height: 24.w),
            onPressed: () => context.push(AppRoutes.addLocation),
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
  }

  String _formatHour(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h $ampm';
  }

  String _formatForecastTitle(DashboardState state) {
    final now = state.forecast.first.time;
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
