import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intel/screens/Landing_screens/doctor_login_screen.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const DoctorApp());
}

class DoctorApp extends StatelessWidget {
  const DoctorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor Registration',
      theme: ThemeData(
        primaryColor: const Color(0xFF2A6AD1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2A6AD1),
          primary: const Color(0xFF2A6AD1),
          secondary: const Color(0xFF5D93FB),
        ),
        fontFamily: 'Poppins',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2A6AD1), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A6AD1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: const RegistrationWelcomeScreen(),
    );
  }
}

// Welcome Screen - First page
class RegistrationWelcomeScreen extends StatelessWidget {
  const RegistrationWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A6AD1).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    size: 60,
                    color: Color(0xFF2A6AD1),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Header Title
              const Text(
                'Doctor Registration',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A6AD1),
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle
              const Text(
                'Create your account to join our healthcare platform',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 60),
              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalInfoScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to login screen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DoctorLoginScreen(),
                        ),
                            (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2A6AD1),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data model to store registration data across pages
class RegistrationData {
  String name = '';
  String email = '';
  String phone = '';
  String gender = 'Male';
  String dob = '';
  String licenseNumber = '';
  String specialization = '';
  String workSetting = '';
  String street = '';
  String city = '';
  String state = '';
  String zip = '';
  bool hasClinic = false;
  String clinicName = '';
  String clinicAddress = '';
  String password = '';
}

