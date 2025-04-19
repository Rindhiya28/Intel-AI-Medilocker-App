import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intel/screens/Doctor_screens/predict_side_effect_screen.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:lottie/lottie.dart';

// Enum for Medicine Type with more descriptive icons
enum MedicineType {
  tablet(Icons.medication, 'Tablet'),
  capsule(Icons.medication_outlined, 'Capsule'),
  liquid(Icons.water_drop_outlined, 'Liquid'),
  injection(Icons.vaccines_outlined, 'Injection');

  final IconData icon;
  final String label;
  const MedicineType(this.icon, this.label);
}

// Prescription Model with additional functionality
class Prescription {
  final String id;
  final String medicineName;
  final String dosage;
  final String frequency;
  final String duration;
  final MedicineType type;
  final DateTime startDate;
  final DateTime endDate;
  final String notes;

  Prescription({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.type,
    required this.startDate,
    required this.endDate,
    this.notes = '',
  });

  // Method to format prescription details
  String get formattedDetails {
    return '$medicineName - $dosage\n$frequency • ${type.label}';
  }
}

class UpdateMedicalRecordsScreen extends StatefulWidget {
  final String patientName;
  final String patientAvatar;
  final String patientId;

  const UpdateMedicalRecordsScreen({
    Key? key,
    required this.patientName,
    required this.patientAvatar,
    required this.patientId,
  }) : super(key: key);

  @override
  _UpdateMedicalRecordsScreenState createState() => _UpdateMedicalRecordsScreenState();
}

