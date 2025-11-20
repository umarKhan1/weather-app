// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:weatherapp/core/extensions/spacing_extensions.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weatherapp/features/locations/domain/usecases/save_location_selection.dart';
import 'package:weatherapp/features/locations/presentation/cubit/saved_locations_cubit.dart';
import 'package:weatherapp/core/routing/app_router.dart';

class LocationsMenu extends StatelessWidget {
  final String? currentLocationName;
  final AdvancedDrawerController? controller;
  const LocationsMenu({super.key, this.currentLocationName, this.controller});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300.w,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4C7BD9), Color(0xFF5FA7E6)],
          ),
        ),
        padding: EdgeInsets.only(left: 20.w, right: 12.w, top: 56.h, bottom: 24.h),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current location', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white70)),
              8.vGap,
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white),
                  10.hGap,
                  Expanded(
                    child: Text(
                      currentLocationName ?? 'Unknown',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              100.vGap,
              InkWell(
                onTap: () async {
                  controller?.hideDrawer();
                  await Future<void>.delayed(const Duration(milliseconds: 150));
                  await context.push(AppRoutes.addLocation);
                  context.read<SavedLocationsCubit>().load();
                },
                child: Row(
                  children: [
                    const Icon(Icons.add_location_alt, color: Color(0xFFFFF176)),
                    10.hGap,
                    Text('Add Location', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFFFFF176), fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              12.vGap,
              InkWell(
                onTap: () async {
                  controller?.hideDrawer();
                  await Future<void>.delayed(const Duration(milliseconds: 120));
                  if (context.mounted) {
                    // Switch back to device GPS location; this will persist the coords via DI callback
                    await context.read<DashboardCubit>().load(refreshLocation: true);
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.my_location, color: Color(0xFFFFF176)),
                    10.hGap,
                    Text('Use Current Location', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFFFFF176), fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              16.vGap,
              Expanded(
                child: BlocBuilder<SavedLocationsCubit, SavedLocationsState>(
                  builder: (context, state) {
                    final items = state.items;
                    return ListView.separated(
                      itemBuilder: (_, i) {
                        final loc = items[i];
                        return InkWell(
                          onTap: () async {
                            // Persist selection (saves lat/lon + keeps it in saved list)
                            await context.read<SaveLocationSelection>()(loc);
                            // Refresh the saved locations list (in case of dedupe/order changes)
                            if (context.mounted) {
                              context.read<SavedLocationsCubit>().load();
                            }
                            // Close the drawer for UX then reload dashboard using persisted coords
                            controller?.hideDrawer();
                            if (context.mounted) {
                              await Future<void>.delayed(const Duration(milliseconds: 120));
                              context.read<DashboardCubit>().load(refreshLocation: false);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Row(
                              children: [
                                const Icon(Icons.place, color: Colors.white),
                                10.hGap,
                                Expanded(
                                  child: Text(
                                    loc.name,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, _) => Divider(color: Colors.white.withAlpha(60)),
                      itemCount: items.length,
                    );
                  },
                ),
              ),
              16.vGap,
              _drawerAction(context, Icons.settings, 'Settings', _openSettings),
              10.vGap,
              _drawerAction(context, Icons.share, 'Share this app', _shareApp),
              10.vGap,
              _drawerAction(context, Icons.star_rate_rounded, 'Rate this app', _rateApp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerAction(BuildContext context, IconData icon, String label, Future<void> Function(BuildContext) onTap) => InkWell(
        onTap: () => onTap(context),
        child:  Text(label, style:  TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17.sp)),
      );

  Future<void> _openSettings(BuildContext context) async {
    controller?.hideDrawer();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (context.mounted) context.push(AppRoutes.settings);
  }

  Future<void> _shareApp(BuildContext context) async {
    controller?.hideDrawer();
    await Share.share('Check out WeatherApp! Stay updated with weather and forecasts.');
  }

  Future<void> _rateApp(BuildContext context) async {
    controller?.hideDrawer();
    const androidUrl = 'https://play.google.com/store/apps/details?id=com.muhammadomar.weatherapp';
    const iosUrl = 'https://apps.apple.com/app/id0000000000';
    final platform = Theme.of(context).platform;
    final url = platform == TargetPlatform.android ? androidUrl : iosUrl;
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
