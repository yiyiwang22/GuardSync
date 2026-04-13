import 'package:flutter/material.dart';
import 'trainer_data_store.dart';

class AddAthletesPage extends StatefulWidget {
  const AddAthletesPage({super.key});

  @override
  State<AddAthletesPage> createState() => _AddAthletesPageState();
}

class _AddAthletesPageState extends State<AddAthletesPage> {
  final TrainerDataStore _store = TrainerDataStore.instance;
  final TextEditingController _emailController = TextEditingController();

  String? _expandedSection;

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

  void _sendInvite() {
    final email = _emailController.text.trim().toLowerCase();

    if (_store.containsPendingTrainerInvite(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('That athlete already has a pending invite.')),
      );
      return;
    }

    _store.sendTrainerInvite(athleteEmail: email);
    _emailController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Athlete invite sent.')),
    );
  }

  void _bulkInviteDemo() {
    _store.bulkInviteAthletes([
      'alex.martinez@example.com',
      'jordan.lee@example.com',
      'casey.wilson@example.com',
    ]);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bulk invites created.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5F5F0);
    const purple = Color(0xFF5A1F6F);

    final pendingInvites = _store.pendingTrainerInvites;
    final approvedAthletes = _store.athletes;

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
                'Add Athletes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Connect with your athletes to monitor their health and safety during training and games.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 24),

              _buildExpandableCard(
                sectionId: 'team_code',
                icon: Icons.link,
                title: 'Team Invite Code',
                subtitle: 'Share with your entire team',
                accent: purple,
                expandedChild: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _store.teamInviteCode,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.1,
                                    color: Color(0xFF5A1F6F),
                                  ),
                                ),
                              ),
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: purple,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Copied ${_store.teamInviteCode}'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.copy_rounded, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Athletes can use this code to join your team',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6E6E6E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('QR display hook ready.')),
                          );
                        },
                        icon: const Icon(Icons.qr_code_2_rounded),
                        label: const Text(
                          'Show QR Code',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: purple,
                          foregroundColor: Colors.white,
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
              ),

              const SizedBox(height: 16),

              _buildExpandableCard(
                sectionId: 'email',
                icon: Icons.mail_outline,
                title: 'Add Athlete by Email',
                subtitle: 'Send individual invitations',
                accent: purple,
                expandedChild: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'athlete@example.com',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isEmailValid ? _sendInvite : null,
                        icon: const Icon(Icons.mail_outline),
                        label: const Text(
                          'Send Invite',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          _isEmailValid ? const Color(0xFFA986B7) : const Color(0xFFCFCBC0),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Athlete will receive an invitation link',
                      style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildExpandableCard(
                sectionId: 'bulk',
                icon: Icons.groups_2_outlined,
                title: 'Bulk Athlete Invite',
                subtitle: 'Import multiple athletes at once',
                accent: purple,
                expandedChild: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.groups_2_outlined,
                            size: 46,
                            color: Color(0xFF8A8A8A),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Upload a CSV file with athlete email addresses',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            onPressed: _bulkInviteDemo,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 26,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Choose File',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Feature coming soon',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6E6E6E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              if (pendingInvites.isNotEmpty || approvedAthletes.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Invited Athletes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...pendingInvites.map(
                            (invite) => _InviteStatusTile(
                          title: invite.athleteEmail,
                          statusText: 'Pending athlete response',
                          statusColor: const Color(0xFFF2994A),
                        ),
                      ),
                      ...approvedAthletes.map(
                            (athlete) => _InviteStatusTile(
                          title: athlete.email,
                          statusText: 'Approved',
                          statusColor: const Color(0xFF166B57),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/connection-requests');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: purple,
                            side: const BorderSide(color: purple),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'View Pending Requests',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/trainer-dashboard');
                  },
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
                  color: const Color(0xFFE7D8EF),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xFF5A1F6F),
                    ),
                    children: [
                      TextSpan(
                        text: 'Team Management: ',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text:
                        'Athletes can accept or decline your invitation. You can manage your team roster from the dashboard.',
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

  Widget _buildExpandableCard({
    required String sectionId,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accent,
    required Widget expandedChild,
  }) {
    final isExpanded = _expandedSection == sectionId;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isExpanded ? const Color(0xFFE7D8EF) : Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
        border: isExpanded ? Border.all(color: accent, width: 2.2) : null,
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
                    color: isExpanded ? accent : const Color(0xFFF0EFEA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    icon,
                    color: isExpanded ? Colors.white : const Color(0xFF8A8A8A),
                    size: 34,
                  ),
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
            const Divider(color: Color(0xFFC9B8D3)),
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

class _InviteStatusTile extends StatelessWidget {
  final String title;
  final String statusText;
  final Color statusColor;

  const _InviteStatusTile({
    required this.title,
    required this.statusText,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}