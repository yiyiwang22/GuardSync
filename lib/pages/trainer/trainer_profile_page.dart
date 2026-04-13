import 'package:flutter/material.dart';
import 'trainer_data_store.dart';

class TrainerProfilePage extends StatefulWidget {
  const TrainerProfilePage({super.key});

  @override
  State<TrainerProfilePage> createState() => _TrainerProfilePageState();
}

class _TrainerProfilePageState extends State<TrainerProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _teamNameController = TextEditingController();

  String _roleType = 'coach';
  String _organizationType = 'team';
  String? _selectedSport;

  bool _highRiskAlerts = true;
  bool _moderateRiskAlerts = true;
  bool _deviceDisconnectedAlerts = true;
  bool _abnormalVitalsAlerts = true;

  final List<String> _sports = const [
    'Football',
    'Basketball',
    'Soccer',
    'Hockey',
    'Rugby',
    'Wrestling',
    'Boxing',
    'Lacrosse',
    'Baseball',
    'Other',
  ];

  bool get _isFormValid {
    final hasRequiredNames =
        _firstNameController.text.trim().isNotEmpty &&
            _lastNameController.text.trim().isNotEmpty;

    final hasSport = _selectedSport != null && _selectedSport!.trim().isNotEmpty;

    final hasTeamNameIfNeeded = _organizationType == 'independent'
        ? true
        : _teamNameController.text.trim().isNotEmpty;

    return hasRequiredNames && hasSport && hasTeamNameIfNeeded;
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_refresh);
    _lastNameController.addListener(_refresh);
    _teamNameController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _teamNameController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (!_isFormValid) return;

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final fullName = '$firstName $lastName'.trim();
    final selectedSport = _selectedSport ?? 'Football';

    final derivedTeamName = _organizationType == 'team'
        ? _teamNameController.text.trim()
        : '$selectedSport Training';

    TrainerDataStore.instance.setTrainerContext(
      trainerName: fullName,
      sport: selectedSport,
      teamName: derivedTeamName,
    );

    Navigator.pushNamed(context, '/add-athletes');
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5F5F0);
    const primaryGreen = Color(0xFF166B57);
    const softGreen = Color(0xFFDCEFEA);
    const borderColor = Color(0xFFD9D6CD);
    const textGray = Color(0xFF666666);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D4C8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF555555)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Trainer Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Set up your coaching profile to monitor and manage your athletes.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: textGray,
                ),
              ),
              const SizedBox(height: 28),

              const _FieldLabel('First Name *'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _firstNameController,
                hint: 'Enter first name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 20),
              const _FieldLabel('Last Name *'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _lastNameController,
                hint: 'Enter last name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 20),
              const _FieldLabel('Role Type *'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      label: 'Coach',
                      selected: _roleType == 'coach',
                      onTap: () => setState(() => _roleType = 'coach'),
                      selectedColor: primaryGreen,
                      selectedBackground: softGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildToggleButton(
                      label: 'Athletic Trainer',
                      selected: _roleType == 'athletic_trainer',
                      onTap: () => setState(() => _roleType = 'athletic_trainer'),
                      selectedColor: primaryGreen,
                      selectedBackground: softGreen,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const _FieldLabel('Sport *'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _selectedSport != null ? primaryGreen : borderColor,
                    width: _selectedSport != null ? 1.5 : 1,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSport,
                    isExpanded: true,
                    hint: const Text(
                      'Select sport',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF777777),
                      ),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: _sports
                        .map(
                          (sport) => DropdownMenuItem<String>(
                        value: sport,
                        child: Text(
                          sport,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedSport = value);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const _FieldLabel('Organization Type *'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      label: 'Team Coach',
                      selected: _organizationType == 'team',
                      onTap: () => setState(() => _organizationType = 'team'),
                      selectedColor: primaryGreen,
                      selectedBackground: softGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildToggleButton(
                      label: 'Independent',
                      selected: _organizationType == 'independent',
                      onTap: () => setState(() => _organizationType = 'independent'),
                      selectedColor: primaryGreen,
                      selectedBackground: softGreen,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _FieldLabel(
                _organizationType == 'independent'
                    ? 'Organization Name'
                    : 'Team Name *',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _teamNameController,
                hint: _organizationType == 'independent'
                    ? 'Optional'
                    : 'Enter team name',
                icon: Icons.groups_2_outlined,
                enabled: _organizationType == 'team',
              ),

              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.88),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.notifications_none, color: primaryGreen),
                        SizedBox(width: 10),
                        Text(
                          'Notification Preferences',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F1F1F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCheckboxTile(
                      value: _highRiskAlerts,
                      label: 'High Risk Alerts',
                      onChanged: (value) =>
                          setState(() => _highRiskAlerts = value ?? false),
                    ),
                    _buildCheckboxTile(
                      value: _moderateRiskAlerts,
                      label: 'Moderate Risk Alerts',
                      onChanged: (value) =>
                          setState(() => _moderateRiskAlerts = value ?? false),
                    ),
                    _buildCheckboxTile(
                      value: _deviceDisconnectedAlerts,
                      label: 'Device Disconnected Alerts',
                      onChanged: (value) => setState(
                            () => _deviceDisconnectedAlerts = value ?? false,
                      ),
                    ),
                    _buildCheckboxTile(
                      value: _abnormalVitalsAlerts,
                      label: 'Abnormal Vital Sign Alerts',
                      onChanged: (value) => setState(
                            () => _abnormalVitalsAlerts = value ?? false,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _handleContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? primaryGreen
                        : const Color(0xFFCFCBC0),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFCFCBC0),
                    disabledForegroundColor: const Color(0xFF9B9B9B),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF9A9A9A)),
        filled: true,
        fillColor: enabled
            ? Colors.white.withOpacity(0.45)
            : const Color(0xFFEAE6DB),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD9D6CD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD9D6CD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF166B57), width: 1.8),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD9D6CD)),
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required Color selectedColor,
    required Color selectedBackground,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? selectedBackground : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? selectedColor : const Color(0xFFD9D6CD),
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: selected ? selectedColor : const Color(0xFF777777),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCheckboxTile({
    required bool value,
    required String label,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: const Color(0xFF166B57),
      value: value,
      onChanged: onChanged,
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF4F4F4F),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF555555),
      ),
    );
  }
}