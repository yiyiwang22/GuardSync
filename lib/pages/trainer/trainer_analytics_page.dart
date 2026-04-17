import 'dart:math' as math;
import 'package:flutter/material.dart';

class TrainerAnalyticsPage extends StatefulWidget {
  const TrainerAnalyticsPage({super.key});

  @override
  State<TrainerAnalyticsPage> createState() => _TrainerAnalyticsPageState();
}

class _TrainerAnalyticsPageState extends State<TrainerAnalyticsPage> {
  String _selectedRange = '30min';

  final Map<String, int> _alertCounts = {
    '30min': 7,
    '1hr': 7,
    '3hr': 17,
    '24hr': 62,
  };

  late final Map<String, AnalyticsBundle> _rangeData = {
    '30min': _build30MinBundle(),
    '1hr': _build1HrBundle(),
    '3hr': _build3HrBundle(),
    '24hr': _build24HrBundle(),
  };

  @override
  Widget build(BuildContext context) {
    final bundle = _rangeData[_selectedRange]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildRangeTabs(),
                    const SizedBox(height: 24),

                    AnalyticsChartCard(
                      title: 'Heart Rate',
                      subtitle:
                      'Avg: ${bundle.heartRateSummary.avg} BPM • Min: ${bundle.heartRateSummary.min} • Max: ${bundle.heartRateSummary.max}',
                      points: bundle.heartRate,
                      yMin: bundle.heartRateSummary.yMin,
                      yMax: bundle.heartRateSummary.yMax,
                      threshold: bundle.heartRateSummary.threshold,
                      normalColor: const Color(0xFF166B57),
                      warningColor: const Color(0xFFEF4444),
                      yLabels: bundle.heartRateSummary.yLabels,
                      iconBg: const Color(0xFFE5ECE8),
                      iconColor: const Color(0xFF166B57),
                      tooltipLabelBuilder: (point) =>
                      '${point.label}\nHeart Rate : ${point.value.toStringAsFixed(0)} BPM',
                    ),

                    const SizedBox(height: 22),

                    AnalyticsChartCard(
                      title: 'Blood Oxygen (SpO2)',
                      subtitle: 'Avg: ${bundle.spo2Summary.avg}%',
                      points: bundle.spo2,
                      yMin: bundle.spo2Summary.yMin,
                      yMax: bundle.spo2Summary.yMax,
                      threshold: bundle.spo2Summary.threshold,
                      normalColor: const Color(0xFF166B57),
                      warningColor: const Color(0xFFEF4444),
                      yLabels: bundle.spo2Summary.yLabels,
                      iconBg: const Color(0xFFE5ECE8),
                      iconColor: const Color(0xFF166B57),
                      tooltipLabelBuilder: (point) =>
                      '${point.label}\nSpO2 : ${point.value.toStringAsFixed(1)}%',
                    ),

                    const SizedBox(height: 22),

                    AnalyticsChartCard(
                      title: 'Body Temperature',
                      subtitle: '°F',
                      points: bundle.temperature,
                      yMin: bundle.temperatureSummary.yMin,
                      yMax: bundle.temperatureSummary.yMax,
                      threshold: bundle.temperatureSummary.threshold,
                      normalColor: const Color(0xFFFF6F31),
                      warningColor: const Color(0xFFEF4444),
                      yLabels: bundle.temperatureSummary.yLabels,
                      iconBg: const Color(0xFFF9E9E2),
                      iconColor: const Color(0xFFFF6F31),
                      tooltipLabelBuilder: (point) =>
                      '${point.label}\nTemperature : ${point.value.toStringAsFixed(1)}°F',
                    ),

                    const SizedBox(height: 22),

                    AnalyticsChartCard(
                      title: 'Head Acceleration Events',
                      subtitle: 'Max Impact: ${bundle.headAccelerationSummary.max}g',
                      points: bundle.headAcceleration,
                      yMin: bundle.headAccelerationSummary.yMin,
                      yMax: bundle.headAccelerationSummary.yMax,
                      threshold: bundle.headAccelerationSummary.threshold,
                      normalColor: const Color(0xFFF9A826),
                      warningColor: const Color(0xFFEF4444),
                      yLabels: bundle.headAccelerationSummary.yLabels,
                      badgeText: bundle.headAccelerationSummary.badgeText,
                      tooltipLabelBuilder: (point) =>
                      '${point.label}\nImpact : ${point.value.toStringAsFixed(1)}g',
                    ),

                    const SizedBox(height: 22),

                    AnalyticsChartCard(
                      title: 'Bite Force',
                      subtitle: 'Newtons (N)',
                      points: bundle.biteForce,
                      yMin: bundle.biteForceSummary.yMin,
                      yMax: bundle.biteForceSummary.yMax,
                      threshold: bundle.biteForceSummary.threshold,
                      normalColor: const Color(0xFF166B57),
                      warningColor: const Color(0xFFEF4444),
                      yLabels: bundle.biteForceSummary.yLabels,
                      iconBg: const Color(0xFFE5ECE8),
                      iconColor: const Color(0xFF166B57),
                      tooltipLabelBuilder: (point) =>
                      '${point.label}\nBite Force : ${point.value.toStringAsFixed(1)} N',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            final currentRouteName = ModalRoute.of(context)?.settings.name;

            if (currentRouteName == '/parent-analytics') {
              Navigator.pushReplacementNamed(context, '/parent-dashboard');
            } else {
              Navigator.pushReplacementNamed(context, '/trainer-dashboard');
            }
          },
          child: Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D4C8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF555555)),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Performance\nHistory',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F1F1F),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Track your metrics over time',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFCE9EC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${_alertCounts[_selectedRange]} Alerts',
            style: const TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRangeTabs() {
    final tabs = ['30min', '1hr', '3hr', '24hr'];

    return Row(
      children: tabs.map((tab) {
        final selected = _selectedRange == tab;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: tab == tabs.last ? 0 : 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedRange = tab),
              child: Container(
                height: 62,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF166B57) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFD9D6CD)),
                  boxShadow: selected
                      ? null
                      : const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : const Color(0xFF555555),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNav() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        decoration: const BoxDecoration(
          color: Color(0xFFF8F8F6),
          border: Border(
            top: BorderSide(color: Color(0xFFE5E2DA)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: _BottomNavButton(
                label: 'Dashboard',
                icon: Icons.dashboard_outlined,
                isSelected: false,
                onTap: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BottomNavButton(
                label: 'History',
                icon: Icons.show_chart_outlined,
                isSelected: true,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnalyticsBundle _build30MinBundle() {
    return AnalyticsBundle(
      heartRateSummary: const MetricSummary(
        avg: '158',
        min: '142',
        max: '187',
        yMin: 140,
        yMax: 190,
        threshold: 175,
        yLabels: ['140', '157', '173', '190'],
      ),
      heartRate: _barPoints(
        values: [162, 158, 150, 181, 181, 159, 157, 153, 149, 164, 159, 150, 158, 148, 155],
        labels: _minuteLabels(15, step: 2),
        warningThreshold: 175,
      ),
      spo2Summary: const MetricSummary(
        avg: '96',
        min: '',
        max: '',
        yMin: 85,
        yMax: 100,
        threshold: 92,
        yLabels: ['85', '89', '93', '100'],
      ),
      spo2: _barPoints(
        values: [97, 90, 96.5, 96.5, 97.2, 97.5, 98.2, 90.5, 98.0, 98.1, 97.8, 94.0, 91.0, 98.4, 94.0],
        labels: _minuteLabels(15, step: 2),
        isBelowThresholdWarning: true,
        warningThreshold: 92,
      ),
      temperatureSummary: const MetricSummary(
        avg: '',
        min: '',
        max: '',
        yMin: 97,
        yMax: 103,
        threshold: 100.4,
        yLabels: ['97', '99', '101', '103'],
      ),
      temperature: _barPoints(
        values: [98.2, 97.9, 98.0, 98.1, 98.6, 98.6, 98.0, 98.5, 97.9, 97.9, 98.6, 98.4, 98.2, 98.7, 98.2],
        labels: _minuteLabels(15, step: 2),
        warningThreshold: 100.4,
      ),
      headAccelerationSummary: const MetricSummary(
        avg: '',
        min: '',
        max: '102',
        yMin: 0,
        yMax: 120,
        threshold: 80,
        yLabels: ['0', '30', '60', '90', '120'],
        badgeText: 'High Risk',
      ),
      headAcceleration: _barPoints(
        values: [102, 68, 25, 43, 30, 68],
        labels: ['0m', '5m', '10m', '15m', '20m', '25m'],
        warningThreshold: 80,
      ),
      biteForceSummary: const MetricSummary(
        avg: '',
        min: '',
        max: '',
        yMin: 0,
        yMax: 240,
        threshold: 220,
        yLabels: ['0', '60', '120', '180', '240'],
      ),
      biteForce: _barPoints(
        values: [232, 145, 156, 149, 174, 160, 178, 149, 152, 153],
        labels: ['0m', '3m', '6m', '9m', '12m', '15m', '18m', '21m', '24m', '27m'],
        warningThreshold: 220,
      ),
    );
  }

  AnalyticsBundle _build1HrBundle() {
    return AnalyticsBundle(
      heartRateSummary: const MetricSummary(
        avg: '154',
        min: '142',
        max: '167',
        yMin: 140,
        yMax: 170,
        threshold: 175,
        yLabels: ['140', '150', '160', '170'],
      ),
      heartRate: _barPoints(
        values: [
          149, 156, 154, 158, 147, 146, 146, 151, 150, 159, 158, 157,
          156, 159, 155, 163, 149, 146, 155, 159, 160, 155, 147, 151,
          148, 164, 163, 147, 158
        ],
        labels: _minuteLabels(29, step: 2),
        warningThreshold: 175,
      ),
      spo2Summary: const MetricSummary(
        avg: '96',
        min: '',
        max: '',
        yMin: 85,
        yMax: 100,
        threshold: 92,
        yLabels: ['85', '89', '93', '100'],
      ),
      spo2: _barPoints(
        values: [
          97.2, 96.8, 94.0, 90.0, 97.6, 96.8, 90.2, 97.2, 97.8, 98.6, 98.2, 97.7,
          98.0, 98.6, 98.6, 96.1, 94.2, 96.0, 96.2, 94.9, 96.5, 97.2, 94.6, 91.0,
          97.4, 97.4, 88.7, 96.0, 96.8
        ],
        labels: _minuteLabels(29, step: 2),
        isBelowThresholdWarning: true,
        warningThreshold: 92,
      ),
      temperatureSummary: const MetricSummary(
        avg: '',
        min: '',
        max: '',
        yMin: 97,
        yMax: 103,
        threshold: 100.4,
        yLabels: ['97', '99', '101', '103'],
      ),
      temperature: _barPoints(
        values: [
          98.0, 98.0, 98.1, 98.7, 98.5, 98.4, 98.6, 98.0, 98.6, 98.1, 98.0, 97.9,
          97.9, 98.6, 98.5, 98.8, 98.1, 97.8, 98.2, 98.6, 101.2, 98.4, 98.5, 100.7,
          98.6, 98.0, 98.4, 98.3, 98.4
        ],
        labels: _minuteLabels(29, step: 2),
        warningThreshold: 100.4,
      ),
      headAccelerationSummary: const MetricSummary(
        avg: '',
        min: '',
        max: '50',
        yMin: 0,
        yMax: 60,
        threshold: 80,
        yLabels: ['0', '15', '30', '45', '60'],
      ),
      headAcceleration: _barPoints(
        values: [28, 42, 30, 20, 22, 44, 50, 43, 30, 32, 25, 41],
        labels: ['0m', '5m', '10m', '15m', '20m', '25m', '30m', '35m', '40m', '45m', '50m', '55m'],
        warningThreshold: 80,
      ),
      biteForceSummary: const MetricSummary(
        avg: '',
        min: '',
        max: '',
        yMin: 0,
        yMax: 180,
        threshold: 220,
        yLabels: ['0', '45', '90', '135', '180'],
      ),
      biteForce: _barPoints(
        values: [148, 174, 172, 168, 173, 143, 150, 176, 154, 166, 145, 165, 167, 143, 177, 172, 147, 178, 157, 176],
        labels: ['3m', '6m', '9m', '12m', '15m', '18m', '21m', '24m', '27m', '30m', '33m', '36m', '39m', '42m', '45m', '48m', '51m', '54m', '57m', '60m'],
        warningThreshold: 220,
      ),
    );
  }

  AnalyticsBundle _build3HrBundle() {
    return AnalyticsBundle(
      heartRateSummary: const MetricSummary(
        avg: '153',
        min: '46',
        max: '194',
        yMin: 40,
        yMax: 200,
        threshold: 175,
        yLabels: ['40', '93', '146', '200'],
      ),
      heartRate: _barPoints(
        values: [
          150, 144, 134, 140, 146, 134, 155, 143, 132, 130, 194, 136,
          193, 148, 150, 131, 149, 155, 140, 151, 146, 143, 144, 146,
          149, 194, 130, 152, 134, 145, 47, 151, 161, 158, 132, 153
        ],
        labels: _minuteLabels(36, step: 5),
        warningThreshold: 175,
      ),
      spo2Summary: const MetricSummary(
        avg: '96',
        min: '',
        max: '',
        yMin: 85,
        yMax: 100,
        threshold: 92,
        yLabels: ['85', '89', '93', '100'],
      ),
      spo2: _barPoints(
        values: [
          95.0, 97.0, 97.5, 95.4, 94.0, 96.4, 95.2, 95.2, 97.2, 93.8, 96.7, 97.6,
          95.1, 94.8, 95.0, 97.7, 95.4, 96.0, 94.2, 97.4, 95.6, 95.5, 95.4, 94.7,
          94.4, 96.5, 97.6, 94.5, 95.0, 97.5, 97.4, 90.7, 95.5, 96.0, 94.4, 89.8
        ],
        labels: _minuteLabels(36, step: 5),
        isBelowThresholdWarning: true,
        warningThreshold: 92,
      ),
      temperatureSummary: const MetricSummary(
        avg: '',
        min: '',
        max: '',
        yMin: 97,
        yMax: 103,
        threshold: 100.4,
        yLabels: ['97', '99', '101', '103'],
      ),
      temperature: _barPoints(
        values: [
          101.8, 97.8, 98.1, 98.8, 98.4, 98.6, 98.5, 101.5, 98.4, 101.2, 98.6, 98.4,
          98.7, 98.2, 101.9, 98.9, 98.2, 98.4, 98.1, 97.8, 98.6, 98.4, 98.3, 98.6,
          98.7, 98.5, 101.4, 98.6, 97.9, 97.7, 98.8, 98.6, 97.9, 98.1, 98.9, 98.8
        ],
        labels: _minuteLabels(36, step: 5),
        warningThreshold: 100.4,
      ),
      headAccelerationSummary: const MetricSummary(
        avg: '',
        min: '',
        max: '104',
        yMin: 0,
        yMax: 120,
        threshold: 80,
        yLabels: ['0', '30', '60', '90', '120'],
        badgeText: 'High Risk',
      ),
      headAcceleration: _barPoints(
        values: [
          24, 33, 47, 36, 24, 21, 102, 82, 99, 31, 28, 36, 78, 103, 32, 36, 20, 25
        ],
        labels: [
          '10m', '20m', '30m', '40m', '50m', '60m', '70m', '80m', '90m',
          '100m', '110m', '120m', '130m', '140m', '150m', '160m', '170m', '180m'
        ],
        warningThreshold: 80,
      ),
      biteForceSummary: const MetricSummary(
        avg: '',
        min: '',
        max: '',
        yMin: 0,
        yMax: 240,
        threshold: 220,
        yLabels: ['0', '60', '120', '180', '240'],
      ),
      biteForce: _barPoints(
        values: [
          145, 165, 170, 162, 171, 145, 178, 176, 143, 139, 169, 166, 160, 148, 152,
          145, 175, 174, 170, 144, 159
        ],
        labels: [
          '8m', '16m', '24m', '32m', '40m', '48m', '56m', '64m', '72m', '80m', '88m',
          '96m', '104m', '112m', '120m', '128m', '136m', '144m', '152m', '160m', '168m'
        ],
        warningThreshold: 220,
      ),
    );
  }

  AnalyticsBundle _build24HrBundle() {
    return AnalyticsBundle(
      heartRateSummary: const MetricSummary(
        avg: '147',
        min: '45',
        max: '194',
        yMin: 40,
        yMax: 200,
        threshold: 175,
        yLabels: ['40', '93', '146', '200'],
      ),
      heartRate: _barPoints(
        values: List.generate(72, (i) {
          if (i == 25 || i == 63) return 188 + (i % 2) * 4;
          if (i == 0 || i == 14 || i == 26 || i == 38 || i == 67) return 48 + (i % 4);
          return 145 + (i % 9) * 2 - ((i % 4) * 1.5);
        }),
        labels: _hourDenseLabels(72),
        warningThreshold: 175,
      ),
      spo2Summary: const MetricSummary(
        avg: '95',
        min: '',
        max: '',
        yMin: 85,
        yMax: 100,
        threshold: 92,
        yLabels: ['85', '89', '93', '100'],
      ),
      spo2: _barPoints(
        values: List.generate(72, (i) {
          if ([0, 6, 20, 25, 35, 39, 41, 46, 52, 58, 62, 66, 69].contains(i)) {
            return 88.0 + (i % 4);
          }
          return 94.0 + (i % 11) * 0.45;
        }),
        labels: _hourDenseLabels(72),
        isBelowThresholdWarning: true,
        warningThreshold: 92,
      ),
      temperatureSummary: const MetricSummary(
        avg: '',
        min: '',
        max: '',
        yMin: 97,
        yMax: 103,
        threshold: 100.4,
        yLabels: ['97', '99', '101', '103'],
      ),
      temperature: _barPoints(
        values: List.generate(72, (i) {
          if ([20, 21, 27, 28, 29, 31, 37, 49, 53, 56, 58].contains(i)) {
            return 100.5 + ((i % 4) * 0.45);
          }
          return 97.8 + (i % 7) * 0.18;
        }),
        labels: _hourDenseLabels(72),
        warningThreshold: 100.4,
      ),
      headAccelerationSummary: const MetricSummary(
        avg: '',
        min: '',
        max: '108',
        yMin: 0,
        yMax: 120,
        threshold: 80,
        yLabels: ['0', '30', '60', '90', '120'],
        badgeText: 'High Risk',
      ),
      headAcceleration: _barPoints(
        values: List.generate(36, (i) {
          if ([4, 8, 13, 15, 22, 26, 27, 33, 35].contains(i)) return 82 + (i % 6) * 5;
          return 20 + (i % 7) * 7.0;
        }),
        labels: _sparseHourLabels(36),
        warningThreshold: 80,
      ),
      biteForceSummary: const MetricSummary(
        avg: '',
        min: '',
        max: '',
        yMin: 0,
        yMax: 260,
        threshold: 220,
        yLabels: ['0', '65', '130', '195', '260'],
      ),
      biteForce: _barPoints(
        values: List.generate(48, (i) {
          if ([14, 22, 28, 36].contains(i)) return 225.0;
          return 138 + (i % 9) * 4.0;
        }),
        labels: _hourDenseLabels(48),
        warningThreshold: 220,
      ),
    );
  }

  static List<String> _minuteLabels(int count, {required int step}) {
    return List.generate(count, (i) => '${i * step}m');
  }

  static List<String> _hourDenseLabels(int count) {
    return List.generate(count, (i) {
      final hour = ((i * 24) / count).floor();
      return '${hour}h';
    });
  }

  static List<String> _sparseHourLabels(int count) {
    return List.generate(count, (i) {
      final minute = ((i + 1) * 5);
      if (minute >= 60) {
        final hour = (minute / 60).floor();
        return '${hour}h';
      }
      return '${minute}m';
    });
  }

  static List<ChartPoint> _barPoints({
    required List<double> values,
    required List<String> labels,
    required double warningThreshold,
    bool isBelowThresholdWarning = false,
  }) {
    return List.generate(values.length, (i) {
      final value = values[i];
      final warning = isBelowThresholdWarning
          ? value < warningThreshold
          : value > warningThreshold;
      return ChartPoint(
        label: labels[i],
        value: value,
        isWarning: warning,
      );
    });
  }
}

class AnalyticsChartCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<ChartPoint> points;
  final double yMin;
  final double yMax;
  final double threshold;
  final List<String> yLabels;
  final Color normalColor;
  final Color warningColor;
  final Color? iconBg;
  final Color? iconColor;
  final String? badgeText;
  final String Function(ChartPoint point) tooltipLabelBuilder;

  const AnalyticsChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.yMin,
    required this.yMax,
    required this.threshold,
    required this.yLabels,
    required this.normalColor,
    required this.warningColor,
    required this.tooltipLabelBuilder,
    this.iconBg,
    this.iconColor,
    this.badgeText,
  });

  @override
  State<AnalyticsChartCard> createState() => _AnalyticsChartCardState();
}

class _AnalyticsChartCardState extends State<AnalyticsChartCard> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 7,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
              if (widget.badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE9EC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.badgeText!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                )
              else
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: widget.iconBg ?? const Color(0xFFE5ECE8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: widget.iconColor ?? const Color(0xFF166B57),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            widget.subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          _InteractiveBarChart(
            points: widget.points,
            yMin: widget.yMin,
            yMax: widget.yMax,
            threshold: widget.threshold,
            yLabels: widget.yLabels,
            normalColor: widget.normalColor,
            warningColor: widget.warningColor,
            hoveredIndex: _hoveredIndex,
            onHoverIndexChanged: (index) {
              setState(() => _hoveredIndex = index);
            },
            tooltipLabelBuilder: widget.tooltipLabelBuilder,
          ),
        ],
      ),
    );
  }
}

