// lib/models/analytics_models.dart

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