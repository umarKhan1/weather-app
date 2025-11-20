import 'package:flutter/material.dart';
import 'package:weatherapp/core/constants/app_images.dart';

class MetricCardsGrid extends StatelessWidget {
  final double? temperatureF; // from overview for consistency
  final double? pressure; // hPa
  final double? uvIndex; // placeholder / future
  final double? humidity; // %
  const MetricCardsGrid({super.key, this.temperatureF, this.pressure, this.uvIndex, this.humidity});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricData(asset: AppImages.fahrenheit, title: _fmtTemp(temperatureF), label: 'Fahrenheit'),
      _MetricData(asset: AppImages.pressure, title: _fmtPressure(pressure), label: 'Pressure'),
      _MetricData(asset: AppImages.uvindex, title: _fmtUv(uvIndex), label: 'UV Index'),
      _MetricData(asset: AppImages.humidity, title: _fmtHumidity(humidity), label: 'Humidity'),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: metrics.map((m) => _MetricCard(data: m)).toList(),
    );
  }

  String _fmtTemp(double? v) => v == null ? '—' : '${v.toStringAsFixed(0)}°';
  String _fmtPressure(double? v) => v == null ? '—' : '${v.toStringAsFixed(0)} hPa';
  String _fmtUv(double? v) => v == null ? '0.0' : v.toStringAsFixed(1);
  String _fmtHumidity(double? v) => v == null ? '—' : '${v.toStringAsFixed(0)}%';
}

class _MetricData {
  final String asset;
  final String title;
  final String label;
  const _MetricData({required this.asset, required this.title, required this.label});
}

class _MetricCard extends StatelessWidget {
  final _MetricData data;
  const _MetricCard({required this.data});
  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 16 * 2 - 16) / 2;
    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF6F9FF)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(data.asset, width: 32, height: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F3A4C),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
