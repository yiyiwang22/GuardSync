// lib/pages/services/mock_bluetooth_service.dart
import 'dart:async';
import 'dart:math';
import '../model/athlete_metrics.dart'; 

class MockBluetoothService {
  final Random _random = Random();
  Stream<AthleteMetrics> startSimulatingDevice() {
    return Stream.periodic(const Duration(seconds: 2), (_) {
      
      int heartRate;
      final hrZone = _random.nextDouble();
      if (hrZone < 0.4) heartRate = 120 + _random.nextInt(30);
      else if (hrZone < 0.6) heartRate = 150 + _random.nextInt(16);
      else if (hrZone < 0.8) heartRate = 165 + _random.nextInt(26);
      else heartRate = 191 + _random.nextInt(20);

      int headAccel = 40 + _random.nextInt(60);
      String risk = headAccel > 90 ? 'High' : 'Low';

      return AthleteMetrics(
        heartRate: heartRate,
        bodyTemp: double.parse((97.5 + _random.nextDouble() * 3.5).toStringAsFixed(1)),
        spO2: 90 + _random.nextInt(10),
        biteForce: 120 + _random.nextInt(200),
        headAccel: headAccel,
        concussionRisk: risk,
      );
    });
  }
}