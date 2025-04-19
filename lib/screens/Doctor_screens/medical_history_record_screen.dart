import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intel/screens/Doctor_screens/summarization_screen.dart';
import 'package:intel/screens/Doctor_screens/update_medical_record_screen.dart';

class MedicalHistoryScreen extends StatelessWidget {
  final String patientName;
  final String patientEmail;
  final String patientPhone;

  const MedicalHistoryScreen({
    Key? key,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[100]!,
                  Colors.green[100]!,
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildPatientInfo(),
                  _buildMedicalRecordsTable(context),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Medical History of $patientName',
        style: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue[900],
        ),
      ).animate()
          .fadeIn(duration: 500.ms)
          .slideY(begin: -0.5, end: 0.0),
    );
  }

  Widget _buildPatientInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                Hero(
                  tag: 'patient_avatar',
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      '',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Age: 32 | Blood Group: O+',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate()
          .fadeIn(duration: 600.ms)
          .slideX(begin: -0.5, end: 0.0),
    );
  }

  Widget _buildMedicalRecordsTable(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical Records',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ).animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: -0.5, end: 0.0),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: DataTable(
                    columnSpacing: 20,
                    dataRowHeight: 60,
                    headingRowColor: MaterialStateProperty.all(Colors.white.withOpacity(0.5)),
                    columns: [
                      _buildDataColumn('Date'),
                      _buildDataColumn('Doctor'),
                      _buildDataColumn('Diagnosis'),
                      _buildDataColumn('Prescribed Medicines'),
                      _buildDataColumn('Prescription'),
                    ],
                    rows: _buildMedicalRecords(),
                  ),
                ),
              ),
            ),
          ).animate()
              .fadeIn(duration: 700.ms)
              .slideY(begin: 0.5, end: 0.0),
        ],
      ),
    );
  }

  List<DataRow> _buildMedicalRecords() {
    final records = [
      // First set of records
      ['2025-02-17', 'Dr. Abdullah', 'Fever', 'Dolo', 'Fever for 2 days and light cough'],
      ['2025-02-17', 'Dr. Abdullah', 'Cold', 'Serup & Dolo', 'Cold from last 3 days, dry throat'],
      ['2025-02-18', 'Dr. Madhumitha', 'Fever', 'Paracetamol & Cough Serup', 'Cold, cough, and headache from last 1 week'],
      ['2025-02-18', 'Dr. Abdullah', 'Rashes', 'Cetirizine', 'Getting red rashes on skin frequently in 2 days'],

      // Second set of records
      ['2025-02-26', 'Dr. Madhumitha', 'Allergens', 'Budesonide', 'Avoid allergens'],
      ['2025-02-26', 'Dr. Amar', 'Root Canal Treatment', 'Tinidazole, Naproxen, Prednisolone', 'Complete antibiotic course and avoid chewing on treated side'],
      ['2025-02-26', 'Dr. Dayanidhi', 'Acid Reflux', 'Omeprazole, Ranitidine, Sucralfate', 'Avoid spicy food and eat small meals'],
      ['2025-02-26', 'Dr. Abdullah', 'Migraine', 'Sumatriptan, Naproxen, Propranolol', 'Avoid triggers and stay hydrated'],
      ['2025-02-26', 'Dr. Madhumitha', 'Arthritis', 'Ibuprofen, Methotrexate, Celecoxib', 'Take medication and follow joint-friendly exercise routine'],
      ['2025-02-26', 'Dr. Abdullah', 'Fever', 'Dolo', 'Fever for 2 days and light cough'],
      ['2025-02-26', 'Dr. Madhumitha', 'Rashes', 'Cetirizine', 'Getting red rashes on skin frequently in 2 days'],
    ];

    return records.map((record) => _buildMedicalRecord(
      record[0], record[1], record[2], record[3], record[4],
    )).toList();
  }

  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          color: Colors.blue[900],
          fontSize: 14,
        ),
      ),
    );
  }

  DataRow _buildMedicalRecord(
      String date,
      String doctor,
      String diagnosis,
      String medicines,
      String prescription
      ) {
    return DataRow(
      cells: [
        _buildDataCell(date),
        _buildDataCell(doctor),
        _buildDataCell(diagnosis),
        _buildDataCell(medicines),
        _buildDataCell(prescription),
      ],
    );
  }

  DataCell _buildDataCell(String text) {
    return DataCell(
      Text(
        text,
        style: GoogleFonts.roboto(
          color: Colors.blue[900],
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              context,
              'Update Medication',
              Colors.blue[700]!,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateMedicalRecordsScreen(
                      patientName: 'Barath Kumar',
                      patientAvatar: 'assets/img_1.png',


                      patientId: 'PT24',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            _buildButton(
              context,
              'Summarization',
              Colors.green[700]!,
                  () {
                    // Example in your navigation
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PatientSummaryScreen()),
                    );
              },
            ),
          ],
        ).animate()
            .fadeIn(duration: 800.ms),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 5,
      ),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

}