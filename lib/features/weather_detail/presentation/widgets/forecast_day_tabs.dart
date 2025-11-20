import 'package:flutter/material.dart';
import 'package:weatherapp/core/utils/weather_icon_mapper.dart';
import '../../domain/entities/daily_weather.dart';
import '../../domain/entities/hourly_weather.dart';

class ForecastDayTabs extends StatelessWidget {
  final List<DailyWeather> days;
  final int selectedIndex;
  final void Function(int index) onSelect;
  const ForecastDayTabs({super.key, required this.days, required this.selectedIndex, required this.onSelect});

  List<HourlyWeather> get _selectedHours => (selectedIndex >= 0 && selectedIndex < days.length) ? days[selectedIndex].hours : const [];

  @override
  Widget build(BuildContext context) {
    final hours = _selectedHours;
    // Panel wrapper (NO negative margins). This widget is intended to be placed in a Stack and positioned.
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFEEF5FF)],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha:  0.06), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Segments(days: days, selectedIndex: selectedIndex, onSelect: onSelect),
          const SizedBox(height: 16),
          Row(
            key: ValueKey(selectedIndex),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final h in hours.take(5)) Flexible(child: _HourItem(hour: h)),
              if (hours.isEmpty) const Text('No hours', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Segments extends StatelessWidget {
  final List<DailyWeather> days;
  final int selectedIndex;
  final void Function(int index) onSelect;
  const _Segments({required this.days, required this.selectedIndex, required this.onSelect});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
     // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          for (var i = 0; i < days.length && i < 3; i++) Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Center(
                child: _SegmentLabel(
                  text: _label(days[i].date, i),
                  selected: i == selectedIndex,
                  onTap: () => onSelect(i),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



String _label(DateTime dt, int i) {
  if (i == 0) return 'Yesterday';
  if (i == 1) return 'Today';
  if (i == 2) return 'Tomorrow';
  return '';
}

}

class _SegmentLabel extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentLabel({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF547CFF), Color(0xFF6A92FF)],
                )
              : null,
          //color: selected ? const Color(0xFF547CFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey.shade600,
          ),
        ),
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
    final asset = WeatherIconMapper.fromCondition(hour.condition, weatherCode: hour.code);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(timeStr, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        Image.asset(asset, width: 32, height: 32),
        const SizedBox(height: 8),
        Text('${hour.temperatureF.toStringAsFixed(0)}°', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey.shade700)),
      ],
    );
  }

  String _formatHour(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h $ampm';
  }
}
