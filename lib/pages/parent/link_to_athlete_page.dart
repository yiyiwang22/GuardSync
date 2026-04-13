import 'package:flutter/material.dart';
import '../trainer/trainer_data_store.dart';

class LinkToAthletePage extends StatefulWidget {
  const LinkToAthletePage({super.key});

  @override
  State<LinkToAthletePage> createState() => _LinkToAthletePageState();
}

class _LinkToAthletePageState extends State<LinkToAthletePage> {
  final TrainerDataStore _store = TrainerDataStore.instance;
  final TextEditingController _inviteCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _expandedSection;
  String _relationship = 'Mother';

  bool get _hasInviteCode => _inviteCodeController.text.trim().isNotEmpty;

  bool get _isEmailValid {
    final email = _emailController.text.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _inviteCodeController.addListener(_refresh);
    _emailController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _inviteCodeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitInviteCode() {
    Navigator.pushNamed(context, '/parent-dashboard');
  }

  void _sendRequestByEmail() {
    _store.sendParentAccessRequest(
      email: _emailController.text.trim(),
      relationship: _relationship,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request sent to ${_emailController.text.trim()}'),
      ),
    );

    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5F5F0);
    const primaryGreen = Color(0xFF166B57);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(context),
              const SizedBox(height: 18),
              const Text(
                'Link to Athlete',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Connect to your child's GuardSync account to monitor their health data during sports activities.",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 24),

              _buildActionCard(
                sectionId: 'code',
                icon: Icons.key_outlined,
                title: 'Enter Invite Code',
                subtitle: 'Use the code provided by your athlete',
                expandedChild: Column(
                  children: [
                    TextField(
                      controller: _inviteCodeController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'GS-ATH-XXXXX',
                        filled: true,
                        fillColor: const Color(0xFFF9F9F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Color(0xFFD9D6CD)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Color(0xFFD9D6CD)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _hasInviteCode ? _submitInviteCode : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasInviteCode
                              ? primaryGreen
                              : const Color(0xFFCFCBC0),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildActionCard(
                sectionId: 'qr',
                icon: Icons.qr_code_2_rounded,
                title: 'Scan QR Code',
                subtitle: 'Instantly connect by scanning',
                expandedChild: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('QR scanning hook ready.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Open Camera',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _buildActionCard(
                sectionId: 'email',
                icon: Icons.mail_outline,
                title: 'Request Access by Email',
                subtitle: 'Send a connection request',
                expandedChild: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _relationship,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF9F9F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Color(0xFFD9D6CD)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Color(0xFFD9D6CD)),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Mother', child: Text('Mother')),
                        DropdownMenuItem(value: 'Father', child: Text('Father')),
                        DropdownMenuItem(value: 'Guardian', child: Text('Guardian')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _relationship = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'athlete@example.com',
                        filled: true,
                        fillColor: const Color(0xFFF9F9F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Color(0xFFD9D6CD)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Color(0xFFD9D6CD)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isEmailValid ? _sendRequestByEmail : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isEmailValid
                              ? primaryGreen
                              : const Color(0xFFCFCBC0),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Send Request',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/parent-dashboard');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Continue to Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/parent-dashboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE3DED1),
                    foregroundColor: const Color(0xFF555555),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Skip for Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4E6B5),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xFF4A4A4A),
                    ),
                    children: [
                      TextSpan(
                        text: 'Note: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFF2994A),
                        ),
                      ),
                      TextSpan(
                        text:
                        "You will have read-only access to your athlete's health data. You cannot modify their profile or device settings.",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String sectionId,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget expandedChild,
  }) {
    final isExpanded = _expandedSection == sectionId;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedSection = isExpanded ? null : sectionId;
              });
            },
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EFEA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(icon, color: const Color(0xFF7A7A7A), size: 34),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6E6E6E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 18),
            expandedChild,
          ],
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFFF0EFEA),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back, color: Color(0xFF1F1F1F)),
      ),
    );
  }
}