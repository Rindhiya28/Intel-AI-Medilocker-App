// main.dart
import 'package:flutter/material.dart';
import 'package:intel/screens/Landing_screens/admin_login_screen.dart';
import 'package:intel/screens/Landing_screens/splash_screen.dart';
import 'package:intel/screens/Landing_screens/welcome_screen.dart';
import 'package:intel/screens/Landing_screens/register_user_selection_screen.dart';
import 'package:intel/screens/Landing_screens/doctor_create_acc_screen.dart';
import 'package:intel/screens/Landing_screens/patient_create_acc_screen.dart';
import 'package:intel/screens/Landing_screens/login_user_selection_screen.dart';
import 'package:intel/screens/Landing_screens/doctor_login_screen.dart';
import 'package:intel/screens/Landing_screens/patient_login_screen.dart';
import 'package:intel/screens/Doctor_screens/doctor_dashboard.dart';
import 'package:intel/screens/Patient_screens/patient_dashboard.dart';


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
        '/admin-login': (context) => const AdminLoginScreen(),
        '/doctor-dashboard': (context) => const DoctorDashboard(),
        '/patient-dashboard': (context) => const PatientDashboard(),
        '/doctor-create-account': (context) => const DoctorApp(),
        '/patient-create-account': (context) => const PatientApp(),
        '/cre_acc_screen2': (context) => const CreAccScreen2(),
        '/doc_acc': (context) => const DoctorApp(),
        '/pat_acc': (context) => const PatientApp(),




      },
    );
  }

}


