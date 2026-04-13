import 'package:flutter/material.dart';

class TrainerDashboardPage extends StatefulWidget {
  const TrainerDashboardPage({super.key});

  @override
  State<TrainerDashboardPage> createState() => _TrainerDashboardPageState();
}

class _TrainerDashboardPageState extends State<TrainerDashboardPage> {
  int _selectedBottomNavIndex = 0;
  String _selectedFilter = 'all';

  final List<Athlete> _athletes = const [
    Athlete(
      name: 'Alex Martinez',
      role: 'Quarterback',
      eventText: 'Impact Event Detected',
      riskLevel: RiskLevel.high,
      impactValue: '89g',
      isConnected: true,
      age: 17,
      heartRate: '178',
      lastImpact: '89',
      deviceStatus: 'Connected',
    ),
    Athlete(
      name: 'Jordan Lee',
      role: 'Linebacker',
      eventText: 'Abnormal Vital Signs',
      riskLevel: RiskLevel.moderate,
      impactValue: '62g',
      isConnected: true,
      age: 16,
      heartRate: '165',
      lastImpact: '62',
      deviceStatus: 'Connected',
    ),
    Athlete(
      name: 'Casey Wilson',
      role: 'Running Back',
      eventText: 'Abnormal Vital Signs',
      riskLevel: RiskLevel.moderate,
      impactValue: '58g',
      isConnected: true,
      age: 16,
      heartRate: '172',
      lastImpact: '58',
      deviceStatus: 'Connected',
    ),
    Athlete(
      name: 'Taylor Brown',
      role: 'Wide Receiver',
      eventText: 'Stable Readings',
      riskLevel: RiskLevel.low,
      impactValue: '34g',
      isConnected: true,
      age: 17,
      heartRate: '141',
      lastImpact: '34',
      deviceStatus: 'Connected',
    ),
    Athlete(
      name: 'Morgan Davis',
      role: 'Safety',
      eventText: 'Stable Readings',
      riskLevel: RiskLevel.low,
      impactValue: '28g',
      isConnected: false,
      age: 17,
      heartRate: '--',
      lastImpact: '28',
      deviceStatus: 'Disconnected',
    ),
  ];

  List<Athlete> get _filteredAthletes {
    switch (_selectedFilter) {
      case 'high':
        return _athletes.where((a) => a.riskLevel == RiskLevel.high).toList();
      case 'moderate':
        return _athletes.where((a) => a.riskLevel == RiskLevel.moderate).toList();
      case 'low':
        return _athletes.where((a) => a.riskLevel == RiskLevel.low).toList();
      case 'disconnected':
        return _athletes.where((a) => !a.isConnected).toList();
      case 'all':
      default:
        return _athletes;
    }
  }