// Page 1: Personal Information Screen
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _registrationData = RegistrationData();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String _selectedGender = 'Male';
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2A6AD1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF2A6AD1),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2A6AD1),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _registrationData.name = _nameController.text;
      _registrationData.email = _emailController.text;
      _registrationData.phone = _phoneController.text;
      _registrationData.gender = _selectedGender;
      _registrationData.dob = _dobController.text;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfessionalInfoScreen(registrationData: _registrationData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2A6AD1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Step 1 of 4',
          style: TextStyle(color: Color(0xFF2A6AD1)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Personal Information'),
                  const SizedBox(height: 24),

                  _buildFieldLabel('Full Name'),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Enter your full name',
                      prefixIcon: Icon(Icons.person, color: Color(0xFF2A6AD1)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildFieldLabel('Email Address'),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email address',
                      prefixIcon: Icon(Icons.email, color: Color(0xFF2A6AD1)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildFieldLabel('Phone Number'),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Enter your phone number',
                      prefixIcon: Icon(Icons.phone, color: Color(0xFF2A6AD1)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length < 10) {
                        return 'Phone number must be at least 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Gender'),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: DropdownButtonFormField<String>(
                                value: _selectedGender,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isCollapsed: true,
                                ),
                                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2A6AD1)),
                                items: ['Male', 'Female', 'Other'].map((gender) {
                                  return DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Date of Birth'),
                            TextFormField(
                              controller: _dobController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: 'DD/MM/YYYY',
                                prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF2A6AD1)),
                              ),
                              onTap: () => _selectDate(context),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your date of birth';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveAndContinue,
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A6AD1),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF2A6AD1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

// Page 2: Professional Information Screen
class ProfessionalInfoScreen extends StatefulWidget {
  final RegistrationData registrationData;

  const ProfessionalInfoScreen({
    Key? key,
    required this.registrationData,
  }) : super(key: key);

  @override
  State<ProfessionalInfoScreen> createState() => _ProfessionalInfoScreenState();
}

class _ProfessionalInfoScreenState extends State<ProfessionalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _licenseController = TextEditingController();

  // Modified specialization input as a text field instead of dropdown
  final TextEditingController _specializationController = TextEditingController();

  // Updated work setting options
  String _selectedWorkSetting = 'Hospital';
  final List<String> _workSettings = ['Hospital', 'Independent'];

  @override
  void dispose() {
    _licenseController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.registrationData.licenseNumber = _licenseController.text;
      widget.registrationData.specialization = _specializationController.text;
      widget.registrationData.workSetting = _selectedWorkSetting;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddressScreen(registrationData: widget.registrationData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2A6AD1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Step 2 of 4',
          style: TextStyle(color: Color(0xFF2A6AD1)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Professional Details'),
                  const SizedBox(height: 24),

                  _buildFieldLabel('Medical License Number'),
                  TextFormField(
                    controller: _licenseController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintText: 'Enter your license number',
                      prefixIcon: Icon(Icons.badge, color: Color(0xFF2A6AD1)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your license number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Changed to text field for specialization
                  _buildFieldLabel('Specialization'),
                  TextFormField(
                    controller: _specializationController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Enter your specialization',
                      prefixIcon: Icon(Icons.medical_services, color: Color(0xFF2A6AD1)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your specialization';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Modified work setting options
                  _buildFieldLabel('Work Setting'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedWorkSetting,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.business, color: Color(0xFF2A6AD1)),
                        border: InputBorder.none,
                      ),
                      items: _workSettings.map((setting) {
                        return DropdownMenuItem(
                          value: setting,
                          child: Text(setting),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedWorkSetting = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a work setting';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveAndContinue,
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A6AD1),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF2A6AD1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

// Page 3: Address & Clinic Information Screen
class AddressScreen extends StatefulWidget {
  final RegistrationData registrationData;

  const AddressScreen({
    Key? key,
    required this.registrationData,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _clinicAddressController = TextEditingController();

  bool _hasClinic = false;

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _clinicNameController.dispose();
    _clinicAddressController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.registrationData.street = _streetController.text;
      widget.registrationData.city = _cityController.text;
      widget.registrationData.state = _stateController.text;
      widget.registrationData.zip = _zipController.text;
      widget.registrationData.hasClinic = _hasClinic;

      if (_hasClinic) {
        widget.registrationData.clinicName = _clinicNameController.text;
        widget.registrationData.clinicAddress = _clinicAddressController.text;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordScreen(registrationData: widget.registrationData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2A6AD1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Step 3 of 4',
          style: TextStyle(color: Color(0xFF2A6AD1)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Work Address'),
                  const SizedBox(height: 24),

                  _buildFieldLabel('Street Address'),
                  TextFormField(
                    controller: _streetController,
                    decoration: const InputDecoration(
                      hintText: 'Enter street address',
                      prefixIcon: Icon(Icons.location_on, color: Color(0xFF2A6AD1)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your street address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('City'),
                            TextFormField(
                              controller: _cityController,
                              decoration: const InputDecoration(
                                hintText: 'Enter city',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter city';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('State'),
                            TextFormField(
                              controller: _stateController,
                              decoration: const InputDecoration(
                                hintText: 'Enter state',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter state';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildFieldLabel('ZIP/Postal Code'),
                  TextFormField(
                    controller: _zipController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Enter ZIP/Postal code',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter ZIP/Postal code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  _buildSectionHeader('Clinic Information'),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _buildFieldLabel('Do you have a private clinic?'),
                      const SizedBox(width: 16),
                      Switch(
                        value: _hasClinic,
                        activeColor: const Color(0xFF2A6AD1),
                        onChanged: (value) {
                          setState(() {
                            _hasClinic = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (_hasClinic) ...[
                    _buildFieldLabel('Clinic Name'),
                    TextFormField(
                      controller: _clinicNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your clinic name',
                        prefixIcon: Icon(Icons.local_hospital, color: Color(0xFF2A6AD1)),
                      ),
                      validator: (value) {
                        if (_hasClinic && (value == null || value.isEmpty)) {
                          return 'Please enter clinic name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildFieldLabel('Clinic Address'),
                    TextFormField(
                      controller: _clinicAddressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Enter complete clinic address',
                        prefixIcon: Icon(Icons.location_city, color: Color(0xFF2A6AD1)),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (_hasClinic && (value == null || value.isEmpty)) {
                          return 'Please enter clinic address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveAndContinue,
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
        title,
        style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2A6AD1),
    ),
        ),
          const SizedBox(height: 4),
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF2A6AD1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
    );
  }
}

// Page 4: Password & Final Screen
class PasswordScreen extends StatefulWidget {
  final RegistrationData registrationData;

  const PasswordScreen({
    Key? key,
    required this.registrationData,
  }) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _completeRegistration() {
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      _formKey.currentState!.save();

      widget.registrationData.password = _passwordController.text;

      // Submit registration data to the server
      // For demo purposes, we'll just navigate to the success screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => RegistrationSuccessScreen(),
        ),
            (route) => false,
      );
    } else if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2A6AD1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Step 4 of 4',
          style: TextStyle(color: Color(0xFF2A6AD1)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Create Password'),
                  const SizedBox(height: 24),

                  _buildFieldLabel('Password'),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Create a password',
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFF2A6AD1)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Password must be at least 8 characters and include a mix of letters, numbers, and symbols',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildFieldLabel('Confirm Password'),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2A6AD1)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Terms and conditions checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        activeColor: const Color(0xFF2A6AD1),
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black, fontSize: 14),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: const TextStyle(
                                    color: Color(0xFF2A6AD1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Show terms and conditions
                                      showDialog(
                                        context: context,
                                        builder: (context) => const TermsDialog(),
                                      );
                                    },
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: const TextStyle(
                                    color: Color(0xFF2A6AD1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Show privacy policy
                                      showDialog(
                                        context: context,
                                        builder: (context) => const PrivacyDialog(),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _completeRegistration,
                      child: const Text(
                        'Complete Registration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A6AD1),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF2A6AD1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

// Terms & Conditions Dialog
class TermsDialog extends StatelessWidget {
  const TermsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Terms & Conditions'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'By using our healthcare platform, you agree to the following terms:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. You confirm that all information provided during registration is accurate and complete.\n\n'
                  '2. You understand that you are responsible for maintaining the confidentiality of your account credentials.\n\n'
                  '3. You agree to use the platform in compliance with all applicable laws and regulations related to medical practice.\n\n'
                  '4. You understand that the platform does not replace professional medical judgment.\n\n'
                  '5. You acknowledge that all patient data must be handled in accordance with relevant privacy laws.\n\n'
                  '6. These terms are subject to change. We will notify you of any significant updates.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Close',
            style: TextStyle(color: Color(0xFF2A6AD1)),
          ),
        ),
      ],
    );
  }
}
// Privacy Policy Dialog
class PrivacyDialog extends StatelessWidget {
  const PrivacyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Privacy Policy'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Your privacy is important to us. This policy explains how we handle your data:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '1. We collect personal and professional information solely for the purpose of providing our healthcare services.\n\n'
                  '2. Your data is stored securely and protected using industry-standard encryption.\n\n'
                  '3. We do not share your personal information with third parties without your explicit consent, except as required by law.\n\n'
                  '4. We implement appropriate security measures to protect against unauthorized access to your data.\n\n'
                  '5. You have the right to access, correct, or delete your personal information at any time.\n\n'
                  '6. By using our platform, you consent to the collection and use of information as described in this policy.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Close',
            style: TextStyle(color: Color(0xFF2A6AD1)),
          ),
        ),
      ],
    );
  }
}

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A6AD1).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Color(0xFF2A6AD1),
                  ),
                ),
                const SizedBox(height: 32),

                // Success message
                const Text(
                  'Registration Successful!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A6AD1),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Your account has been created successfully. You can now log in to access our healthcare platform.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 48),

                // Go to Login button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to login screen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DoctorLoginScreen(),
                        ),
                            (route) => false,
                      );
                    },
                    child: const Text(
                      'Go to Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
