// lib/pages/model/athlete_metrics.dart

class AthleteMetrics {
  final int heartRate;
  final double bodyTemp;
  final int spO2;
  final int biteForce;
  final int headAccel;
  final String concussionRisk;

  AthleteMetrics({
    required this.heartRate,
    required this.bodyTemp,
    required this.spO2,
    required this.biteForce,
    required this.headAccel,
    required this.concussionRisk,
  });
}