  int get _highCount => _athletes.where((a) => a.riskLevel == RiskLevel.high).length;
  int get _moderateCount => _athletes.where((a) => a.riskLevel == RiskLevel.moderate).length;
  int get _lowCount => _athletes.where((a) => a.riskLevel == RiskLevel.low).length;
  int get _disconnectedCount => _athletes.where((a) => !a.isConnected).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopHeader(),
                    const SizedBox(height: 20),
                    _buildTeamStatusCard(),
                    const SizedBox(height: 20),
                    _buildFilterChips(),
                    const SizedBox(height: 20),
                    ..._filteredAthletes.map(
                      (athlete) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: AthleteCard(
                          athlete: athlete,
                          onTap: () => _showAthleteDetailSheet(athlete),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: const BoxDecoration(
            color: Color(0xFFD9D4C8),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.groups_2_outlined,
            color: Color(0xFF5B5B5B),
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Varsity Football',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              SizedBox(height: 2),
              Text(
                '5 Athletes',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7A7A7A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFD9D4C8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-athletes');
            },
            icon: const Icon(
              Icons.person_add_alt_1_outlined,
              color: Color(0xFF5B5B5B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Team Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              StatusPill(
                label: '$_highCount High Risk',
                textColor: const Color(0xFFEF4444),
                backgroundColor: const Color(0xFFFCE7EA),
                dotColor: const Color(0xFFEF4444),
              ),
              StatusPill(
                label: '$_moderateCount Moderate',
                textColor: const Color(0xFFF2994A),
                backgroundColor: const Color(0xFFF9EDC7),
                dotColor: const Color(0xFFF2994A),
              ),
              StatusPill(
                label: '$_lowCount Low Risk',
                textColor: const Color(0xFF166B57),
                backgroundColor: const Color(0xFFDCEFEA),
                dotColor: const Color(0xFF166B57),
              ),
              StatusPill(
                label: '$_disconnectedCount Disconnected',
                textColor: const Color(0xFF9B9B9B),
                backgroundColor: const Color(0xFFF0EFEA),
                icon: Icons.wifi_off,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChipButton(
            label: 'All (${_athletes.length})',
            isSelected: _selectedFilter == 'all',
            onTap: () => setState(() => _selectedFilter = 'all'),
            selectedColor: const Color(0xFF166B57),
          ),
          const SizedBox(width: 12),
          FilterChipButton(
            label: 'High Risk ($_highCount)',
            isSelected: _selectedFilter == 'high',
            onTap: () => setState(() => _selectedFilter = 'high'),
            selectedColor: const Color(0xFFEF4444),
          ),
          const SizedBox(width: 12),
          FilterChipButton(
            label: 'Moderate ($_moderateCount)',
            isSelected: _selectedFilter == 'moderate',
            onTap: () => setState(() => _selectedFilter = 'moderate'),
            selectedColor: const Color(0xFFF2994A),
          ),
          const SizedBox(width: 12),
          FilterChipButton(
            label: 'Low Risk ($_lowCount)',
            isSelected: _selectedFilter == 'low',
            onTap: () => setState(() => _selectedFilter = 'low'),
            selectedColor: const Color(0xFF166B57),
          ),
          const SizedBox(width: 12),
          FilterChipButton(
            label: 'Disconnected ($_disconnectedCount)',
            isSelected: _selectedFilter == 'disconnected',
            onTap: () => setState(() => _selectedFilter = 'disconnected'),
            selectedColor: const Color(0xFF9B9B9B),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return SafeArea(
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
                label: 'Team',
                icon: Icons.dashboard_outlined,
                isSelected: _selectedBottomNavIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedBottomNavIndex = 0;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BottomNavButton(
                label: 'Analytics',
                icon: Icons.show_chart_outlined,
                isSelected: _selectedBottomNavIndex == 1,
                onTap: () {
                  Navigator.pushNamed(context, '/trainer-analytics');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAthleteDetailSheet(Athlete athlete) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AthleteDetailSheet(athlete: athlete);
      },
    );
  }
}

class AthleteCard extends StatelessWidget {
  final Athlete athlete;
  final VoidCallback onTap;

  const AthleteCard({
    super.key,
    required this.athlete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = athlete.riskColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: colors.softBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: colors.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      athlete.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      athlete.role,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6E6E6E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      athlete.eventText,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF969696),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    athlete.riskLabel,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        athlete.impactValue,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7A7A7A),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        athlete.isConnected ? Icons.wifi : Icons.wifi_off,
                        color: athlete.isConnected
                            ? const Color(0xFF166B57)
                            : const Color(0xFF9B9B9B),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AthleteDetailSheet extends StatelessWidget {
  final Athlete athlete;

  const AthleteDetailSheet({
    super.key,
    required this.athlete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = athlete.riskColors;

    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.32,
      maxChildSize: 0.80,
      expand: false,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F8F6),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD3D0C8),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFFDCEFEA),
                            child: const Icon(
                              Icons.person_outline,
                              color: Color(0xFF166B57),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  athlete.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${athlete.age} years · ${athlete.role}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF777777),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
                        decoration: BoxDecoration(
                          color: colors.bannerBackground,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: colors.primary,
                              size: 34,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Current Risk Level',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              athlete.riskLabel,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              title: 'Heart Rate',
                              value: athlete.heartRate,
                              unit: 'BPM',
                              icon: Icons.favorite_border,
                              accentColor: const Color(0xFF166B57),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricCard(
                              title: 'Last Impact',
                              value: athlete.lastImpact,
                              unit: 'g-force',
                              icon: Icons.warning_amber_rounded,
                              accentColor: colors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              athlete.isConnected ? Icons.wifi : Icons.wifi_off,
                              color: athlete.isConnected
                                  ? const Color(0xFF166B57)
                                  : const Color(0xFF9B9B9B),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Device Status',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6E6E6E),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  athlete.deviceStatus,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: athlete.isConnected
                                        ? const Color(0xFF166B57)
                                        : const Color(0xFF9B9B9B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF166B57),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              '/trainer-analytics',
                              arguments: athlete,
                            );
                          },
                          child: const Text(
                            'View Full History',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color accentColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 20),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6E6E6E),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF888888),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final Color? dotColor;
  final IconData? icon;

  const StatusPill({
    super.key,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    this.dotColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: 16, color: textColor)
          else
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor ?? textColor,
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterChipButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;

  const FilterChipButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? selectedColor : Colors.white.withValues(alpha: 0.82);
    final textColor = isSelected ? Colors.white : const Color(0xFF555555);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
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

enum RiskLevel { high, moderate, low }

class Athlete {
  final String name;
  final String role;
  final String eventText;
  final RiskLevel riskLevel;
  final String impactValue;
  final bool isConnected;
  final int age;
  final String heartRate;
  final String lastImpact;
  final String deviceStatus;

  const Athlete({
    required this.name,
    required this.role,
    required this.eventText,
    required this.riskLevel,
    required this.impactValue,
    required this.isConnected,
    required this.age,
    required this.heartRate,
    required this.lastImpact,
    required this.deviceStatus,
  });

  String get riskLabel {
    switch (riskLevel) {
      case RiskLevel.high:
        return 'High Risk';
      case RiskLevel.moderate:
        return 'Moderate Risk';
      case RiskLevel.low:
        return 'Low Risk';
    }
  }

  RiskPalette get riskColors {
    switch (riskLevel) {
      case RiskLevel.high:
        return const RiskPalette(
          primary: Color(0xFFEF4444),
          softBackground: Color(0xFFFCEBEC),
          bannerBackground: Color(0xFFF9EAEA),
        );
      case RiskLevel.moderate:
        return const RiskPalette(
          primary: Color(0xFFF2994A),
          softBackground: Color(0xFFFBF1E8),
          bannerBackground: Color(0xFFFAF3EB),
        );
      case RiskLevel.low:
        return const RiskPalette(
          primary: Color(0xFF166B57),
          softBackground: Color(0xFFE7F2EE),
          bannerBackground: Color(0xFFEAF4F0),
        );
    }
  }
}

class RiskPalette {
  final Color primary;
  final Color softBackground;
  final Color bannerBackground;

  const RiskPalette({
    required this.primary,
    required this.softBackground,
    required this.bannerBackground,
  });
}