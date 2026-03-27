import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with TickerProviderStateMixin {
  int _step = 0;
  double _progress = 0;
  
  // Animation controllers for various effects
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _checkScaleController;

  @override
  void initState() {
    super.initState();

    // Pulse animation for Step 0
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Rotation animation for Step 1
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Spring animation for Step 2 checkmark
    _checkScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _startStepSequence();
  }

  // Logic to handle auto-advancing steps and progress bar
  void _startStepSequence() {
    // Step 0 -> Step 1 after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _step = 1);
        _startProgressBar();
      }
    });
  }

  void _startProgressBar() {
    // Progress interval (mimicking interval in React)
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (!mounted || _step != 1) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_progress >= 100) {
          timer.cancel();
          // Delay briefly before moving to success step
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() => _step = 2);
              _checkScaleController.forward();
            }
          });
        } else {
          _progress += 2;
        }
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _checkScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildStepIndicators(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                // Transition builder mimics the x: 50 exit/entry in React
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.2, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _buildCurrentStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

Widget _buildStepIndicators() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(3, (i) {
          return [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFC5C3B8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _step >= i ? 1.0 : 0.0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A5C4C),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            // Add 8px gap between indicators, but not after the last one
            if (i < 2) const SizedBox(width: 8),
          ];
        }).expand((widgetList) => widgetList).toList(),
      ),
    );
  }
  Widget _buildCurrentStep() {
    switch (_step) {
      case 0:
        return _buildSearchingStep();
      case 1:
        return _buildFoundStep();
      case 2:
        return _buildSuccessStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 0: Searching
  Widget _buildSearchingStep() {
    return Column(
      key: const ValueKey('searching'),
      children: [
        const SizedBox(height: 32),
        const Text('Searching for a new device...', 
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const Spacer(),
        _buildPulsingCircle(
          child: Image.network(
            'https://placeholder.com/device_img', // Replace with your asset
            width: 112, height: 112,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.bluetooth_searching, size: 60, color: Colors.white),
          ),
        ),
        const Spacer(),
        _buildFooterInfo("Can't find your device?", "Make sure it is powered on and close for pairing"),
      ],
    );
  }

  // Step 1: Device Found
  Widget _buildFoundStep() {
    return Column(
      key: const ValueKey('found'),
      children: [
        const SizedBox(height: 32),
        const Text('Device Found', 
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const Spacer(),
        _buildStaticCircle(
          child: RotationTransition(
            turns: Tween<double>(begin: -0.02, end: 0.02).animate(_rotateController),
            child: const Icon(Icons.bluetooth_connected, size: 80, color: Colors.white),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const Text('Preparing to pair...', style: TextStyle(color: Color(0xFF1A1A1A))),
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
              const SizedBox(height: 8),
              const Text('This may take a minute.', style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
            ],
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  // Step 2: Success
  Widget _buildSuccessStep() {
    return Column(
      key: const ValueKey('success'),
      children: [
        const SizedBox(height: 32),
        const Text("You're all set!", 
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        const Spacer(),
        _buildStaticCircle(
          child: ScaleTransition(
            scale: CurvedAnimation(parent: _checkScaleController, curve: Curves.elasticOut),
            child: const Icon(Icons.check_rounded, size: 100, color: Colors.white),
          ),
        ),
        const Spacer(),
        const Text('Your Device is now paired\nand Ready to use.', 
          textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF1A1A1A), height: 1.5)),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/calibration-flow'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A5C4C),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // --- Animation Helpers ---

  Widget _buildPulsingCircle({required Widget child}) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(width: 220, height: 220, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2D8A6E).withOpacity(0.2 * (1 - _pulseController.value)))),
            Transform.scale(scale: 1.0 + (_pulseController.value * 0.15), child: Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2D8A6E).withOpacity(0.3)))),
            Container(width: 140, height: 140, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF1A5C4C)), child: child),
          ],
        );
      },
    );
  }

  Widget _buildStaticCircle({required Widget child}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(width: 220, height: 220, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2D8A6E).withOpacity(0.2))),
        Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2D8A6E).withOpacity(0.3))),
        Container(width: 140, height: 140, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF1A5C4C)), child: child),
      ],
    );
  }

  Widget _buildFooterInfo(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.info_outline, size: 16, color: Color(0xFF555555)),
            const SizedBox(width: 4),
            Text(title, style: const TextStyle(fontSize: 14, color: Color(0xFF555555))),
          ]),
          const SizedBox(height: 4),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
        ],
      ),
    );
  }
}