// lib/pages/services/athlete_data_service.dart
import 'dart:async';
import '../model/athlete_metrics.dart';
import 'mock_bluetooth_service.dart';

class AthleteDataService {
  static final AthleteDataService _instance = AthleteDataService._internal();
  factory AthleteDataService() => _instance;

  final MockBluetoothService _bluetoothMock = MockBluetoothService();
  StreamSubscription? _deviceSubscription;

  String name = 'John Smith';
  String sex = 'Male';
  String weight = '247 lbs';
  String height = "6' 2''";
  String sport = 'Football';
  String position = 'Quarterback';
  String activeMinutes = '1H 21M';

  AthleteMetrics? currentMetrics;

  final _controller = StreamController<void>.broadcast();
  Stream<void> get dataStream => _controller.stream;

  AthleteDataService._internal() {
    _connectToDevice();
  }

  void _connectToDevice() {
    _deviceSubscription = _bluetoothMock.startSimulatingDevice().listen((newData) {
      currentMetrics = newData; 
      
      // FirebaseFirestore.instance.collection('athletes').doc('john_smith').update(newData.toMap());

      _controller.add(null); 
    });
  }
}