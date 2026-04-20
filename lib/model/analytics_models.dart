// lib/model/analytics_models.dart

class ChartPoint {
  final String label;
  final double value;
  final bool isWarning;

  const ChartPoint({
    required this.label,
    required this.value,
    required this.isWarning,
  });

  // Convert Firebase Map to ChartPoint object
  factory ChartPoint.fromMap(Map<String, dynamic> map) {
    return ChartPoint(
      label: map['label']?.toString() ?? '',
      value: (map['value'] as num).toDouble(),
      isWarning: map['isWarning'] ?? false,
    );
  }
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

  // Convert Firebase Map to MetricSummary object
  factory MetricSummary.fromMap(Map<String, dynamic> map) {
    return MetricSummary(
      avg: map['avg']?.toString() ?? '',
      min: map['min']?.toString() ?? '',
      max: map['max']?.toString() ?? '',
      yMin: (map['yMin'] as num).toDouble(),
      yMax: (map['yMax'] as num).toDouble(),
      threshold: (map['threshold'] as num).toDouble(),
      yLabels: List<String>.from(map['yLabels'] ?? []),
      badgeText: map['badgeText'],
    );
  }
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

  // Convert the whole Firebase document Map to a full AnalyticsBundle
  factory AnalyticsBundle.fromMap(Map<String, dynamic> map) {
    return AnalyticsBundle(
      heartRateSummary: MetricSummary.fromMap(map['heartRateSummary']),
      spo2Summary: MetricSummary.fromMap(map['spo2Summary']),
      temperatureSummary: MetricSummary.fromMap(map['temperatureSummary']),
      headAccelerationSummary: MetricSummary.fromMap(map['headAccelerationSummary']),
      biteForceSummary: MetricSummary.fromMap(map['biteForceSummary']),
      
      heartRate: (map['heartRatePoints'] as List).map((p) => ChartPoint.fromMap(p)).toList(),
      spo2: (map['spo2Points'] as List).map((p) => ChartPoint.fromMap(p)).toList(),
      temperature: (map['temperaturePoints'] as List).map((p) => ChartPoint.fromMap(p)).toList(),
      headAcceleration: (map['headAccelerationPoints'] as List).map((p) => ChartPoint.fromMap(p)).toList(),
      biteForce: (map['biteForcePoints'] as List).map((p) => ChartPoint.fromMap(p)).toList(),
    );
  }
}