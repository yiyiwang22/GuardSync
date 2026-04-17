import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

const Map<String, Map<String, String>> metricInfo = {
  'heartRate': {
    'title': 'Heart Rate',
    'measures': 'Heart beats per minute.',
    'colorMeans':
    'Green indicates safe activity.\nYellow indicates moderate exertion.\nOrange indicates high exertion.\nRed indicates dangerous or abnormal.',
    'acceptableRanges':
    'Green < 150, Yellow 150-165, Orange 165-190, Red > 190.',
    'standard': 'Uses the standard 5-zone exercise intensity model.',
  },
  'spO2': {
    'title': 'Blood Oxygen',
    'measures': 'Percentage of oxygen saturation in blood.',
    'colorMeans':
    'Green indicates normal oxygen levels.\nYellow indicates mild oxygen desaturation.\nOrange indicates moderate desaturation.\nRed indicates critically low levels.',
    'acceptableRanges':
    'Green 95-100%, Yellow 93-94%, Orange 92%, Red < 92%.',
    'standard': 'Uses clinical oxygen saturation standards.',
  },
  'bodyTemp': {
    'title': 'Body Temperature',
    'measures': 'Core body temperature in degrees Fahrenheit.',
    'colorMeans':
    'Green indicates normal temperature.\nYellow indicates slightly elevated.\nOrange indicates fever/high exertion.\nRed indicates risk of heat illness.',
    'acceptableRanges':
    'Green 97-99.5°F, Yellow 99.6-99.9°F, Orange 100-100.4°F, Red > 100.4°F.',
    'standard':
    'Uses clinical body temperature guidelines for athletic activity.',
  },
  'biteForce': {
    'title': 'Bite Force',
    'measures':
    'Pressure exerted when clenching jaw, measured in Newtons.',
    'colorMeans':
    'Green indicates normal jaw tension.\nYellow indicates mild clenching.\nOrange indicates significant stress.\nRed indicates risk of dental or jaw damage.',
    'acceptableRanges':
    'Green < 200N, Yellow 200-250N, Orange 250-300N, Red > 300N.',
    'standard': 'Uses biomechanical jaw force standards.',
  },
};

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Timer? _timer;
  final Random _random = Random();

  int heartRate = 175;
  double bodyTemp = 98.2;
  int spO2 = 96;
  int biteForce = 162;

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        final hrZone = _random.nextDouble();
        if (hrZone < 0.4) {
          heartRate = 120 + _random.nextInt(30);
        } else if (hrZone < 0.6) {
          heartRate = 150 + _random.nextInt(16);
        } else if (hrZone < 0.8) {
          heartRate = 165 + _random.nextInt(26);
        } else {
          heartRate = 191 + _random.nextInt(20);
        }

        final spo2Zone = _random.nextDouble();
        if (spo2Zone < 0.4) {
          spO2 = 95 + _random.nextInt(6);
        } else if (spo2Zone < 0.6) {
          spO2 = 93 + _random.nextInt(2);
        } else if (spo2Zone < 0.8) {
          spO2 = 92;
        } else {
          spO2 = 88 + _random.nextInt(4);
        }

        final tempZone = _random.nextDouble();
        if (tempZone < 0.4) {
          bodyTemp =
              double.parse((97 + _random.nextDouble() * 2.5).toStringAsFixed(1));
        } else if (tempZone < 0.6) {
          bodyTemp =
              double.parse((99.6 + _random.nextDouble() * 0.4).toStringAsFixed(1));
        } else if (tempZone < 0.8) {
          bodyTemp =
              double.parse((100 + _random.nextDouble() * 0.5).toStringAsFixed(1));
        } else {
          bodyTemp = double.parse(
            (100.5 + _random.nextDouble() * 1.5).toStringAsFixed(1),
          );
        }

        final biteZone = _random.nextDouble();
        if (biteZone < 0.4) {
          biteForce = 120 + _random.nextInt(80);
        } else if (biteZone < 0.6) {
          biteForce = 200 + _random.nextInt(51);
        } else if (biteZone < 0.8) {
          biteForce = 250 + _random.nextInt(51);
        } else {
          biteForce = 301 + _random.nextInt(100);
        }
      });
    });
  }

  Color getHeartRateColor(int hr) {
    if (hr >= 190) return const Color(0xFFE63946);
    if (hr >= 165) return const Color(0xFFF77F00);
    if (hr >= 150) return const Color(0xFFFBBF24);
    return const Color(0xFF1A5C4C);
  }

  Color getSpO2Color(int spo2) {
    if (spo2 < 92) return const Color(0xFFE63946);
    if (spo2 == 92) return const Color(0xFFF77F00);
    if (spo2 < 95) return const Color(0xFFFBBF24);
    return const Color(0xFF1A5C4C);
  }

  Color getTempColor(double temp) {
    if (temp > 100.4) return const Color(0xFFE63946);
    if (temp >= 100) return const Color(0xFFF77F00);
    if (temp > 99.5) return const Color(0xFFFBBF24);
    return const Color(0xFF1A5C4C);
  }

  Color getBiteForceColor(int force) {
    if (force > 300) return const Color(0xFFE63946);
    if (force >= 250) return const Color(0xFFF77F00);
    if (force >= 200) return const Color(0xFFFBBF24);
    return const Color(0xFF1A5C4C);
  }

  void _showInfoDialog(String metricKey) {
    final info = metricInfo[metricKey]!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.all(24),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF1A5C4C),
                    size: 24,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                info['title']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  height: 1.2,
                ),
                softWrap: true,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModalSection('Measures:', info['measures']!),
                _buildModalSection('Color Means:', info['colorMeans']!),
                _buildModalSection(
                  'Acceptable Ranges:',
                  info['acceptableRanges']!,
                ),
                _buildModalSection('Standard:', info['standard']!),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A5C4C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Got it',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFF555555),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _openHistory() {
    Navigator.pushNamed(context, '/trainer-analytics');
  }

  void _openConnections() {
    Navigator.pushNamed(context, '/athlete-connections');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD4D2C5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'John Smith',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _openConnections,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD4D2C5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.link,
                            color: Color(0xFF1A5C4C),
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD4D2C5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bluetooth,
                          color: Color(0xFF1A5C4C),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFD4D2C5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'Status: ',
                          style: TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: 'Connected',
                              style: TextStyle(
                                color: Color(0xFF1A5C4C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Sex: Male',
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weight: 247 lbs',
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Height: 6' 2''",
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _buildMetricCard(
                    'Sport',
                    'Football',
                    Icons.directions_run,
                    const Color(0xFF1A5C4C),
                    null,
                  ),
                  _buildMetricCard(
                    'Active Minutes',
                    '1H 21M',
                    Icons.hourglass_empty,
                    const Color(0xFF1A5C4C),
                    null,
                  ),
                  _buildMetricCard(
                    'Head Acceleration',
                    '95g',
                    Icons.sports_motorsports,
                    const Color(0xFF1A5C4C),
                    null,
                  ),
                  _buildMetricCard(
                    'Concussion Risk',
                    'High',
                    Icons.warning_amber_rounded,
                    const Color(0xFFE63946),
                    null,
                  ),
                  _buildMetricCard(
                    'Heart Rate',
                    '$heartRate BPM',
                    Icons.favorite,
                    getHeartRateColor(heartRate),
                    'heartRate',
                  ),
                  _buildMetricCard(
                    'SpO2',
                    '$spO2%',
                    O2Icon(color: getSpO2Color(spO2)),
                    getSpO2Color(spO2),
                    'spO2',
                  ),
                  _buildMetricCard(
                    'Body Temperature',
                    '$bodyTemp °F',
                    Icons.thermostat,
                    getTempColor(bodyTemp),
                    'bodyTemp',
                  ),
                  _buildMetricCard(
                    'Bite Force',
                    '$biteForce N',
                    ToothIcon(color: getBiteForceColor(biteForce)),
                    getBiteForceColor(biteForce),
                    'biteForce',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFDDDDDD))),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A5C4C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.dashboard, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _openHistory,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: Color(0xFF555555),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'History',
                          style: TextStyle(
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      String label,
      String value,
      dynamic icon,
      Color valueColor,
      String? infoKey,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (infoKey != null)
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF999999),
                  size: 18,
                ),
                onPressed: () => _showInfoDialog(infoKey),
              ),
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: icon is IconData ? Icon(icon, color: valueColor, size: 32) : icon as Widget,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class O2Icon extends StatelessWidget {
  final Color color;
  const O2Icon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'O',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: color,
          height: 1.1,
        ),
        children: [
          WidgetSpan(
            child: Transform.translate(
              offset: const Offset(1, 6),
              child: Text(
                '2',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ToothIcon extends StatelessWidget {
  final Color color;
  const ToothIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(28, 32),
      painter: _ToothPainter(color: color),
    );
  }
}

class _ToothPainter extends CustomPainter {
  final Color color;
  _ToothPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(8, 8);
    path.cubicTo(8, 2, 16, 2, 16, 6);
    path.cubicTo(16, 2, 24, 2, 24, 8);
    path.cubicTo(24, 16, 28, 18, 24, 26);
    path.cubicTo(22, 32, 18, 30, 16, 22);
    path.cubicTo(14, 30, 10, 32, 8, 26);
    path.cubicTo(4, 18, 8, 16, 8, 8);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}