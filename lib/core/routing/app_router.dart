import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weatherapp/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:weatherapp/features/weather_detail/presentation/pages/weather_detail_page.dart';
import 'package:weatherapp/features/locations/presentation/pages/add_location_page.dart';
import 'package:weatherapp/features/splash/presentation/pages/splash_page.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static const splash = '/';
  static const dashboard = '/dashboard';
  static const settings = '/settings';
  static const addLocation = '/add-location';
  static const weatherDetail = '/weather-detail';
}

class AppRouter {
  static GoRouter create() => GoRouter(
        navigatorKey: _rootKey,
        initialLocation: AppRoutes.splash,
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.splash,
            name: 'splash',
            builder: (context, state) => const SplashPage(),
          ),
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const Placeholder(),
          ),
          GoRoute(
            path: AppRoutes.addLocation,
            name: 'add-location',
            builder: (context, state) => const AddLocationPage(),
          ),
          GoRoute(
            path: AppRoutes.weatherDetail,
            name: 'weather-detail',
            builder: (context, state) => const WeatherDetailPage(),
          ),
        ],
      );
}
