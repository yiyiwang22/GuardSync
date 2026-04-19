// lib/services/analytics_data_service.dart
import '../model/analytics_models.dart';

class AnalyticsDataService {
  // Singleton pattern
  static final AnalyticsDataService _instance = AnalyticsDataService._internal();
  factory AnalyticsDataService() => _instance;
  AnalyticsDataService._internal();

  // Alert counts for different time ranges
  final Map<String, int> alertCounts = {
    '30min': 7,
    '1hr': 7,
    '3hr': 17,
    '24hr': 62,
  };

  // Pre-calculated data bundles for UI retrieval
  late final Map<String, AnalyticsBundle> _rangeData = {
    '30min': _build30MinBundle(),
    '1hr': _build1HrBundle(),
    '3hr': _build3HrBundle(),
    '24hr': _build24HrBundle(),
  };

  // Fetch data bundle based on the selected time range
  AnalyticsBundle getBundleForRange(String range) {
    return _rangeData[range]!;
  }

  // Fetch alert count based on the selected time range
  int getAlertCountForRange(String range) {
    return alertCounts[range] ?? 0;
  }

  // --- Data Generation Methods (Moved from UI) ---

  AnalyticsBundle _build30MinBundle() {
    return AnalyticsBundle(
      heartRateSummary: const MetricSummary(
        avg: '158', min: '142', max: '187', yMin: 140, yMax: 190, threshold: 175,
        yLabels: ['140', '157', '173', '190'],
      ),
      heartRate: _barPoints(
        values: [162, 158, 150, 181, 181, 159, 157, 153, 149, 164, 159, 150, 158, 148, 155],
        labels: _minuteLabels(15, step: 2), warningThreshold: 175,
      ),
      spo2Summary: const MetricSummary(
        avg: '96', min: '', max: '', yMin: 85, yMax: 100, threshold: 92,
        yLabels: ['85', '89', '93', '100'],
      ),
      spo2: _barPoints(
        values: [97, 90, 96.5, 96.5, 97.2, 97.5, 98.2, 90.5, 98.0, 98.1, 97.8, 94.0, 91.0, 98.4, 94.0],
        labels: _minuteLabels(15, step: 2), isBelowThresholdWarning: true, warningThreshold: 92,
      ),
      temperatureSummary: const MetricSummary(
        avg: '', min: '', max: '', yMin: 97, yMax: 103, threshold: 100.4,
        yLabels: ['97', '99', '101', '103'],
      ),
      temperature: _barPoints(
        values: [98.2, 97.9, 98.0, 98.1, 98.6, 98.6, 98.0, 98.5, 97.9, 97.9, 98.6, 98.4, 98.2, 98.7, 98.2],
        labels: _minuteLabels(15, step: 2), warningThreshold: 100.4,
      ),
      headAccelerationSummary: const MetricSummary(
        avg: '', min: '', max: '102', yMin: 0, yMax: 120, threshold: 80,
        yLabels: ['0', '30', '60', '90', '120'], badgeText: 'High Risk',
      ),
      headAcceleration: _barPoints(
        values: [102, 68, 25, 43, 30, 68],
        labels: ['0m', '5m', '10m', '15m', '20m', '25m'], warningThreshold: 80,
      ),
      biteForceSummary: const MetricSummary(
        avg: '', min: '', max: '', yMin: 0, yMax: 240, threshold: 220,
        yLabels: ['0', '60', '120', '180', '240'],
      ),
      biteForce: _barPoints(
        values: [232, 145, 156, 149, 174, 160, 178, 149, 152, 153],
        labels: ['0m', '3m', '6m', '9m', '12m', '15m', '18m', '21m', '24m', '27m'], warningThreshold: 220,
      ),
    );
  }

