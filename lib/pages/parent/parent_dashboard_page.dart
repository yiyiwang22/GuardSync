import 'package:flutter/material.dart';

class ParentDashboardPage extends StatelessWidget {
  const ParentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5F5F0);
    const primaryGreen = Color(0xFF166B57);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD9D4C8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_outline, color: Color(0xFF5B5B5B)),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Parent Dashboard',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCEFEA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bluetooth, color: primaryGreen),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCEFEA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_outline, size: 42, color: primaryGreen),
                    ),
                    const SizedBox(width: 18),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Smith',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F1F1F),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '16 years • Football',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Quarterback',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8A8A8A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EDE8),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Column(
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: Color(0xFFD2DED7),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 52,
                        color: primaryGreen,
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      'CONCUSSION RISK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: Color(0xFF555555),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Low Risk',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: primaryGreen,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Real-time monitoring active',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Row(
                children: [
                  Expanded(child: ParentMetricCard(title: 'Heart Rate', value: '150', unit: 'BPM', icon: Icons.favorite_border)),
                  SizedBox(width: 14),
                  Expanded(child: ParentMetricCard(title: 'Last Impact', value: '44g', unit: '5 min ago', icon: Icons.monitor_heart_outlined)),
                ],
              ),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Expanded(child: ParentMetricCard(title: 'SpO2', value: '96', unit: '%', icon: Icons.air)),
                  SizedBox(width: 14),
                  Expanded(child: ParentMetricCard(title: 'Body Temp', value: '98.9', unit: '°F', icon: Icons.thermostat_outlined)),
                ],
              ),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Expanded(child: ParentMetricCard(title: 'Bite Force', value: '178', unit: 'N', icon: Icons.sports_mma_outlined)),
                  SizedBox(width: 14),
                  Expanded(child: ParentMetricCard(title: 'Head Accel', value: '60', unit: 'g', icon: Icons.warning_amber_outlined)),
                ],
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFFDCEFEA),
                      child: Icon(Icons.bluetooth, color: primaryGreen),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Device Status',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Connected & Monitoring',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: primaryGreen,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD0CCC2)),
                ),
                child: const Text(
                  'This is a read-only view. Contact your athlete to update profile information.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          decoration: const BoxDecoration(
            color: Color(0xFFF8F8F6),
            border: Border(
              top: BorderSide(color: Color(0xFFE5E2DA)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _BottomNavButton(
                  label: 'Dashboard',
                  icon: Icons.dashboard_outlined,
                  isSelected: true,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BottomNavButton(
                  label: 'History',
                  icon: Icons.show_chart_outlined,
                  isSelected: false,
                  onTap: () {
                    Navigator.pushNamed(context, '/parent-analytics');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParentMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;

  const ParentMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF166B57);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryGreen),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF777777),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8B8B8B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF166B57) : const Color(0xFFF0EFEA),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF5F5F5F),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF5F5F5F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}