import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weatherapp/core/utils/weather_icon_mapper.dart';

class DetailHeader extends StatelessWidget {
  final String location;
  final String condition;
  final int? code; // OpenWeather condition code for icon mapping
  const DetailHeader({super.key, required this.location, required this.condition, this.code});

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(DateTime.now());
    final asset = WeatherIconMapper.fromCondition(condition, weatherCode: code);
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
              colors: [Color(0xFF3C6FD1), Color(0xFF7CA9FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    location.split(',').first,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: Image.asset(asset, fit: BoxFit.contain),
                ),
                const SizedBox(height: 12),
                Text(
                  condition,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  dateStr,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const weekdayNames = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    const monthNames = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    final weekday = weekdayNames[dt.weekday - 1];
    final month = monthNames[dt.month - 1];
    return '$weekday, ${dt.day} $month ${dt.year}';
  }
}