  AnalyticsBundle _build1HrBundle() {
    return AnalyticsBundle(
      heartRateSummary: const MetricSummary(
        avg: '154', min: '142', max: '167', yMin: 140, yMax: 170, threshold: 175,
        yLabels: ['140', '150', '160', '170'],
      ),
      heartRate: _barPoints(
        values: [149, 156, 154, 158, 147, 146, 146, 151, 150, 159, 158, 157, 156, 159, 155, 163, 149, 146, 155, 159, 160, 155, 147, 151, 148, 164, 163, 147, 158],
        labels: _minuteLabels(29, step: 2), warningThreshold: 175,
      ),
      spo2Summary: const MetricSummary(
        avg: '96', min: '', max: '', yMin: 85, yMax: 100, threshold: 92,
        yLabels: ['85', '89', '93', '100'],
      ),
      spo2: _barPoints(
        values: [97.2, 96.8, 94.0, 90.0, 97.6, 96.8, 90.2, 97.2, 97.8, 98.6, 98.2, 97.7, 98.0, 98.6, 98.6, 96.1, 94.2, 96.0, 96.2, 94.9, 96.5, 97.2, 94.6, 91.0, 97.4, 97.4, 88.7, 96.0, 96.8],
        labels: _minuteLabels(29, step: 2), isBelowThresholdWarning: true, warningThreshold: 92,
      ),
      temperatureSummary: const MetricSummary(
        avg: '', min: '', max: '', yMin: 97, yMax: 103, threshold: 100.4,
        yLabels: ['97', '99', '101', '103'],
      ),
      temperature: _barPoints(
        values: [98.0, 98.0, 98.1, 98.7, 98.5, 98.4, 98.6, 98.0, 98.6, 98.1, 98.0, 97.9, 97.9, 98.6, 98.5, 98.8, 98.1, 97.8, 98.2, 98.6, 101.2, 98.4, 98.5, 100.7, 98.6, 98.0, 98.4, 98.3, 98.4],
        labels: _minuteLabels(29, step: 2), warningThreshold: 100.4,
      ),
      headAccelerationSummary: const MetricSummary(
        avg: '', min: '', max: '50', yMin: 0, yMax: 60, threshold: 80,
        yLabels: ['0', '15', '30', '45', '60'],
      ),
      headAcceleration: _barPoints(
        values: [28, 42, 30, 20, 22, 44, 50, 43, 30, 32, 25, 41],
        labels: ['0m', '5m', '10m', '15m', '20m', '25m', '30m', '35m', '40m', '45m', '50m', '55m'], warningThreshold: 80,
      ),
      biteForceSummary: const MetricSummary(
        avg: '', min: '', max: '', yMin: 0, yMax: 180, threshold: 220,
        yLabels: ['0', '45', '90', '135', '180'],
      ),
      biteForce: _barPoints(
        values: [148, 174, 172, 168, 173, 143, 150, 176, 154, 166, 145, 165, 167, 143, 177, 172, 147, 178, 157, 176],
        labels: ['3m', '6m', '9m', '12m', '15m', '18m', '21m', '24m', '27m', '30m', '33m', '36m', '39m', '42m', '45m', '48m', '51m', '54m', '57m', '60m'], warningThreshold: 220,
      ),
    );
  }

  AnalyticsBundle _build3HrBundle() {
    return AnalyticsBundle(
      heartRateSummary: const MetricSummary(
        avg: '153', min: '46', max: '194', yMin: 40, yMax: 200, threshold: 175,
        yLabels: ['40', '93', '146', '200'],
      ),
      heartRate: _barPoints(
        values: [150, 144, 134, 140, 146, 134, 155, 143, 132, 130, 194, 136, 193, 148, 150, 131, 149, 155, 140, 151, 146, 143, 144, 146, 149, 194, 130, 152, 134, 145, 47, 151, 161, 158, 132, 153],
        labels: _minuteLabels(36, step: 5), warningThreshold: 175,
      ),
      spo2Summary: const MetricSummary(
        avg: '96', min: '', max: '', yMin: 85, yMax: 100, threshold: 92,
        yLabels: ['85', '89', '93', '100'],
      ),
      spo2: _barPoints(
        values: [95.0, 97.0, 97.5, 95.4, 94.0, 96.4, 95.2, 95.2, 97.2, 93.8, 96.7, 97.6, 95.1, 94.8, 95.0, 97.7, 95.4, 96.0, 94.2, 97.4, 95.6, 95.5, 95.4, 94.7, 94.4, 96.5, 97.6, 94.5, 95.0, 97.5, 97.4, 90.7, 95.5, 96.0, 94.4, 89.8],
        labels: _minuteLabels(36, step: 5), isBelowThresholdWarning: true, warningThreshold: 92,
      ),
      temperatureSummary: const MetricSummary(
        avg: '', min: '', max: '', yMin: 97, yMax: 103, threshold: 100.4,
        yLabels: ['97', '99', '101', '103'],
      ),
      temperature: _barPoints(
        values: [101.8, 97.8, 98.1, 98.8, 98.4, 98.6, 98.5, 101.5, 98.4, 101.2, 98.6, 98.4, 98.7, 98.2, 101.9, 98.9, 98.2, 98.4, 98.1, 97.8, 98.6, 98.4, 98.3, 98.6, 98.7, 98.5, 101.4, 98.6, 97.9, 97.7, 98.8, 98.6, 97.9, 98.1, 98.9, 98.8],
        labels: _minuteLabels(36, step: 5), warningThreshold: 100.4,
      ),
      headAccelerationSummary: const MetricSummary(
        avg: '', min: '', max: '104', yMin: 0, yMax: 120, threshold: 80,
        yLabels: ['0', '30', '60', '90', '120'], badgeText: 'High Risk',
      ),
      headAcceleration: _barPoints(
        values: [24, 33, 47, 36, 24, 21, 102, 82, 99, 31, 28, 36, 78, 103, 32, 36, 20, 25],
        labels: ['10m', '20m', '30m', '40m', '50m', '60m', '70m', '80m', '90m', '100m', '110m', '120m', '130m', '140m', '150m', '160m', '170m', '180m'], warningThreshold: 80,
      ),
      biteForceSummary: const MetricSummary(
        avg: '', min: '', max: '', yMin: 0, yMax: 240, threshold: 220,
        yLabels: ['0', '60', '120', '180', '240'],
      ),
      biteForce: _barPoints(
        values: [145, 165, 170, 162, 171, 145, 178, 176, 143, 139, 169, 166, 160, 148, 152, 145, 175, 174, 170, 144, 159],
        labels: ['8m', '16m', '24m', '32m', '40m', '48m', '56m', '64m', '72m', '80m', '88m', '96m', '104m', '112m', '120m', '128m', '136m', '144m', '152m', '160m', '168m'], warningThreshold: 220,
      ),
    );
  }

