import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum RiskLevel { high, moderate, low }
enum InviteStatus { pending, approved, denied }
enum RequesterType { parent, trainer }

class Athlete {
  final String id;
  final String name;
  final String email;
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
    required this.id,
    required this.name,
    required this.email,
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

class TrainerInvite {
  final String id;
  final String athleteEmail;
  final DateTime sentAt;
  final InviteStatus status;

  const TrainerInvite({
    required this.id,
    required this.athleteEmail,
    required this.sentAt,
    required this.status,
  });

  TrainerInvite copyWith({
    String? id,
    String? athleteEmail,
    DateTime? sentAt,
    InviteStatus? status,
  }) {
    return TrainerInvite(
      id: id ?? this.id,
      athleteEmail: athleteEmail ?? this.athleteEmail,
      sentAt: sentAt ?? this.sentAt,
      status: status ?? this.status,
    );
  }
}

class ConnectionRequest {
  final String id;
  final String requesterName;
  final String requesterSubtitle;
  final String email;
  final RequesterType type;
  final String message;
  final DateTime requestedAt;
  final InviteStatus status;
  final String? linkedTrainerInviteId;
  final String targetAthleteEmail;

  const ConnectionRequest({
    required this.id,
    required this.requesterName,
    required this.requesterSubtitle,
    required this.email,
    required this.type,
    required this.message,
    required this.requestedAt,
    required this.status,
    required this.targetAthleteEmail,
    this.linkedTrainerInviteId,
  });

  ConnectionRequest copyWith({
    String? id,
    String? requesterName,
    String? requesterSubtitle,
    String? email,
    RequesterType? type,
    String? message,
    DateTime? requestedAt,
    InviteStatus? status,
    String? linkedTrainerInviteId,
    String? targetAthleteEmail,
  }) {
    return ConnectionRequest(
      id: id ?? this.id,
      requesterName: requesterName ?? this.requesterName,
      requesterSubtitle: requesterSubtitle ?? this.requesterSubtitle,
      email: email ?? this.email,
      type: type ?? this.type,
      message: message ?? this.message,
      requestedAt: requestedAt ?? this.requestedAt,
      status: status ?? this.status,
      linkedTrainerInviteId: linkedTrainerInviteId ?? this.linkedTrainerInviteId,
      targetAthleteEmail: targetAthleteEmail ?? this.targetAthleteEmail,
    );
  }
}

class TrainerDataStore extends ChangeNotifier {
  TrainerDataStore._();

  static final TrainerDataStore instance = TrainerDataStore._();

  final Random _random = Random();

  String _teamName = 'Trainer Team';
  String _sport = 'Football';
  String _trainerDisplayName = 'Coach';

  late String _teamInviteCode = _generateCode(prefix: 'GS-TEAM');
  late String _athleteShareCode = _generateCode(prefix: 'GS-ATH');

  final List<Athlete> _athletes = [];
  final List<TrainerInvite> _trainerInvites = [];
  final List<ConnectionRequest> _incomingConnectionRequests = [];

  String get teamName => _teamName;
  String get sport => _sport;
  String get trainerDisplayName => _trainerDisplayName;
  String get teamInviteCode => _teamInviteCode;
  String get athleteShareCode => _athleteShareCode;

  List<Athlete> get athletes => List.unmodifiable(_athletes);

  List<TrainerInvite> get trainerInvites => List.unmodifiable(_trainerInvites);

  List<TrainerInvite> get pendingTrainerInvites => List.unmodifiable(
    _trainerInvites.where((invite) => invite.status == InviteStatus.pending),
  );

  List<ConnectionRequest> get pendingIncomingRequests => List.unmodifiable(
    _incomingConnectionRequests
        .where((request) => request.status == InviteStatus.pending),
  );

  void setTrainerContext({
    required String trainerName,
    required String sport,
    String? teamName,
  }) {
    if (trainerName.trim().isNotEmpty) {
      _trainerDisplayName = trainerName.trim();
    }
    if (sport.trim().isNotEmpty) {
      _sport = sport.trim();
    }
    if (teamName != null && teamName.trim().isNotEmpty) {
      _teamName = teamName.trim();
    } else if (_teamName.trim().isEmpty) {
      _teamName = '$sport Team';
    }
    notifyListeners();
  }

  bool containsAthleteEmail(String email) {
    final normalized = email.trim().toLowerCase();
    return _athletes.any((athlete) => athlete.email.toLowerCase() == normalized);
  }

  bool containsPendingTrainerInvite(String email) {
    final normalized = email.trim().toLowerCase();
    return _trainerInvites.any(
          (invite) =>
      invite.athleteEmail.toLowerCase() == normalized &&
          invite.status == InviteStatus.pending,
    );
  }

  void regenerateTeamInviteCode() {
    _teamInviteCode = _generateCode(prefix: 'GS-TEAM');
    notifyListeners();
  }