class _UpdateMedicalRecordsScreenState extends State<UpdateMedicalRecordsScreen>
    with SingleTickerProviderStateMixin {
  // Form and Controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Date and Type Variables
  late DateTime _startDate;
  late DateTime _endDate;
  late MedicineType _selectedType;
  List<Prescription> _prescriptions = [];

  // Animation Controller
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeDates();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..forward();
  }

  void _initializeDates() {
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 7));
    _selectedType = MedicineType.tablet;
  }

  void _addPrescription() {
    if (_validatePrescriptionForm()) {
      final prescription = Prescription(
        id: const Uuid().v4(),
        medicineName: _medicineNameController.text,
        dosage: _dosageController.text,
        frequency: _frequencyController.text,
        duration: _durationController.text,
        type: _selectedType,
        startDate: _startDate,
        endDate: _endDate,
        notes: _notesController.text,
      );
      setState(() {
        _prescriptions.add(prescription);
        _clearPrescriptionForm();
      });
    }
  }

  bool _validatePrescriptionForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  void _clearPrescriptionForm() {
    _medicineNameController.clear();
    _dosageController.clear();
    _frequencyController.clear();
    _durationController.clear();
    _notesController.clear();
    setState(() {
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(days: 7));
      _selectedType = MedicineType.tablet;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: _buildDatePickerTheme(context),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 7));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  ThemeData _buildDatePickerTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: Colors.blueAccent,
        onPrimary: Colors.white,
        surface: const Color(0xFF303030),
        onSurface: Colors.white,
      ),
      dialogBackgroundColor: const Color(0xFF202020),
    );
  }

  void _updateMedicalRecords() {
    if (_diagnosisController.text.isNotEmpty && _prescriptions.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/success_animation.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  print('Lottie Animation Error: $error');
                  return Text('Animation failed to load: $error');
                },
              ),
              Text(
                'Medical Records Updated Successfully!',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please complete diagnosis and add at least one prescription',
            style: GoogleFonts.roboto(),
          ),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildDiagnosisSection(),
                    const SizedBox(height: 16),
                    _buildPrescriptionSection(),
                    const SizedBox(height: 16),
                    _buildPrescriptionList(),
                    const SizedBox(height: 16),
                    _buildUpdateRecordsButton(),
                    const SizedBox(height: 16),
                    _buildSideEffectsPredictionButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Hero(
              tag: 'patient_avatar_${widget.patientId}',
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(widget.patientAvatar),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patientName,
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                Text(
                  'Patient ID: ${widget.patientId}',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.blue[900], size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildDiagnosisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Diagnosis',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _diagnosisController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a diagnosis';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter diagnosis details',
            hintStyle: GoogleFonts.roboto(color: Colors.grey[500]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[100]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[100]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildPrescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Prescription',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _medicineNameController,
          label: 'Medicine Name',
          icon: Icons.medication,
          validator: (value) => value?.isEmpty ?? true ? 'Enter medicine name' : null,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _dosageController,
          label: 'Dosage',
          icon: Icons.speed,
          validator: (value) => value?.isEmpty ?? true ? 'Enter dosage' : null,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _frequencyController,
          label: 'Frequency',
          icon: Icons.repeat,
          hintText: 'e.g. Twice a day',
          validator: (value) => value?.isEmpty ?? true ? 'Enter frequency' : null,
        ),
        const SizedBox(height: 12),
        _buildMedicineTypeSelector(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: 'Start Date',
                date: _startDate,
                onTap: () => _selectDate(context, true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateField(
                label: 'End Date',
                date: _endDate,
                onTap: () => _selectDate(context, false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _notesController,
          label: 'Additional Notes',
          icon: Icons.note,
          maxLines: 3,
          validator: null,
          hintText: 'Optional notes',
        ),
        const SizedBox(height: 12),
        _buildAddPrescriptionButton(),
      ],
    );
  }

  Widget _buildAddPrescriptionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _addPrescription,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          '+ Add Prescription',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPrescriptionList() {
    if (_prescriptions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prescribed Medicines',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _prescriptions.length,
          itemBuilder: (context, index) {
            final prescription = _prescriptions[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(prescription.type.icon, color: Colors.blue[700]),
                title: Text(
                  prescription.medicineName,
                  style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${prescription.dosage} - ${prescription.frequency}',
                  style: GoogleFonts.roboto(color: Colors.grey[700]),
                ),
                trailing: Text(
                  DateFormat('MMM d, yyyy').format(prescription.startDate),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ).animate(
              effects: [
                FadeEffect(duration: 500.ms, delay: (index * 100).ms),
                SlideEffect(
                  begin: const Offset(0.2, 0),
                  end: Offset.zero,
                  duration: 500.ms,
                  delay: (index * 100).ms,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
  Widget _buildSideEffectsPredictionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>MedicineSafetyCheckScreen(),
            ),
          );
        },  // Direct reference to the navigation method
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Predict Side Effects',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ).animate(
        effects: [
          ScaleEffect(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1, 1),
            duration: 600.ms,
          ),
          ShimmerEffect(
            color: Colors.white.withOpacity(0.3),
            duration: 1500.ms,
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateRecordsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _updateMedicalRecords,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Update Medical Records',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ).animate(
        effects: [
          ScaleEffect(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1, 1),
            duration: 600.ms,
          ),
          ShimmerEffect(
            color: Colors.white.withOpacity(0.3),
            duration: 1500.ms,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?)? validator,
    String? hintText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            color: Colors.blue[900],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.blue[700],
            ),
            hintText: hintText,
            hintStyle: GoogleFonts.roboto(
              color: Colors.grey[500],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[100]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[100]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineTypeSelector() {
    return Row(
      children: MedicineType.values.map((type) =>
          Expanded(
            child: _buildTypeOption(
              type: type,
              label: type.label,
              icon: type.icon,
            ),
          )
      ).toList(),
    );
  }

  Widget _buildTypeOption({
    required MedicineType type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue[700]! : Colors.blue[100]!,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue[900] : Colors.blue[700],
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.roboto(
                color: isSelected ? Colors.blue[900] : Colors.blue[700],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    final dateFormat = DateFormat('MMM d, yyyy');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blue[100]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.roboto(
                color: Colors.blue[900],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.blue[700],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  dateFormat.format(date),
                  style: GoogleFonts.roboto(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _diagnosisController.dispose();
    _medicineNameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}