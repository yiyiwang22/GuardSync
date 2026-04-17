import 'package:flutter/material.dart';
import 'dart:async';
import '../services/athlete_data_service.dart';

import '../dashboard_page.dart'; 

class ParentDashboardPage extends StatefulWidget {
  const ParentDashboardPage({super.key});

  @override
  State<ParentDashboardPage> createState() => _ParentDashboardPageState();
}

class _ParentDashboardPageState extends State<ParentDashboardPage> {
  final AthleteDataService _service = AthleteDataService();
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = _service.dataStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  const Icon(Icons.info_outline, color: Color(0xFF1A5C4C), size: 24),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(info['title']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A), height: 1.2), softWrap: true),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModalSection('Measures:', info['measures']!),
                _buildModalSection('Color Means:', info['colorMeans']!),
                _buildModalSection('Acceptable Ranges:', info['acceptableRanges']!),
                _buildModalSection('Standard:', info['standard']!),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A5C4C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Got it', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A), fontSize: 14)),
        const SizedBox(height: 4),
        Text(content, style: const TextStyle(color: Color(0xFF555555), fontSize: 14, height: 1.4)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5F5F0);
    const primaryGreen = Color(0xFF166B57); // 家长端原本的深绿色

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(width: 58, height: 58, decoration: const BoxDecoration(color: Color(0xFFD9D4C8), shape: BoxShape.circle), child: const Icon(Icons.person_outline, color: Color(0xFF5B5B5B))),
                const SizedBox(width: 14),
                const Expanded(child: Text('Parent Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1F1F1F)))),
                Container(width: 58, height: 58, decoration: const BoxDecoration(color: Color(0xFFDCEFEA), shape: BoxShape.circle), child: const Icon(Icons.bluetooth, color: primaryGreen)),
              ]),

              const SizedBox(height: 22),

              Container(
                width: double.infinity, padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(24)),
                child: Row(children: [
                  Container(width: 84, height: 84, decoration: const BoxDecoration(color: Color(0xFFDCEFEA), shape: BoxShape.circle), child: const Icon(Icons.person_outline, size: 42, color: primaryGreen)),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(_service.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1F1F1F))),
                      const SizedBox(height: 6),
                      Text('16 years • ${_service.sport}', style: const TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(_service.position, style: const TextStyle(fontSize: 14, color: Color(0xFF8A8A8A), fontWeight: FontWeight.w500)),
                    ]),
                  ),
                ]),
              ),

              const SizedBox(height: 22),

              Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                decoration: BoxDecoration(color: const Color(0xFFE7EDE8), borderRadius: BorderRadius.circular(26)),
                child: Column(children: [
                  CircleAvatar(radius: 54, backgroundColor: const Color(0xFFD2DED7), child: Icon(Icons.warning_amber_rounded, size: 52, color: _service.concussionRisk == 'High' ? const Color(0xFFE63946) : primaryGreen)),
                  const SizedBox(height: 18),
                  const Text('CONCUSSION RISK', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: Color(0xFF555555))),
                  const SizedBox(height: 10),
                  Text(_service.concussionRisk == 'High' ? 'High Risk' : 'Low Risk', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _service.concussionRisk == 'High' ? const Color(0xFFE63946) : primaryGreen)),
                  const SizedBox(height: 6),
                  const Text('Real-time monitoring active', style: TextStyle(fontSize: 14, color: Color(0xFF757575), fontWeight: FontWeight.w500)),
                ]),
              ),

              const SizedBox(height: 22),

          
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _buildMirroredCard('Sport', _service.sport, Icons.directions_run, const Color(0xFF1A5C4C), null),
                  _buildMirroredCard('Active Minutes', _service.activeMinutes, Icons.hourglass_empty, const Color(0xFF1A5C4C), null),
                  _buildMirroredCard('Head Acceleration', '${_service.headAccel}g', Icons.sports_motorsports, const Color(0xFF1A5C4C), null),
                  _buildMirroredCard('Concussion Risk', _service.concussionRisk, Icons.warning_amber_rounded, _service.concussionRisk == 'High' ? const Color(0xFFE63946) : const Color(0xFF1A5C4C), null),
                  _buildMirroredCard('Heart Rate', '${_service.heartRate} BPM', Icons.favorite, getHeartRateColor(_service.heartRate), 'heartRate'),
                  _buildMirroredCard('SpO2', '${_service.spO2}%', O2Icon(color: getSpO2Color(_service.spO2)), getSpO2Color(_service.spO2), 'spO2'),
                  _buildMirroredCard('Body Temperature', '${_service.bodyTemp} °F', Icons.thermostat, getTempColor(_service.bodyTemp), 'bodyTemp'),
                  _buildMirroredCard('Bite Force', '${_service.biteForce} N', ToothIcon(color: getBiteForceColor(_service.biteForce)), getBiteForceColor(_service.biteForce), 'biteForce'),
                ],
              ),

              const SizedBox(height: 18),

             
              Container(
                width: double.infinity, padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(24)),
                child: const Row(children: [
                  CircleAvatar(radius: 30, backgroundColor: Color(0xFFDCEFEA), child: Icon(Icons.bluetooth, color: primaryGreen)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Device Status', style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w600)),
                      SizedBox(height: 6),
                      Text('Connected & Monitoring', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: primaryGreen)),
                    ]),
                  ),
                  CircleAvatar(radius: 8, backgroundColor: primaryGreen),
                ]),
              ),

              const SizedBox(height: 18),


              Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.65), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFD0CCC2))),
                child: const Text('This is a read-only view. Contact your athlete to update profile information.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, height: 1.4, color: Color(0xFF666666), fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
     
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          decoration: const BoxDecoration(color: Color(0xFFF8F8F6), border: Border(top: BorderSide(color: Color(0xFFE5E2DA)))),
          child: Row(children: [
            Expanded(child: _BottomNavButton(label: 'Dashboard', icon: Icons.dashboard_outlined, isSelected: true, onTap: () {})),
            const SizedBox(width: 12),
            Expanded(child: _BottomNavButton(label: 'History', icon: Icons.show_chart_outlined, isSelected: false, onTap: () => Navigator.pushNamed(context, '/parent-analytics'))),
          ]),
        ),
      ),
    );
  }


  Widget _buildMirroredCard(String label, String value, dynamic icon, Color valueColor, String? infoKey) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Stack(children: [
        if (infoKey != null)
          Positioned(
            top: 4, right: 4,
            child: IconButton(
              icon: const Icon(Icons.info_outline, color: Color(0xFF999999), size: 18),
              onPressed: () => _showInfoDialog(infoKey),
            ),
          ),
        Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            icon is IconData ? Icon(icon, color: valueColor, size: 32) : icon as Widget,
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Color(0xFF666666), fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: valueColor, fontSize: 20, fontWeight: FontWeight.bold)),
          ]),
        ),
      ]),
    );
  }
}


class _BottomNavButton extends StatelessWidget {
  final String label; final IconData icon; final bool isSelected; final VoidCallback onTap;
  const _BottomNavButton({required this.label, required this.icon, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 62,
        decoration: BoxDecoration(color: isSelected ? const Color(0xFF166B57) : const Color(0xFFF0EFEA), borderRadius: BorderRadius.circular(18)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: isSelected ? Colors.white : const Color(0xFF5F5F5F)),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : const Color(0xFF5F5F5F))),
        ]),
      ),
    );
  }
}