  AnalyticsBundle _build24HrBundle() {
    return AnalyticsBundle(
      heartRateSummary: const MetricSummary(
        avg: '147', min: '45', max: '194', yMin: 40, yMax: 200, threshold: 175,
        yLabels: ['40', '93', '146', '200'],
      ),
      heartRate: _barPoints(
        values: List.generate(72, (i) {
          if (i == 25 || i == 63) return 188 + (i % 2) * 4;
          if (i == 0 || i == 14 || i == 26 || i == 38 || i == 67) return 48 + (i % 4);
          return 145 + (i % 9) * 2 - ((i % 4) * 1.5);
        }),
        labels: _hourDenseLabels(72), warningThreshold: 175,
      ),
      spo2Summary: const MetricSummary(
        avg: '95', min: '', max: '', yMin: 85, yMax: 100, threshold: 92,
        yLabels: ['85', '89', '93', '100'],
      ),
      spo2: _barPoints(
        values: List.generate(72, (i) {
          if ([0, 6, 20, 25, 35, 39, 41, 46, 52, 58, 62, 66, 69].contains(i)) return 88.0 + (i % 4);
          return 94.0 + (i % 11) * 0.45;
        }),
        labels: _hourDenseLabels(72), isBelowThresholdWarning: true, warningThreshold: 92,
      ),
      temperatureSummary: const MetricSummary(
        avg: '', min: '', max: '', yMin: 97, yMax: 103, threshold: 100.4,
        yLabels: ['97', '99', '101', '103'],
      ),
      temperature: _barPoints(
        values: List.generate(72, (i) {
          if ([20, 21, 27, 28, 29, 31, 37, 49, 53, 56, 58].contains(i)) return 100.5 + ((i % 4) * 0.45);
          return 97.8 + (i % 7) * 0.18;
        }),
        labels: _hourDenseLabels(72), warningThreshold: 100.4,
      ),
      headAccelerationSummary: const MetricSummary(
        avg: '', min: '', max: '108', yMin: 0, yMax: 120, threshold: 80,
        yLabels: ['0', '30', '60', '90', '120'], badgeText: 'High Risk',
      ),
      headAcceleration: _barPoints(
        values: List.generate(36, (i) {
          if ([4, 8, 13, 15, 22, 26, 27, 33, 35].contains(i)) return 82 + (i % 6) * 5;
          return 20 + (i % 7) * 7.0;
        }),
        labels: _sparseHourLabels(36), warningThreshold: 80,
      ),
      biteForceSummary: const MetricSummary(
        avg: '', min: '', max: '', yMin: 0, yMax: 260, threshold: 220,
        yLabels: ['0', '65', '130', '195', '260'],
      ),
      biteForce: _barPoints(
        values: List.generate(48, (i) {
          if ([14, 22, 28, 36].contains(i)) return 225.0;
          return 138 + (i % 9) * 4.0;
        }),
        labels: _hourDenseLabels(48), warningThreshold: 220,
      ),
    );
  }

  // --- Helper Methods ---

  List<String> _minuteLabels(int count, {required int step}) {
    return List.generate(count, (i) => '${i * step}m');
  }

  List<String> _hourDenseLabels(int count) {
    return List.generate(count, (i) {
      final hour = ((i * 24) / count).floor();
      return '${hour}h';
    });
  }

  List<String> _sparseHourLabels(int count) {
    return List.generate(count, (i) {
      final minute = ((i + 1) * 5);
      if (minute >= 60) {
        final hour = (minute / 60).floor();
        return '${hour}h';
      }
      return '${minute}m';
    });
  }

  List<ChartPoint> _barPoints({
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