  void regenerateAthleteShareCode() {
    _athleteShareCode = _generateCode(prefix: 'GS-ATH');
    notifyListeners();
  }

  void sendTrainerInvite({
    required String athleteEmail,
  }) {
    final normalized = athleteEmail.trim().toLowerCase();
    if (normalized.isEmpty || containsPendingTrainerInvite(normalized)) return;

    final inviteId = DateTime.now().microsecondsSinceEpoch.toString();

    _trainerInvites.add(
      TrainerInvite(
        id: inviteId,
        athleteEmail: normalized,
        sentAt: DateTime.now(),
        status: InviteStatus.pending,
      ),
    );

    _incomingConnectionRequests.add(
      ConnectionRequest(
        id: 'req_$inviteId',
        requesterName: _trainerDisplayName,
        requesterSubtitle: '$_teamName • Trainer',
        email: _buildTrainerEmail(),
        type: RequesterType.trainer,
        message:
        '$_trainerDisplayName wants to connect to your athlete profile for team monitoring.',
        requestedAt: DateTime.now(),
        status: InviteStatus.pending,
        linkedTrainerInviteId: inviteId,
        targetAthleteEmail: normalized,
      ),
    );

    notifyListeners();
  }

  void bulkInviteAthletes(List<String> emails) {
    for (final email in emails) {
      sendTrainerInvite(athleteEmail: email);
    }
  }

  void sendParentAccessRequest({
    required String email,
    required String relationship,
  }) {
    final normalized = email.trim().toLowerCase();
    if (normalized.isEmpty) return;

    final displayName = _formatDisplayName(normalized.split('@').first);

    _incomingConnectionRequests.add(
      ConnectionRequest(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        requesterName: displayName,
        requesterSubtitle: '$relationship • Parent',
        email: normalized,
        type: RequesterType.parent,
        message: '$displayName wants to monitor your health data as your '
            '${relationship.toLowerCase()}.',
        requestedAt: DateTime.now(),
        status: InviteStatus.pending,
        targetAthleteEmail: normalized,
      ),
    );

    notifyListeners();
  }

  void reviewIncomingRequest({
    required String requestId,
    required bool approved,
  }) {
    final index = _incomingConnectionRequests.indexWhere((r) => r.id == requestId);
    if (index == -1) return;

    final request = _incomingConnectionRequests[index];
    final nextStatus = approved ? InviteStatus.approved : InviteStatus.denied;

    _incomingConnectionRequests[index] = request.copyWith(status: nextStatus);

    if (request.type == RequesterType.trainer &&
        request.linkedTrainerInviteId != null) {
      final inviteIndex = _trainerInvites.indexWhere(
            (invite) => invite.id == request.linkedTrainerInviteId,
      );

      if (inviteIndex != -1) {
        _trainerInvites[inviteIndex] =
            _trainerInvites[inviteIndex].copyWith(status: nextStatus);
      }

      if (approved) {
        _addAthleteToRosterIfMissing(request.targetAthleteEmail);
      }
    }

    notifyListeners();
  }

  void removeInvite(String inviteId) {
    _trainerInvites.removeWhere((invite) => invite.id == inviteId);
    notifyListeners();
  }

  String timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 60) {
      final mins = difference.inMinutes == 0 ? 1 : difference.inMinutes;
      return 'Requested $mins minute${mins == 1 ? '' : 's'} ago';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'Requested $hours hour${hours == 1 ? '' : 's'} ago';
    }

    final days = difference.inDays;
    return 'Requested $days day${days == 1 ? '' : 's'} ago';
  }

  void _addAthleteToRosterIfMissing(String email) {
    final normalized = email.trim().toLowerCase();
    if (containsAthleteEmail(normalized)) return;

    final base = normalized.split('@').first;
    final formattedName = _formatDisplayName(base);

    _athletes.add(
      Athlete(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: formattedName,
        email: normalized,
        role: 'Unassigned',
        eventText: 'Awaiting live data',
        riskLevel: RiskLevel.low,
        impactValue: '--',
        isConnected: false,
        age: 0,
        heartRate: '--',
        lastImpact: '--',
        deviceStatus: 'Pending Connection',
      ),
    );
  }

  String _buildTrainerEmail() {
    final base = _trainerDisplayName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '.')
        .replaceAll(RegExp(r'^\.+|\.+$'), '');

    final fallback = base.isEmpty ? 'coach' : base;
    return '$fallback@guardsync.app';
  }

  String _generateCode({required String prefix}) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final suffix = List.generate(
      5,
          (_) => chars[_random.nextInt(chars.length)],
    ).join();
    return '$prefix-$suffix';
  }

  static String _formatDisplayName(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    if (cleaned.isEmpty) return 'New User';

    return cleaned
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}