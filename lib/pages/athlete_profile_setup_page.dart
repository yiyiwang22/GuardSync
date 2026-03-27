import 'package:flutter/material.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _heightFtController = TextEditingController();
  final _heightInController = TextEditingController();
  final _weightController = TextEditingController();
  final _teamController = TextEditingController();

  // Selected state values
  String? _selectedSex;
  String? _selectedSport;
  String? _selectedPosition;

  // Data constants
  final List<String> _sports = ['Football', 'Basketball', 'Soccer', 'Hockey', 'Rugby', 'Boxing', 'MMA', 'Lacrosse', 'Wrestling', 'Baseball'];
  final Map<String, List<String>> _positions = {
    'Football': ['Quarterback', 'Running Back', 'Wide Receiver', 'Linebacker', 'Defensive End', 'Safety', 'Cornerback', 'Offensive Line', 'Tight End'],
    'Basketball': ['Point Guard', 'Shooting Guard', 'Small Forward', 'Power Forward', 'Center'],
    'Soccer': ['Goalkeeper', 'Defender', 'Midfielder', 'Forward'],
    'Hockey': ['Center', 'Left Wing', 'Right Wing', 'Defenseman', 'Goaltender'],
    'Baseball': ['Pitcher', 'Catcher', 'First Base', 'Second Base', 'Shortstop', 'Third Base', 'Outfield'],
  };

  @override
  Widget build(BuildContext context) {
    // Get arguments from previous page
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final role = args?['role'] ?? 'athlete';
    final String roleLabel = (role == 'parent' || role == 'trainer') ? "Athlete's" : "Your";

    // Validation logic: All fields required except Team Name
    bool isComplete = _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _dobController.text.trim().isNotEmpty &&
        _selectedSex != null &&
        _heightFtController.text.trim().isNotEmpty &&
        _heightInController.text.trim().isNotEmpty &&
        _weightController.text.trim().isNotEmpty &&
        _selectedSport != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Navigation Header ---
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36, height: 36,
                  decoration: const BoxDecoration(color: Color(0xFFD4D2C5), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back, size: 18, color: Color(0xFF555555)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Profile Setup', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
              const SizedBox(height: 4),
              Text('Enter ${roleLabel.toLowerCase()} details to personalize the experience.',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF777777))),

              const SizedBox(height: 32),

              // --- Avatar Section ---
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 96, height: 96,
                      decoration: const BoxDecoration(color: Color(0xFFD4D2C5), shape: BoxShape.circle),
                      child: const Icon(Icons.person, size: 40, color: Color(0xFF888888)),
                    ),
                    Positioned(bottom: 0, right: 0,
                      child: Container(
                        width: 32, height: 32,
                        decoration: const BoxDecoration(color: Color(0xFF1A5C4C), shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- Form: Names ---
              Row(
                children: [
                  Expanded(child: _buildTextField('First Name', _firstNameController, hint: 'John')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField('Last Name', _lastNameController, hint: 'Smith')),
                ],
              ),
              const SizedBox(height: 16),

              // --- Form: Sex & DOB ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomOverlayDropdown(
                      label: 'Sex',
                      value: _selectedSex,
                      items: const ['Male', 'Female', 'Other'],
                      onSelect: (val) => setState(() => _selectedSex = val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField('Date of Birth', _dobController, hint: 'YYYY-MM-DD')),
                ],
              ),
              const SizedBox(height: 16),

              // --- Form: Height & Weight ---
              _buildLabel('Height & Weight'),
              Row(
                children: [
                  Expanded(child: _buildTextField('', _heightFtController, hint: '6', suffix: 'ft')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('', _heightInController, hint: '2', suffix: 'in')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('', _weightController, hint: '247', suffix: 'lbs')),
                ],
              ),
              const SizedBox(height: 16),

              // --- Form: Sport & Position ---
              CustomOverlayDropdown(
                label: 'Sport',
                value: _selectedSport,
                items: _sports,
                onSelect: (val) => setState(() {
                  _selectedSport = val;
                  _selectedPosition = null; // Reset position when sport changes
                }),
              ),
              const SizedBox(height: 16),

              if (_selectedSport != null && _positions.containsKey(_selectedSport))
                CustomOverlayDropdown(
                  label: 'Position',
                  value: _selectedPosition,
                  items: _positions[_selectedSport]!,
                  onSelect: (val) => setState(() => _selectedPosition = val),
                ),

              const SizedBox(height: 16),

              // --- Form: Team (Optional) ---
              _buildTextField('Team Name (optional)', _teamController, hint: 'e.g. Westfield Eagles'),

              const SizedBox(height: 32),

              // --- Submission Button: Dynamic Color & Disabled State ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isComplete ? () => Navigator.pushNamed(context, '/onboarding') : null,
                  style: ElevatedButton.styleFrom(
                    // Green if complete, Grey if incomplete
                    backgroundColor: isComplete ? const Color(0xFF1A5C4C) : const Color(0xFFC5C3B8),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFC5C3B8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Continue to Device Setup', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build field labels
  Widget _buildLabel(String label) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF555555))));
  }

  // Helper to build standard text fields with listener support
  Widget _buildTextField(String label, TextEditingController controller, {String? hint, String? suffix}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildLabel(label),
      TextField(
        controller: controller,
        // Trigger build when user types to update the "Continue" button state
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
          suffixIcon: suffix != null ? Container(width: 40, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 12), child: Text(suffix, style: const TextStyle(fontSize: 12, color: Color(0xFF999999)))) : null,
          filled: true, fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDDDDDD))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1A5C4C))),
        ),
      ),
    ]);
  }
}

// Custom dropdown using Overlay to solve clipping and hit-testing issues
class CustomOverlayDropdown extends StatefulWidget {
  final String label;
  final String? value;
  final List<String> items;
  final Function(String) onSelect;

  const CustomOverlayDropdown({super.key, required this.label, required this.value, required this.items, required this.onSelect});

  @override
  State<CustomOverlayDropdown> createState() => _CustomOverlayDropdownState();
}

class _CustomOverlayDropdownState extends State<CustomOverlayDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) { _closeDropdown(); } else { _openDropdown(); }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss dropdown when clicking outside
          GestureDetector(
            onTap: _closeDropdown,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height - 18), 
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: size.width,
                margin: const EdgeInsets.only(top: 4),
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDDDDDD)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: widget.items.map((item) => InkWell(
                    onTap: () {
                      widget.onSelect(item);
                      _closeDropdown();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      color: widget.value == item ? const Color(0xFFF0F5F3) : Colors.transparent,
                      child: Text(item, style: TextStyle(fontSize: 14, color: widget.value == item ? const Color(0xFF1A5C4C) : const Color(0xFF1A1A1A))),
                    ),
                  )).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(widget.label, style: const TextStyle(fontSize: 12, color: Color(0xFF555555)))),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isOpen ? const Color(0xFF1A5C4C) : const Color(0xFFDDDDDD)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(widget.value ?? 'Select', style: TextStyle(fontSize: 14, color: widget.value == null ? const Color(0xFFBBBBBB) : const Color(0xFF1A1A1A)))),
                  const Icon(Icons.expand_more, size: 16, color: Color(0xFF999999)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}