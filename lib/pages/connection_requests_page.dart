import 'package:flutter/material.dart';
import 'trainer/trainer_data_store.dart';

class ConnectionRequestsPage extends StatefulWidget {
  const ConnectionRequestsPage({super.key});

  @override
  State<ConnectionRequestsPage> createState() => _ConnectionRequestsPageState();
}

class _ConnectionRequestsPageState extends State<ConnectionRequestsPage> {
  final TrainerDataStore _store = TrainerDataStore.instance;

  @override
  void initState() {
    super.initState();
    _store.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _store.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requests = _store.pendingIncomingRequests;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(context),
              const SizedBox(height: 18),
              const Text(
                'Connection Requests',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${requests.length} pending',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 22),
              if (requests.isEmpty)
                _buildEmptyState()
              else ...[
                ...requests.map(_buildRequestCard),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCEFEA),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: Color(0xFF166B57),
                      ),
                      children: [
                        TextSpan(
                          text: 'Privacy & Control: ',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(
                          text:
                          'You can revoke access at any time from your account settings. Only approve requests from people you trust.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(ConnectionRequest request) {
    final isParent = request.type == RequesterType.parent;
    final accent =
    isParent ? const Color(0xFF6B5A17) : const Color(0xFF5A1F6F);
    final badgeBg =
    isParent ? const Color(0xFFF0E7D6) : const Color(0xFFE7D8EF);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isParent)
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: badgeBg,
                  child: Icon(Icons.person_outline, color: accent, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.requesterName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request.requesterSubtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF777777),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        request.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9A9A9A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: badgeBg,
                  child: Icon(Icons.person_outline, color: accent, size: 30),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Trainer Connection Request',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EFEA),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              request.message,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Color(0xFF4F4F4F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 18),
          _permissionList(
            icon: Icons.remove_red_eye_outlined,
            iconColor: const Color(0xFF166B57),
            title: 'They will be able to:',
            items: const [
              'View your real-time health metrics',
              'Receive risk alerts and notifications',
              'Access your activity history',
            ],
          ),
          const SizedBox(height: 16),
          _permissionList(
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFFEF4444),
            title: 'They will NOT be able to:',
            items: const [
              'Modify your profile information',
              'Change device settings',
              'Delete your data',
            ],
          ),
          const SizedBox(height: 18),
          Text(
            _store.timeAgo(request.requestedAt),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF8A8A8A),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _store.reviewIncomingRequest(
                      requestId: request.id,
                      approved: true,
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text(
                    'Approve',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF166B57),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _store.reviewIncomingRequest(
                      requestId: request.id,
                      approved: false,
                    );
                  },
                  icon: const Icon(Icons.close),
                  label: const Text(
                    'Deny',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5DDE1),
                    foregroundColor: const Color(0xFFEF4444),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _permissionList({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> items,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ...items.map(
                    (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '• $item',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Color(0xFF4F4F4F),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFDCEFEA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 58,
                color: Color(0xFF166B57),
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'All Caught Up!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "You don't have any pending connection requests at the moment.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
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