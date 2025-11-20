import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weatherapp/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:weatherapp/features/dashboard/domain/entities/forecast_entry.dart';
import 'package:weatherapp/features/dashboard/domain/entities/weather_overview.dart';

class WeatherDetailPage extends StatelessWidget {
  const WeatherDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final overview = state.overview;
        final forecast = state.forecast;
        return Scaffold(
          backgroundColor: const Color(0xFFF1F1F1),
          body: SafeArea(
            child: overview == null
                ? const Center(child: CircularProgressIndicator())
                : _DetailContent(overview: overview, forecast: forecast),
          ),
        );
      },
    );
  }
}

class _DetailContent extends StatelessWidget {
  final WeatherOverview overview;
  final List<ForecastEntry> forecast;
  const _DetailContent({required this.overview, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final topFive = forecast.take(5).toList();
    return Column(
      children: [
        // Header stack area
        SizedBox(
          height: 360 + 100,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _BlueHeader(overview: overview),
              Positioned(
                left: 16,
                right: 16,
                top: 360 - 85,
                child: _ForecastPanel(entries: topFive),
              ),
              // App bar row overlay
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          overview.location.split(',').first,
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
                ),
              ),
            ],
          ),
        ),
        // Placeholder for metrics (reuse existing metrics below header)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2F3A4C))),
                SizedBox(height: 16),
                // The metric cards would be reused from existing widget (placeholder containers here)
                _MetricPlaceholder(title: '72°', label: 'Fahrenheit', icon: Icons.thermostat),
                SizedBox(height: 16),
                _MetricPlaceholder(title: '134 mp/h', label: 'Pressure', icon: Icons.air),
                SizedBox(height: 16),
                _MetricPlaceholder(title: '0.2', label: 'UV Index', icon: Icons.wb_sunny),
                SizedBox(height: 16),
                _MetricPlaceholder(title: '48%', label: 'Humidity', icon: Icons.cloud),
                SizedBox(height: 32),
                Text('Tips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2F3A4C))),
                SizedBox(height: 16),
                _TipsCard(message: '✨  Its ok to hangout with your friend!'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BlueHeader extends StatelessWidget {
  final WeatherOverview overview;
  const _BlueHeader({required this.overview});

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(DateTime.now());
    final iconPath = 'assets/images/partlycloudy.png';
    return Container(
      height: 360,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5AA3FF), Color(0xFF6EB5FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Image.asset(iconPath, width: 120, height: 120, fit: BoxFit.contain),
          const SizedBox(height: 12),
          Text(
            overview.condition,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            dateStr,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
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

class _ForecastPanel extends StatelessWidget {
  final List<ForecastEntry> entries;
  const _ForecastPanel({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFEEF5FF)],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          _SegmentedStatic(),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: entries.map((e) => _HourItem(entry: e)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedStatic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _SegmentLabel(text: 'Yesterday', selected: false),
          _SegmentLabel(text: 'Today', selected: true),
          _SegmentLabel(text: 'Tomorrow', selected: false),
        ],
      ),
    );
  }
}

class _SegmentLabel extends StatelessWidget {
  final String text;
  final bool selected;
  const _SegmentLabel({required this.text, required this.selected});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF547CFF) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : Colors.grey.shade600,
        ),
      ),
    );
  }
}

class _HourItem extends StatelessWidget {
  final ForecastEntry entry;
  const _HourItem({required this.entry});

  @override
  Widget build(BuildContext context) {
    final timeStr = _formatHour(entry.time);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(timeStr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        // Placeholder icon mapping, assuming asset path mapping handled elsewhere
        Image.asset('assets/images/partlycloudy.png', width: 32, height: 32, fit: BoxFit.contain),
        const SizedBox(height: 8),
        Text('${entry.temperatureF.toStringAsFixed(0)}°', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey.shade700)),
      ],
    );
  }

  String _formatHour(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h $ampm';
  }
}

class _MetricPlaceholder extends StatelessWidget {
  final String title;
  final String label;
  final IconData icon;
  const _MetricPlaceholder({required this.title, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 16 * 2 - 16) / 2;
    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2F77E5), size: 28),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2F3A4C))),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blueGrey.shade600)),
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  final String message;
  const _TipsCard({required this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2F3A4C)),
      ),
    );
  }
}
