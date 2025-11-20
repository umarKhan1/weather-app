import 'package:flutter/material.dart';
import '../../domain/entities/hourly_weather.dart';

class HourlyStrip extends StatelessWidget {
  final List<HourlyWeather> hours;
  const HourlyStrip({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final h in hours.take(5)) _HourItem(hour: h),
        ],
      ),
    );
  }
}

class _HourItem extends StatelessWidget {
  final HourlyWeather hour;
  const _HourItem({required this.hour});

  @override
  Widget build(BuildContext context) {
    final timeStr = _formatHour(hour.time);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(timeStr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        Image.asset('assets/images/partlycloudy.png', width: 32, height: 32),
        const SizedBox(height: 8),
        Text('${hour.temperatureF.toStringAsFixed(0)}°', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey.shade700)),
      ],
    );
  }

  String _formatHour(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h $ampm';
  }
}
