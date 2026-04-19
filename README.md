# Step 1
```git clone https://github.com/YourUsername/GuardSync.git```
# Step 2
In your project root directory running: ```flutter pub get```

Also, it would be better to check whether everything is ready using: ```flutter doctor```
# Step 3 
Click run on your device or simulator.



## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## 📁 Project Structure & Architecture

Our project follows a modular architecture, separating the UI (Pages), Business Logic (Services), and Data Structures (Models). This ensures the codebase is scalable, maintainable, and ready for future hardware/cloud integration.

```text
lib/
├── main.dart
├── model/
│   ├── analytics_models.dart
│   └── athlete_metrics.dart
├── pages/
│   ├── parent/
│   │   ├── link_to_athlete_page.dart
│   │   ├── parent_dashboard_page.dart
│   │   └── parent_profile_page.dart
│   ├── trainer/
│   ├── athlete_connection_page.dart
│   ├── athlete_profile_setup_page.dart
│   ├── calibration_flow_page.dart
│   ├── connection_requests_page.dart
│   ├── dashboard_page.dart
│   ├── login_page.dart
│   ├── onboarding_page.dart
│   ├── role_selection_page.dart
│   └── trainer_analytics_page.dart
└── services/
    ├── analytics_data_service.dart
    ├── athlete_data_service.dart
    └── mock_bluetooth_service.dart


📂 Directory Details

1. Models (lib/model/)

This folder contains the blueprints for our data structures. No UI or complex logic should be placed here.

athlete_metrics.dart: Defines the data structure for real-time vital signs (Heart Rate, SpO2, Body Temp, Bite Force, Head Acceleration).

analytics_models.dart: Defines the structures for historical chart data, including ChartPoint, MetricSummary, and AnalyticsBundle.

2. Services (lib/services/)

This folder handles all data generation, state management, and future API/Database communications. It acts as the "Single Source of Truth" for the app.

mock_bluetooth_service.dart: Simulates the hardware mouthguard by generating random, realistic physiological data streams using a Timer. (To be replaced by actual Bluetooth Serial logic later).

athlete_data_service.dart: The centralized hub that listens to the Bluetooth stream, stores the current real-time metrics, and broadcasts updates to all active UI dashboards simultaneously.

analytics_data_service.dart: Provides pre-calculated historical data bundles (30m, 1hr, 3hr, 24hr) to populate the charts in the Analytics page.

3. Pages / UI (lib/pages/)

Contains all the visual screens and UI components. These files only handle rendering and user interactions, reading their data directly from the services/.

dashboard_page.dart: The primary real-time monitoring interface for the Athlete.

parent/parent_dashboard_page.dart: The synchronized real-time monitoring interface for the Parent, sharing the same data source as the athlete.

trainer_analytics_page.dart: The interactive history page displaying interactive bar charts and performance trends over time.

calibration_flow_page.dart: The step-by-step onboarding UI for calibrating the smart mouthguard (Bite Force & Resting Jaw).

onboarding_page.dart & login_page.dart: Initial app startup, authentication, and role selection screens.