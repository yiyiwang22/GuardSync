import 'package:flutter/material.dart';

// Model for Role data
class RoleModel {
  final String id;
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final Color bgColor;

  RoleModel({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> with TickerProviderStateMixin {
  // State for selected role
  String? _selectedId;

  // Animation controllers
  late AnimationController _headerController;
  late AnimationController _listController;
  late List<AnimationController> _cardControllers;

  final List<RoleModel> _roles = [
    RoleModel(
      id: 'athlete',
      label: 'Athlete',
      description: 'Track your own performance and health metrics in real-time.',
      icon: Icons.fitness_center_rounded, // Equivalent to Dumbbell
      color: const Color(0xFF1A5C4C),
      bgColor: const Color(0xFFD6ECE6),
    ),
    RoleModel(
      id: 'parent',
      label: 'Parent / Guardian',
      description: "Monitor your child's safety and health data remotely.",
      icon: Icons.people_alt_rounded, // Equivalent to Users
      color: const Color(0xFF5C4C1A),
      bgColor: const Color(0xFFECE6D6),
    ),
    RoleModel(
      id: 'trainer',
      label: 'Trainer / Coach',
      description: "Oversee your team's stats, manage athletes, and review risks.",
      icon: Icons.school_rounded, // Equivalent to GraduationCap
      color: const Color(0xFF4C1A5C),
      bgColor: const Color(0xFFE6D6EC),
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Header animation
    _headerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _listController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    // Staggered controllers for each card to mimic motion.button delay
    _cardControllers = List.generate(
      _roles.length,
      (index) => AnimationController(vsync: this, duration: const Duration(milliseconds: 500)),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 50));
    _listController.forward();
    
    // Trigger staggered card entry
    for (var i = 0; i < _cardControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: (100 + (i * 80)).toInt()));
      _cardControllers[i].forward();
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    for (var c in _cardControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _handleContinue() {
    if (_selectedId == null) return;

    // Navigation logic matching React's router
    if (_selectedId == 'athlete') {
      Navigator.pushNamed(context, '/profile', arguments: {'role': _selectedId});
    } else if (_selectedId == 'parent') {
      Navigator.pushNamed(context, '/parent-profile');
    } else if (_selectedId == 'trainer') {
      Navigator.pushNamed(context, '/trainer-profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1A5C4C);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header / Back Button ---
              FadeTransition(
                opacity: _headerController,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(_headerController),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 8),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(color: Color(0xFFD4D2C5), shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF555555)),
                      ),
                    ),
                  ),
                ),
              ),

              // --- Title Section ---
              FadeTransition(
                opacity: _listController,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(_listController),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Choose Your Role', 
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                      SizedBox(height: 4),
                      Text("Select how you'll be using GuardSync. You can change this later.",
                        style: TextStyle(fontSize: 14, color: Color(0xFF777777))),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- Role Cards ---
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _roles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final role = _roles[index];
                    final isSelected = _selectedId == role.id;

                    return FadeTransition(
                      opacity: _cardControllers[index],
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(_cardControllers[index]),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedId = role.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? primaryGreen : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: isSelected 
                                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))] 
                                : [],
                            ),
                            child: Row(
                              children: [
                                // Icon Container
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(color: role.bgColor, borderRadius: BorderRadius.circular(16)),
                                  child: Icon(role.icon, size: 26, color: role.color),
                                ),
                                const SizedBox(width: 16),
                                // Text Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(role.label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                                      const SizedBox(height: 2),
                                      Text(role.description, style: const TextStyle(fontSize: 12, color: Color(0xFF888888), height: 1.4)),
                                    ],
                                  ),
                                ),
                                // Chevron
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: isSelected ? primaryGreen : const Color(0xFFCCCCCC),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // --- Continue Button ---
              Padding(
                padding: const EdgeInsets.only(bottom: 40, top: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedId != null ? _handleContinue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedId != null ? primaryGreen : const Color(0xFFC5C3B8),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFC5C3B8),
                      disabledForegroundColor: const Color(0xFF999999),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}