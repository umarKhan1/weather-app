import 'package:flutter/widgets.dart';
import 'package:weatherapp/core/constants/app_images.dart';

class WeatherIcon extends StatelessWidget {
  final int? code;
  const WeatherIcon({super.key, this.code});

  @override
  Widget build(BuildContext context) {
    final asset = _mapCodeToAsset(code);
    if (asset == null) return const SizedBox.shrink();
    return Image.asset(asset, width: 40, height: 40);
  }

  String? _mapCodeToAsset(int? code) {
    if (code == null) return null;
    // Basic mapping: thunderstorm 2xx, drizzle 3xx, rain 5xx, snow 6xx, atmosphere 7xx, clear 800, clouds 80x
    if (code == 800) return AppImages.sunny;
    if (code == 801 || code == 802) return AppImages.partialyCloudy;
    if (code == 803 || code == 804) return AppImages.cloudy;
    if (code >= 200 && code < 300) return AppImages.rain; // use rain as placeholder for thunder
    if (code >= 300 && code < 600) return AppImages.rain;
    if (code >= 600 && code < 700) return AppImages.cloudy; // fallback (no snow asset)
    if (code >= 700 && code < 800) return AppImages.cloudy;
    if (code >= 500 && code < 600) return AppImages.rain;
    return AppImages.partialyCloudy;
  }
}
