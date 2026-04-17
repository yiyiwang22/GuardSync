import 'package:flutter/material.dart';
import 'trainer/trainer_data_store.dart';

class AthleteConnectionPage extends StatefulWidget {
  const AthleteConnectionPage({super.key});

  @override
  State<AthleteConnectionPage> createState() => _AthleteConnectionPageState();
}

class _AthleteConnectionPageState extends State<AthleteConnectionPage> {
  final TextEditingController _emailController = TextEditingController();
  final TrainerDataStore _store = TrainerDataStore.instance;

  bool _showQr = false;

  bool get _isEmailValid {
    final email = _emailController.text.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_refresh);
    _store.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _emailController.dispose();
    _store.removeListener(_refresh);
    super.dispose();
  }

  void _copyCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ${_store.athleteShareCode}')),
    );
  }

  void _sendEmailInvite() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Invite link sent to ${_emailController.text.trim()}',
        ),
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
                'Connect Parent or Trainer',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Share access to your health data with parents or trainers who need to monitor your safety.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 28),

              _buildInviteCodeCard(primaryGreen),
              const SizedBox(height: 18),
              _buildQrCard(primaryGreen),
              const SizedBox(height: 18),
              _buildEmailCard(primaryGreen),
              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEFEA),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xFF166B57),
                    ),
                    children: [
                      TextSpan(
                        text: 'Privacy Note: ',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text:
                        'Parents and trainers will only be able to view your health data. They cannot modify your profile or device settings.',
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

  Widget _buildInviteCodeCard(Color primaryGreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.link, 'Your Invite Code', primaryGreen),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EFEA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _store.athleteShareCode,
                    style: const TextStyle(
                      fontSize: 18,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF166B57),
                    ),
                  ),
                ),
                InkWell(
                  onTap: _copyCode,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.copy_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Share this code with your parent or trainer. They can use it to link to your account.',
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCard(Color primaryGreen) {
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
            onTap: () => setState(() => _showQr = !_showQr),
            child: Row(
              children: [
                Icon(Icons.qr_code_2_rounded, color: primaryGreen),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Show QR Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                ),
                Icon(
                  _showQr
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF777777),
                ),
              ],
            ),
          ),
          if (_showQr) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFD8D3C8)),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                border: Border.all(color: primaryGreen, width: 2),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EFEA),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.qr_code_2_rounded,
                      size: 120,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Scan this QR code to instantly connect',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailCard(Color primaryGreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(Icons.mail_outline, 'Send Email Invite', primaryGreen),
          const SizedBox(height: 18),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'parent@example.com',
              filled: true,
              fillColor: const Color(0xFFF9F9F7),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isEmailValid ? _sendEmailInvite : null,
              icon: const Icon(Icons.mail_outline),
              label: const Text(
                'Send Invite Link',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                _isEmailValid ? primaryGreen : const Color(0xFFCFCBC0),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFCFCBC0),
                disabledForegroundColor: const Color(0xFF8D8D8D),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F1F1F),
          ),
        ),
      ],
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