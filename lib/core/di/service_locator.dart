import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:weatherapp/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:weatherapp/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:weatherapp/features/dashboard/domain/usecases/get_news.dart';
import 'package:weatherapp/features/dashboard/domain/usecases/get_weather_overview.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weatherapp/core/location/location_service.dart';
import 'package:weatherapp/core/storage/prefs.dart';
import 'package:weatherapp/core/network/dio_client.dart';
import 'package:weatherapp/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:weatherapp/features/dashboard/domain/usecases/get_weather_forecast.dart';

class AppProviders {
  const AppProviders._();

  static List<RepositoryProvider> repositoryProviders() => [
        RepositoryProvider<DashboardLocalDataSource>(
          create: (_) => DashboardLocalDataSourceImpl(),
        ),
        RepositoryProvider<DioClient>(
          create: (_) => DioClient(),
        ),
        RepositoryProvider<DashboardRemoteDataSource>(
          create: (ctx) => DashboardRemoteDataSourceImpl(ctx.read<DioClient>()),
        ),
        RepositoryProvider<DashboardRepository>(
          create: (ctx) => DashboardRepositoryImpl(
            local: ctx.read<DashboardLocalDataSource>(),
            remote: ctx.read<DashboardRemoteDataSource>(),
          ),
        ),
        RepositoryProvider<GetWeatherOverview>(
          create: (ctx) => GetWeatherOverview(ctx.read<DashboardRepository>()),
        ),
        RepositoryProvider<GetNews>(
          create: (ctx) => GetNews(ctx.read<DashboardRepository>()),
        ),
        RepositoryProvider<GetWeatherForecast>(
          create: (ctx) => GetWeatherForecast(ctx.read<DashboardRepository>()),
        ),
        RepositoryProvider<LocationService>(
          create: (_) => const LocationService(),
        ),
      ];

  static List<BlocProvider> blocProviders() => [
        BlocProvider<DashboardCubit>(
          create: (ctx) => DashboardCubit(
            getWeatherOverview: ctx.read<GetWeatherOverview>(),
            getNews: ctx.read<GetNews>(),
            getWeatherForecast: ctx.read<GetWeatherForecast>(),
            getLocationAndPersist: () async {
              final loc = await ctx.read<LocationService>().getCurrentLocation();
              if (loc != null) {
                await AppPrefs.saveLatLon(lat: loc.lat, lon: loc.lon);
              }
            },
          )..load(),
        ),
      ];

  static Widget withProviders({required Widget child}) {
    return MultiRepositoryProvider(
      providers: repositoryProviders(),
      child: MultiBlocProvider(
        providers: blocProviders(),
        child: child,
      ),
    );
  }
}
