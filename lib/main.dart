import 'package:flutter/material.dart';
// Import your custom page files
import 'pages/login_page.dart'; 
import 'pages/dashboard_page.dart'; 
import 'pages/role_selection_page.dart'; 
import 'pages/athlete_profile_setup_page.dart'; 
import 'pages/onboarding_page.dart';
import 'pages/calibration_flow_page.dart';
import 'pages/trainer/trainer_dashboard.dart';
import 'pages/trainer/trainer_profile_page.dart';
import 'pages/trainer/add_athletes_page.dart';
import 'pages/trainer/trainer_analytics_page.dart';
import 'pages/parent/parent_profile_page.dart';
import 'pages/parent/link_to_athlete_page.dart';
import 'pages/parent/parent_dashboard_page.dart';
import 'pages/athlete_connection_page.dart';
import 'pages/connection_requests_page.dart';

void main() {
  runApp(const GuardSyncApp());
}

class GuardSyncApp extends StatelessWidget {
  const GuardSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GuardSync',
      theme: ThemeData(
        // Set the global background color to match your design palette
        scaffoldBackgroundColor: const Color(0xFFF5F5F0),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      
      // Set the LoginPage as the initial screen of the app
      home: const LoginPage(),
      routes: {
        '/role': (context) => const RoleSelectionPage(),
        '/profile': (context) => const ProfileSetupPage(),
        '/flow-diagram': (context) =>
            const Scaffold(body: Center(child: Text('User Flow Diagram'))),
        '/onboarding': (context) => const OnboardingPage(),
        '/calibration-flow': (context) => const CalibrationFlowPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/trainer-dashboard': (context) => const TrainerDashboardPage(),
        '/trainer-profile': (context) => const TrainerProfilePage(),
        '/add-athletes': (context) => const AddAthletesPage(),
        '/trainer-analytics': (context) => const TrainerAnalyticsPage(),
        '/parent-profile': (context) => const ParentProfilePage(),
        '/link-to-athlete': (context) => const LinkToAthletePage(),
        '/parent-dashboard': (context) => const ParentDashboardPage(),
        '/parent-analytics': (context) => const TrainerAnalyticsPage(),
        '/athlete-connections': (context) => const AthleteConnectionPage(),
        '/connection-requests': (context) => const ConnectionRequestsPage(),
      },
    );
  }
}