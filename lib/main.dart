// main.dart
import 'package:flutter/material.dart';
import 'package:intel/screens/cre_acc_screen2.dart';

import 'package:intel/screens/doc_acc.dart';
import 'package:intel/screens/doc_dashboard.dart';
import 'package:intel/screens/doctor_login_screen.dart';
import 'package:intel/screens/pat_acc.dart';
import 'package:intel/screens/patient_login_screen.dart';
import 'package:intel/screens/splash_screen.dart';
import 'package:intel/screens/user_selection_screen.dart';
import 'package:intel/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IntelAI-MediLocker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/user-selection': (context) => const EnhancedUserSelectionScreen(),
        '/doctor-login': (context) => const DoctorLoginScreen(),
        '/patient-login': (context) => const PatientLoginScreen(),
        '/doctor-dashboard': (context) => const DoctorDashboard(),
        '/doctor-create-account': (context) => const DoctorApp(),
        '/patient-create-account': (context) => const PatientApp(),
        '/cre_acc_screen2': (context) => const CreAccScreen2(),
        '/doc_acc': (context) => const DoctorApp(),
        '/pat_acc': (context) => const PatientApp(),


      },
    );
  }
}


