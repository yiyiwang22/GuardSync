import 'package:flutter/material.dart';

class ParentProfilePage extends StatefulWidget {
  const ParentProfilePage({super.key});

  @override
  State<ParentProfilePage> createState() => _ParentProfilePageState();
}

class _ParentProfilePageState extends State<ParentProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _relationship;
  bool _highRiskAlerts = true;
  bool _moderateRiskAlerts = true;

  final List<String> _relationships = const [
    'Mother',
    'Father',
    'Guardian',
    'Sibling',
    'Other',
  ];

  bool get _isFormValid {
    return _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _relationship != null;
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_refresh);
    _lastNameController.addListener(_refresh);
    _emailController.addListener(_refresh);
    _phoneController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5F5F0);
    const primaryGreen = Color(0xFF166B57);
    const borderColor = Color(0xFFD9D6CD);

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
              const SizedBox(height: 22),
              const Text(
                'Parent Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Set up your profile to monitor your child's health and safety.",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF666666),
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
              const _FieldLabel('Email *'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _emailController,
                hint: 'your.email@example.com',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),
              const _FieldLabel('Phone Number'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _phoneController,
                hint: '(555) 123-4567',
                icon: Icons.call_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 20),
              const _FieldLabel('Relationship to Athlete *'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _relationship != null ? primaryGreen : borderColor,
                    width: _relationship != null ? 1.5 : 1,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _relationship,
                    isExpanded: true,
                    hint: const Text(
                      'Select relationship',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1F1F1F),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: _relationships
                        .map(
                          (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
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
                      setState(() => _relationship = value);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notification Preferences',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(height: 14),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: primaryGreen,
                      value: _highRiskAlerts,
                      onChanged: (value) {
                        setState(() => _highRiskAlerts = value ?? false);
                      },
                      title: const Text(
                        'High Risk Alerts',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F4F4F),
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: primaryGreen,
                      value: _moderateRiskAlerts,
                      onChanged: (value) {
                        setState(() => _moderateRiskAlerts = value ?? false);
                      },
                      title: const Text(
                        'Moderate Risk Alerts',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F4F4F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFormValid
                      ? () => Navigator.pushNamed(context, '/link-to-athlete')
                      : null,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF9A9A9A)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.45),
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