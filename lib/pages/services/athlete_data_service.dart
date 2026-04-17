import 'dart:async';
import 'dart:math';

class AthleteDataService {
  // Singleton instance
  static final AthleteDataService _instance = AthleteDataService._internal();
  factory AthleteDataService() => _instance;
  
  AthleteDataService._internal() {
    _startSimulation();
  }

  // --- Shared Athlete Profile (Synchronized across all screens) ---
  String name = 'John Smith';
  String sex = 'Male';
  String weight = '247 lbs';
  String height = "6' 2''";
  String sport = 'Football';
  String position = 'Quarterback'; // <--- THIS WAS MISSING IN YOUR ERROR
  String activeMinutes = '1H 21M';
  String concussionRisk = 'High';

  // --- Live Metrics ---
  int heartRate = 175;
  double bodyTemp = 98.2;
  int spO2 = 96;
  int biteForce = 162;
  int headAccel = 95;

  final Random _random = Random();
  final _controller = StreamController<void>.broadcast();
  Stream<void> get dataStream => _controller.stream;

  // Global timer: All listeners receive the exact same values at the same time
  void _startSimulation() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      final hrZone = _random.nextDouble();
      if (hrZone < 0.4) heartRate = 120 + _random.nextInt(30);
      else if (hrZone < 0.6) heartRate = 150 + _random.nextInt(16);
      else if (hrZone < 0.8) heartRate = 165 + _random.nextInt(26);
      else heartRate = 191 + _random.nextInt(20);

      final spo2Zone = _random.nextDouble();
      if (spo2Zone < 0.4) spO2 = 95 + _random.nextInt(6);
      else if (spo2Zone < 0.6) spO2 = 93 + _random.nextInt(2);
      else spO2 = 90 + _random.nextInt(3);

      final tempZone = _random.nextDouble();
      bodyTemp = double.parse((97.5 + _random.nextDouble() * 3.5).toStringAsFixed(1));

      final biteZone = _random.nextDouble();
      biteForce = 120 + _random.nextInt(200);

      headAccel = 40 + _random.nextInt(60);
      concussionRisk = headAccel > 90 ? 'High' : 'Low';

      // Notify all subscribers (Athlete and Parent pages)
      _controller.add(null);
    });
  }
}