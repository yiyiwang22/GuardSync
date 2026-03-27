import 'package:flutter/material.dart';
import 'dart:async';

class CalibrationFlowPage extends StatefulWidget {
  const CalibrationFlowPage({super.key});

  @override
  State<CalibrationFlowPage> createState() => _CalibrationFlowPageState();
}

class _CalibrationFlowPageState extends State<CalibrationFlowPage> with TickerProviderStateMixin {
  int _step = 0;
  int _countdown = 10;
  double _progress = 0;
  
  // Vitals animation values
  double _heartRate = 0;
  double _bodyTemp = 0;
  double _spO2 = 0;

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- Logic Controllers for each step ---

  void _startBiteForceCalibration() {
    _progress = 0;
    _countdown = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown <= 1) {
          _countdown = 0;
          _progress = 100;
          timer.cancel();
        } else {
          _countdown--;
          _progress += 10;
        }
      });
    });
  }

  void _startRestingJawCalibration() {
    _progress = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_progress >= 100) {
          _progress = 100;
          timer.cancel();
        } else {
          _progress += 3.33;
        }
      });
    });
  }

  void _startVitalsCapture() {
    _heartRate = 0;
    _bodyTemp = 0;
    _spO2 = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        bool hrDone = _heartRate >= 68;
        bool tempDone = _bodyTemp >= 98.1;
        bool spO2Done = _spO2 >= 98;

        if (hrDone && tempDone && spO2Done) {
          timer.cancel();
        } else {
          if (!hrDone) _heartRate += 2;
          if (!tempDone) _bodyTemp = double.parse((_bodyTemp + 0.5).toStringAsFixed(1));
          if (!spO2Done) _spO2 += 3;
          
          // Clamp values
          if (_heartRate > 68) _heartRate = 68;
          if (_bodyTemp > 98.1) _bodyTemp = 98.1;
          if (_spO2 > 98) _spO2 = 98;
        }
      });
    });
  }

  void _handleNext() {
    setState(() {
      _step++;
      _timer?.cancel();
      if (_step == 1) _startBiteForceCalibration();
      if (_step == 2) _startRestingJawCalibration();
      if (_step == 3) _startVitalsCapture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildStepIndicators(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _buildCurrentStepView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Views for Steps ---

  Widget _buildCurrentStepView() {
    switch (_step) {
      case 0: return _buildIntroStep();
      case 1: return _buildBiteForceStep();
      case 2: return _buildRestingJawStep();
      case 3: return _buildVitalsStep();
      case 4: return _buildCompleteStep();
      default: return const SizedBox.shrink();
    }
  }

  // Step 0: Intro
  Widget _buildIntroStep() {
    return _buildBaseStepLayout(
      key: "intro",
      title: "Device Calibration",
      description: "We need to calibrate your mouthguard to your baseline before use.",
      content: _buildMouthguardVisual(),
      buttonLabel: "Start Calibration",
      onButtonPressed: _handleNext,
    );
  }

  // Step 1: Bite Force
  Widget _buildBiteForceStep() {
    return _buildBaseStepLayout(
      key: "bite",
      title: "Bite Force Calibration",
      description: "Bite down as hard as you can for 10 seconds",
      content: Column(
        children: [
          _buildCircleContainer(
            child: _countdown > 0 
              ? Text("$_countdown", style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white))
              : CustomPaint(size: const Size(40, 48), painter: ToothPainter()),
          ),
          const SizedBox(height: 32),
          _buildProgressBar(_countdown > 0 ? 'Measuring bite force...' : 'Max Bite Force Recorded'),
        ],
      ),
      buttonLabel: "Next",
      showButton: _countdown == 0,
      onButtonPressed: _handleNext,
    );
  }

  // Step 2: Resting Jaw
  Widget _buildRestingJawStep() {
    return _buildBaseStepLayout(
      key: "resting",
      title: "Resting Jaw Calibration",
      description: "Keep your teeth lightly touching without applying pressure",
      content: Column(
        children: [
          _buildCircleContainer(
            child: CustomPaint(size: const Size(40, 48), painter: ToothPainter()),
          ),
          const SizedBox(height: 32),
          _buildProgressBar(_progress < 100 ? 'Measuring baseline...' : 'Baseline jaw pressure recorded'),
        ],
      ),
      buttonLabel: "Next",
      showButton: _progress >= 100,
      onButtonPressed: _handleNext,
    );
  }

  // Step 3: Vitals
  Widget _buildVitalsStep() {
    bool isDone = _heartRate >= 68 && _bodyTemp >= 98.1 && _spO2 >= 98;
    return _buildBaseStepLayout(
      key: "vitals",
      title: "Capturing Baseline Metrics",
      description: "Recording your normal values...",
      content: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _buildVitalCard("Heart Rate", "${_heartRate.toInt()} BPM", Icons.favorite_border),
          _buildVitalCard("Body Temp", "${_bodyTemp.toStringAsFixed(1)}°F", Icons.thermostat),
          _buildVitalCard("SpO2", "${_spO2.toInt()}%", Icons.bubble_chart_outlined),
        ],
      ),
      buttonLabel: "Next",
      showButton: isDone,
      onButtonPressed: _handleNext,
    );
  }

  // Step 4: Completion
  Widget _buildCompleteStep() {
    return _buildBaseStepLayout(
      key: "complete",
      title: "You're All Set",
      description: "Your device is now calibrated and ready to use.",
      content: _buildCircleContainer(child: const Icon(Icons.check_rounded, size: 80, color: Colors.white)),
      buttonLabel: "Continue to Dashboard",
      onButtonPressed: () => Navigator.pushNamed(context, '/dashboard'),
    );
  }

  // --- Reusable UI Elements ---

  Widget _buildStepIndicators() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(5, (i) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Stack(
                children: [
                  Container(height: 4, decoration: BoxDecoration(color: const Color(0xFFC5C3B8), borderRadius: BorderRadius.circular(4))),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: 4,
                    width: _step >= i ? 1000 : 0, // Fill if step reached
                    decoration: BoxDecoration(color: const Color(0xFF1A5C4C), borderRadius: BorderRadius.circular(4)),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBaseStepLayout({
    required String key,
    required String title,
    required String description,
    required Widget content,
    required String buttonLabel,
    required VoidCallback onButtonPressed,
    bool showButton = true,
  }) {
    return Padding(
      key: ValueKey(key),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 12),
          Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Color(0xFF555555))),
          const Spacer(),
          content,
          const Spacer(),
          if (showButton)
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A5C4C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(buttonLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF1A5C4C), fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _progress / 100,
            minHeight: 8,
            backgroundColor: const Color(0xFFC5C3B8),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1A5C4C)),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleContainer({required Widget child}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(width: 220, height: 220, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2D8A6E).withOpacity(0.2))),
        Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2D8A6E).withOpacity(0.3))),
        Container(width: 140, height: 140, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF1A5C4C)), child: Center(child: child)),
      ],
    );
  }

  Widget _buildMouthguardVisual() {
    return _buildCircleContainer(
      child: const Icon(Icons.bluetooth_searching, size: 60, color: Colors.white), // Placeholder for mouthguardImg
    );
  }

  Widget _buildVitalCard(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF1A5C4C), size: 28),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF666666))),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        ],
      ),
    );
  }
}

// --- Custom Painters for SVG replication ---

class ToothPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.25, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.5, 0, size.width * 0.75, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.5, size.width * 0.75, size.height * 0.8);
    path.lineTo(size.width * 0.6, size.height * 0.9);
    path.lineTo(size.width * 0.5, size.height * 0.75);
    path.lineTo(size.width * 0.4, size.height * 0.9);
    path.lineTo(size.width * 0.25, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.5, size.width * 0.25, size.height * 0.2);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}