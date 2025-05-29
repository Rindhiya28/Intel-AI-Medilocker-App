import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

// Constants
class AppConstants {
  static const String appName = 'Predict Side Effect';
  // Fixed baseUrl - removed the endpoint from the base URL
  static const String apiBaseUrl = 'http://192.168.1.35:5001/check-medicine';
  // Color Palette
  static const Color primaryColor = Color(0xFF3A6EA5);
  static const Color secondaryColor = Color(0xFF5D9CEC);
  static const Color accentColor = Color(0xFF4A8CFF);
  static const Color lightBlueColor = Color(0xFFE3F2FD);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color successColor = Color(0xFF48DBAE);
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF2D3748);
  static const Color textSecondaryColor = Color(0xFF718096);
}

// Data Models
class MedicineSafetyResult {
  final bool isSafe;
  final String message;
  final List<String> recommendedMedicines;

  MedicineSafetyResult({
    required this.isSafe,
    required this.message,
    this.recommendedMedicines = const [],
  });

  factory MedicineSafetyResult.fromJson(Map<String, dynamic> json) {
    return MedicineSafetyResult(
      isSafe: json['is_safe'] ?? false,
      message: json['message'] ?? 'No result available',
      recommendedMedicines: List<String>.from(json['recommended_medicines'] ?? []),
    );
  }
}

// Service Layer
class MedicineSafetyService {
  static Future<MedicineSafetyResult> checkMedicineSafety({
    required String patientId,
    required String medicineName,
    required String currentDiagnosis,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.apiBaseUrl), // Removed duplicate /check-medicine
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'patient_id': patientId.trim(),
          'medicine_name': medicineName.trim(),
          'current_diagnosis': currentDiagnosis.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return MedicineSafetyResult.fromJson(responseData['data']);
      } else {
        throw Exception('Failed to check medicine safety: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

// Main Application
class MedicineSafetyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primaryColor: AppConstants.primaryColor,
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: AppConstants.textPrimaryColor,
            displayColor: AppConstants.textPrimaryColor,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryColor,
          ),
          iconTheme: IconThemeData(color: AppConstants.primaryColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
          ),
          hintStyle: TextStyle(color: AppConstants.textSecondaryColor.withOpacity(0.7)),
          labelStyle: TextStyle(color: AppConstants.textSecondaryColor),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          color: AppConstants.cardColor,
        ),
      ),
      home: MedicineSafetyCheckScreen(),
    );
  }
}

// Main Screen
class MedicineSafetyCheckScreen extends StatefulWidget {
  @override
  _MedicineSafetyCheckScreenState createState() => _MedicineSafetyCheckScreenState();
}

class _MedicineSafetyCheckScreenState extends State<MedicineSafetyCheckScreen> {
  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientIdController = TextEditingController(text: '1');
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _currentDiagnosisController = TextEditingController();

  // State Variables
  bool _isLoading = false;
  MedicineSafetyResult? _safetyResult;
  String? _errorMessage;

  // Form Validation
  String? _validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  // Medicine Safety Check Method
  Future<void> _checkMedicineSafety() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _safetyResult = null;
      _errorMessage = null;
    });

    try {
      final result = await MedicineSafetyService.checkMedicineSafety(
        patientId: _patientIdController.text.trim(),
        medicineName: _medicineNameController.text.trim(),
        currentDiagnosis: _currentDiagnosisController.text.trim(),
      );

      setState(() {
        _safetyResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      _showErrorSnackBar(e.toString());
    }
  }

  // Error Handling
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: AppConstants.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              AppConstants.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Header
                  _buildAppHeader()
                      .animate()
                      .fadeIn(duration: Duration(milliseconds: 600))
                      .moveY(begin: -20, end: 0),
                  const SizedBox(height: 30),
                  // Form Card
                  _buildFormCard()
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 300))
                      .scale(),
                  const SizedBox(height: 24),
                  // Submit Button
                  _buildSubmitButton()
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 500)),
                  const SizedBox(height: 24),
                  // Error Message
                  if (_errorMessage != null)
                    _buildErrorMessage(_errorMessage!)
                        .animate()
                        .fadeIn()
                        .scale()
                        .moveY(begin: 20, end: 0),
                  // Result Display
                  if (_isLoading)
                    _buildLoadingResult()
                        .animate()
                        .fadeIn()
                        .shimmer(duration: Duration(seconds: 1), curve: Curves.easeInOut)
                  else if (_safetyResult != null)
                    _buildSafetyResult(_safetyResult!)
                        .animate()
                        .fadeIn()
                        .scale()
                        .moveY(begin: 20, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Error Message Widget
  Widget _buildErrorMessage(String message) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.errorColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppConstants.errorColor),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                color: AppConstants.errorColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // App Header Widget
  Widget _buildAppHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.medical_services_rounded,
            size: 40,
            color: AppConstants.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppConstants.appName,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Verify medication safety for your diagnosis',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppConstants.textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Form Card Widget
  Widget _buildFormCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Information',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            // Patient ID Input
            _buildTextFormField(
              controller: _patientIdController,
              label: 'Patient ID',
              hint: 'Enter Patient ID',
              validator: _validateInput,
              keyboardType: TextInputType.number,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
            // Medicine Name Input
            _buildTextFormField(
              controller: _medicineNameController,
              label: 'Medicine Name',
              hint: 'Enter Medicine Name',
              validator: _validateInput,
              icon: Icons.medication_outlined,
            ),
            const SizedBox(height: 20),
            // Current Diagnosis Input
            _buildTextFormField(
              controller: _currentDiagnosisController,
              label: 'Current Diagnosis',
              hint: 'Enter Current Diagnosis',
              validator: _validateInput,
              icon: Icons.health_and_safety_outlined,
            ),
          ],
        ),
      ),
    );
  }

  // Submit Button Widget
  Widget _buildSubmitButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor,
            AppConstants.secondaryColor,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _checkMedicineSafety,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 22),
            SizedBox(width: 12),
            Text(
              'Check Medicine Safety',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom TextFormField Widget
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Container(
                margin: EdgeInsets.only(left: 12, right: 8),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppConstants.primaryColor,
                  size: 22,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppConstants.primaryColor.withOpacity(0.3), width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppConstants.errorColor.withOpacity(0.5), width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppConstants.errorColor, width: 1.5),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            keyboardType: keyboardType,
            validator: validator,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppConstants.textPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  // Loading Result Placeholder
  Widget _buildLoadingResult() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 100,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 150,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Safety Result Display
  Widget _buildSafetyResult(MedicineSafetyResult result) {
    final Color backgroundColor = result.isSafe
        ? AppConstants.successColor.withOpacity(0.9)
        : AppConstants.errorColor.withOpacity(0.9);

    final IconData resultIcon = result.isSafe
        ? Icons.check_circle_rounded
        : Icons.error_rounded;

    final String resultTitle = result.isSafe
        ? 'Safe to Take'
        : 'Predicted Side Effect';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: result.isSafe
              ? [
            Color(0xFF43C6AC),
            Color(0xFF48DBAE),
          ]
              : [
            Color(0xFFFF6B6B),
            Color(0xFFFF8E8E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.4),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      resultIcon,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    resultTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  result.message,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ),
              if (result.recommendedMedicines.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Recommended Alternatives',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: result.recommendedMedicines.map(
                          (medicine) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.medication_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                medicine,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MedicineSafetyApp());
}