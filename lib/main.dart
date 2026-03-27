import 'package:flutter/material.dart';
// Import your custom page files
import 'pages/login_page.dart'; 
import 'pages/dashboard_page.dart'; 
import 'pages/role_selection_page.dart'; 
import 'pages/athlete_profile_setup_page.dart'; 
import 'pages/onboarding_page.dart';
import 'pages/calibration_flow_page.dart';
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

      // Define navigation routes to prevent crashes when navigating
      routes: {
        '/role': (context) => const RoleSelectionPage(),
        '/profile': (context) => const ProfileSetupPage(),
        '/flow-diagram': (context) => const Scaffold(body: Center(child: Text('User Flow Diagram'))),
        '/onboarding': (context) => const OnboardingPage(),
        '/calibration-flow': (context) => const CalibrationFlowPage(),
        '/dashboard':(context) => const DashboardPage(),

      },
    );
  }
}