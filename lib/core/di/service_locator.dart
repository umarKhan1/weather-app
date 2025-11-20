import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/core/location/location_service.dart';
import 'package:weatherapp/core/network/dio_client.dart';
import 'package:weatherapp/core/storage/prefs.dart';
import 'package:weatherapp/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:weatherapp/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:weatherapp/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:weatherapp/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:weatherapp/features/dashboard/domain/usecases/get_news.dart';
import 'package:weatherapp/features/dashboard/domain/usecases/get_weather_forecast.dart';
import 'package:weatherapp/features/dashboard/domain/usecases/get_weather_overview.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weatherapp/features/locations/data/datasources/location_remote_datasource.dart';
import 'package:weatherapp/features/locations/data/repositories/location_repository_impl.dart';
import 'package:weatherapp/features/locations/domain/repositories/location_repository.dart';
import 'package:weatherapp/features/locations/domain/usecases/save_location_selection.dart';
import 'package:weatherapp/features/locations/domain/usecases/search_locations.dart';
import 'package:weatherapp/features/locations/presentation/cubit/location_search_cubit.dart';
import 'package:weatherapp/features/locations/presentation/cubit/saved_locations_cubit.dart';

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
        // Locations feature: datasource, repo, usecases
        RepositoryProvider<LocationRemoteDataSource>(
          create: (_) => LocationRemoteDataSource(),
        ),
        RepositoryProvider<LocationRepository>(
          create: (ctx) => LocationRepositoryImpl(ctx.read<LocationRemoteDataSource>()),
        ),
        RepositoryProvider<SearchLocations>(
          create: (ctx) => SearchLocations(ctx.read<LocationRepository>()),
        ),
        RepositoryProvider<SaveLocationSelection>(
          create: (ctx) => SaveLocationSelection(ctx.read<LocationRepository>()),
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
        BlocProvider<SavedLocationsCubit>(
          create: (ctx) => SavedLocationsCubit(ctx.read<LocationRepository>())..load(),
        ),
      ];

  // Scoped provider for Add Location feature
  static Widget withLocationSearch({required Widget child}) => BlocProvider<LocationSearchCubit>(
        create: (ctx) => LocationSearchCubit(
          ctx.read<SearchLocations>(),
          ctx.read<SaveLocationSelection>(),
        ),
        child: child,
      );

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