class _InteractiveBarChart extends StatelessWidget {
  final List<ChartPoint> points;
  final double yMin;
  final double yMax;
  final double threshold;
  final List<String> yLabels;
  final Color normalColor;
  final Color warningColor;
  final int? hoveredIndex;
  final ValueChanged<int?> onHoverIndexChanged;
  final String Function(ChartPoint point) tooltipLabelBuilder;

  const _InteractiveBarChart({
    required this.points,
    required this.yMin,
    required this.yMax,
    required this.threshold,
    required this.yLabels,
    required this.normalColor,
    required this.warningColor,
    required this.hoveredIndex,
    required this.onHoverIndexChanged,
    required this.tooltipLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    const chartHeight = 280.0;
    const leftPadding = 46.0;
    const bottomLabelHeight = 28.0;

    final stepX = points.length <= 20
        ? 6.0
        : points.length <= 35
        ? 4.0
        : 2.0;

    return SizedBox(
      height: chartHeight + bottomLabelHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chartWidth = constraints.maxWidth - leftPadding;
          final barSlotWidth = chartWidth / points.length;
          final barWidth = math.max(2.5, barSlotWidth - stepX);

          return Column(
            children: [
              SizedBox(
                height: chartHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: leftPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: yLabels.map((label) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8A8A8A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: MouseRegion(
                        onExit: (_) => onHoverIndexChanged(null),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _ChartGridPainter(
                                  threshold: threshold,
                                  yMin: yMin,
                                  yMax: yMax,
                                  lineCount: yLabels.length,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(points.length, (index) {
                                  final point = points[index];
                                  final normalized = ((point.value - yMin) / (yMax - yMin))
                                      .clamp(0.0, 1.0);
                                  final barHeight = normalized * (chartHeight - 10);

                                  final isHovered = hoveredIndex == index;
                                  final color =
                                  point.isWarning ? warningColor : normalColor;

                                  return MouseRegion(
                                    onEnter: (_) => onHoverIndexChanged(index),
                                    child: GestureDetector(
                                      onTap: () => onHoverIndexChanged(index),
                                      child: Container(
                                        width: chartWidth / points.length,
                                        alignment: Alignment.bottomCenter,
                                        color: Colors.transparent,
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 100),
                                          width: isHovered ? barWidth + 2 : barWidth,
                                          height: math.max(barHeight, 4),
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            if (hoveredIndex != null)
                              _buildTooltip(
                                hoveredIndex!,
                                chartWidth,
                                chartHeight,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: bottomLabelHeight,
                child: Row(
                  children: [
                    SizedBox(width: leftPadding),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _buildBottomLabels(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTooltip(int index, double chartWidth, double chartHeight) {
    final point = points[index];
    final slotWidth = chartWidth / points.length;
    final x = slotWidth * index + (slotWidth / 2);
    final normalized = ((point.value - yMin) / (yMax - yMin)).clamp(0.0, 1.0);
    final y = chartHeight - (normalized * (chartHeight - 10));

    double tooltipLeft = x - 64;
    if (tooltipLeft < 8) tooltipLeft = 8;
    if (tooltipLeft > chartWidth - 140) tooltipLeft = chartWidth - 140;

    double tooltipTop = y - 84;
    if (tooltipTop < 8) tooltipTop = 8;

    return Stack(
      children: [
        Positioned(
          left: x,
          top: 0,
          bottom: 0,
          child: Container(
            width: 3,
            color: const Color(0xFFD0D0D0),
          ),
        ),
        Positioned(
          left: tooltipLeft,
          top: tooltipTop,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 132,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                tooltipLabelBuilder(point),
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Color(0xFF1F1F1F),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  List<Widget> _buildBottomLabels() {
    final length = points.length;
    final indexes = <int>{0};

    if (length <= 16) {
      for (int i = 1; i < length; i++) {
        indexes.add(i);
      }
    } else if (length <= 30) {
      for (int i = 0; i < length; i += 2) {
        indexes.add(i);
      }
    } else if (length <= 40) {
      for (int i = 0; i < length; i += 4) {
        indexes.add(i);
      }
    } else {
      for (int i = 0; i < length; i += math.max(1, (length / 12).floor())) {
        indexes.add(i);
      }
      indexes.add(length - 1);
    }

    final sorted = indexes.toList()..sort();

    return sorted.map((index) {
      return Text(
        points[index].label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF8A8A8A),
          fontWeight: FontWeight.w500,
        ),
      );
    }).toList();
  }
}

class _ChartGridPainter extends CustomPainter {
  final double threshold;
  final double yMin;
  final double yMax;
  final int lineCount;

  _ChartGridPainter({
    required this.threshold,
    required this.yMin,
    required this.yMax,
    required this.lineCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE6E6E6)
      ..strokeWidth = 1;

    final dashPaint = Paint()
      ..color = const Color(0xFFF3A4AA)
      ..strokeWidth = 1.2;

    for (int i = 0; i < lineCount; i++) {
      final y = size.height * (i / (lineCount - 1));
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), gridPaint);
    }

    const verticalLines = 7;
    for (int i = 0; i < verticalLines; i++) {
      final x = size.width * (i / (verticalLines - 1));
      _drawDashedLine(canvas, Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    final thresholdRatio = ((threshold - yMin) / (yMax - yMin)).clamp(0.0, 1.0);
    final thresholdY = size.height - (thresholdRatio * size.height);
    _drawDashedLine(
      canvas,
      Offset(0, thresholdY),
      Offset(size.width, thresholdY),
      dashPaint,
      dashWidth: 6,
      dashGap: 5,
    );
  }

  void _drawDashedLine(
      Canvas canvas,
      Offset start,
      Offset end,
      Paint paint, {
        double dashWidth = 4,
        double dashGap = 4,
      }) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final dashCount = (distance / (dashWidth + dashGap)).floor();

    for (int i = 0; i < dashCount; i++) {
      final x1 = start.dx + (dx / distance) * (i * (dashWidth + dashGap));
      final y1 = start.dy + (dy / distance) * (i * (dashWidth + dashGap));
      final x2 = start.dx + (dx / distance) * (i * (dashWidth + dashGap) + dashWidth);
      final y2 = start.dy + (dy / distance) * (i * (dashWidth + dashGap) + dashWidth);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BottomNavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF166B57) : const Color(0xFFF0EFEA),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF5F5F5F),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF5F5F5F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartPoint {
  final String label;
  final double value;
  final bool isWarning;

  const ChartPoint({
    required this.label,
    required this.value,
    required this.isWarning,
  });
}

class MetricSummary {
  final String avg;
  final String min;
  final String max;
  final double yMin;
  final double yMax;
  final double threshold;
  final List<String> yLabels;
  final String? badgeText;

  const MetricSummary({
    required this.avg,
    required this.min,
    required this.max,
    required this.yMin,
    required this.yMax,
    required this.threshold,
    required this.yLabels,
    this.badgeText,
  });
}

class AnalyticsBundle {
  final MetricSummary heartRateSummary;
  final MetricSummary spo2Summary;
  final MetricSummary temperatureSummary;
  final MetricSummary headAccelerationSummary;
  final MetricSummary biteForceSummary;

  final List<ChartPoint> heartRate;
  final List<ChartPoint> spo2;
  final List<ChartPoint> temperature;
  final List<ChartPoint> headAcceleration;
  final List<ChartPoint> biteForce;

  const AnalyticsBundle({
    required this.heartRateSummary,
    required this.spo2Summary,
    required this.temperatureSummary,
    required this.headAccelerationSummary,
    required this.biteForceSummary,
    required this.heartRate,
    required this.spo2,
    required this.temperature,
    required this.headAcceleration,
    required this.biteForce,
  });
}