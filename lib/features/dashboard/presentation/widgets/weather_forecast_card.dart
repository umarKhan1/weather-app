import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/constants/app_images.dart';
import 'package:weatherapp/core/extensions/spacing_extensions.dart';
import 'package:weatherapp/core/utils/weather_icon_mapper.dart';

class HourlyForecast {
  final String time; // e.g. "10 AM"
  final String condition; // e.g. "Sunny", "Partly Cloudy", "Rain"
  final num temperatureF; // temperature in Fahrenheit
  const HourlyForecast({required this.time, required this.condition, required this.temperatureF});
}

class WeatherForecastCard extends StatelessWidget {
  final String subtitle; // e.g. "Partly Cloudy"
  final String title; // e.g. "August, 10th 2020"
  final List<HourlyForecast> items;
  final VoidCallback? onFilterTap;

  const WeatherForecastCard({
    super.key,
    required this.subtitle,
    required this.title,
    required this.items,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withAlpha(10),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: cs.outline,
                        fontSize: (theme.textTheme.labelLarge?.fontSize ?? 14).sp,
                      ),
                    ),
                    6.vGap,
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20).sp,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onFilterTap,
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.all(6.w),
                  child: Image.asset(AppImages.filter, width: 20.w, height: 20.w),
                ),
              ),
            ],
          ),
          16.vGap,
          SizedBox(
            height: 110.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, _) => SizedBox(width: 14.w),
              itemBuilder: (context, index) {
                final item = items[index];
                final icon = WeatherIconMapper.fromCondition(item.condition);
                return _ForecastTile(
                  time: item.time,
                  iconPath: icon,
                  temperatureF: item.temperatureF,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ForecastTile extends StatelessWidget {
  final String time;
  final String iconPath;
  final num temperatureF;
  const _ForecastTile({required this.time, required this.iconPath, required this.temperatureF});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: 76.w,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.outline,
              fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12).sp,
            ),
          ),
          8.vGap,
          SizedBox(
            width: 28.w,
            height: 28.w,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(iconPath),
            ),
          ),
          8.vGap,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: temperatureF.toStringAsFixed(0),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                    fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14).sp,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Transform.translate(
                    offset: Offset(0, -3.h),
                    child: Text(
                      '°',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                        fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12).sp,
                      ),
                    ),
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Transform.translate(
                    offset: Offset(0, -4.h),
                    child: Text(
                      ' F',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.outline,
                        fontSize: (theme.textTheme.bodySmall?.fontSize ?? 10).sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
