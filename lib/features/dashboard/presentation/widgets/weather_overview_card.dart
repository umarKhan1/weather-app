import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/constants/app_images.dart';
import 'package:weatherapp/core/extensions/spacing_extensions.dart';
import 'package:weatherapp/core/theme/app_colors.dart';
import 'package:weatherapp/features/dashboard/domain/entities/weather_overview.dart';
import 'package:weatherapp/features/dashboard/presentation/widgets/metric.dart';

class WeatherOverviewCard extends StatelessWidget {
  final WeatherOverview data;
  const WeatherOverviewCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.gradientStart, AppColors.gradientEnd],
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: gradient,
      ),
      padding: .all(25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: texts + condition image
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chance of rain ${data.rainChancePercent.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: cs.onPrimary,
                            fontSize: (Theme.of(context).textTheme.labelLarge?.fontSize ?? 14).sp,
                          ),
                    ),
                    8.vGap,
                    Text(
                      data.condition,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onPrimary,

                            shadows: [
                              Shadow(
                                offset: Offset(0, 2.h),
                                blurRadius: 2.r,
                                color: Colors.black.withAlpha(50),
                              ),
                            ],
                            fontSize: (Theme.of(context).textTheme.headlineSmall?.fontSize ?? 28).sp,
                          ),
                    ),
                  ],
                ),
              ),
              12.hGap,
              SizedBox(
                width: 89.w,
                height: 89.w,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(AppImages.splashImage),
                ),
              ),
            ],
          ),
        
          // Location row (full width)
          Row(
            children: [
              Icon(Icons.location_on, size: 16.sp, color: cs.onPrimary),
              6.hGap,
              Expanded(
                child: Text(
                  data.location,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onPrimary,
                        fontWeight: .w700,
                        fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 17).sp,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          12.vGap,
          // Metrics: wrap to avoid overflow
          Wrap(
            spacing: 18.w,
            runSpacing: 10.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: data.temperatureF.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: cs.onPrimary,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Transform.translate(
                        offset: Offset(0, -6.h),
                        child: Text(
                          '°',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: cs.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Transform.translate(
                        offset: Offset(0, -8.h),
                        child: Text(
                          ' F',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: cs.onPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Metric(label: '${data.rainChancePercent.toStringAsFixed(0)}%', icon: Icons.cloud, isRequired: true),
              Metric(label: data.uvIndex.toStringAsFixed(1), icon: Icons.wb_sunny, isRequired: true),
              Metric(label: '${data.windSpeedMph.toStringAsFixed(0)} mph', icon: Icons.air, isRequired: true),
            ],
          ),
        ],
      ),
    );
  }
}
