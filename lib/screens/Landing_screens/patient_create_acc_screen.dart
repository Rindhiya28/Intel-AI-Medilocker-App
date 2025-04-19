
// ignore_for_file: unused_element
// ignore: unused_import
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intel/screens/Landing_screens/register_user_selection_screen.dart';
import 'package:intel/screens/Landing_screens/doctor_login_screen.dart';
import 'package:intel/screens/Landing_screens/patient_login_screen.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const PatientApp());
}

class PatientApp extends StatelessWidget {
  const PatientApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Patient Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // Updated primary color
          primary: const Color(0xFF2563EB),
          secondary: const Color(0xFF6366F1),
          tertiary: const Color(0xFFF59E0B),
          surface: Colors.white,
          background: const Color(0xFFF8FAFC),
          error: const Color(0xFFEF4444),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFF1E293B),
          onBackground: const Color(0xFF1E293B),
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          bodySmall: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
          ),
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          prefixIconColor: const Color(0xFF2563EB),
          suffixIconColor: const Color(0xFF64748B),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF2563EB),
            side: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF2563EB),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 3,
          shadowColor: const Color(0xFF475569).withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: const Color(0xFFE2E8F0), width: 1),
          ),
          color: Colors.white,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return const Color(0xFF2563EB);
            }
            return Colors.white;
          }),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return const Color(0xFF2563EB);
            }
            return const Color(0xFF94A3B8);
          }),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFF2563EB),
          linearTrackColor: Color(0xFFE2E8F0),
        ),
      ),
      home: const PatientRegistrationScreen(),
    );
  }
}

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<PatientRegistrationScreen> createState() => _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aadharNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _selectedGender = 'Male';
  DateTime? _selectedDate;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _aadharNumberFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuint),
    );

    _animationController.forward();

    // Add listeners to focus nodes for better error UI feedback
    _nameFocus.addListener(_handleFocusChange);
    _emailFocus.addListener(_handleFocusChange);
    _phoneFocus.addListener(_handleFocusChange);
    _aadharNumberFocus.addListener(_handleFocusChange);
    _addressFocus.addListener(_handleFocusChange);
    _passwordFocus.addListener(_handleFocusChange);
    _confirmPasswordFocus.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      // This forces a rebuild when focus changes for better visual feedback
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _aadharNumberController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocus.removeListener(_handleFocusChange);
    _nameFocus.dispose();
    _emailFocus.removeListener(_handleFocusChange);
    _emailFocus.dispose();
    _phoneFocus.removeListener(_handleFocusChange);
    _phoneFocus.dispose();
    _aadharNumberFocus.removeListener(_handleFocusChange);
    _aadharNumberFocus.dispose();
    _addressFocus.removeListener(_handleFocusChange);
    _addressFocus.dispose();
    _passwordFocus.removeListener(_handleFocusChange);
    _passwordFocus.dispose();
    _confirmPasswordFocus.removeListener(_handleFocusChange);
    _confirmPasswordFocus.dispose();

    _animationController.dispose();
    super.dispose();
  }

  // Formatted phone number method
  String _formatPhoneNumber(String text) {
    if (text.length <= 5) return text;
    if (text.length <= 8) return '${text.substring(0, 5)}-${text.substring(5)}';
    return '${text.substring(0, 5)}-${text.substring(5, 8)}-${text.substring(8)}';
  }

  // Formatted Aadhar number method
  String _formatAadharNumber(String text) {
    if (text.length <= 4) return text;
    if (text.length <= 8) return '${text.substring(0, 4)} ${text.substring(4)}';
    return '${text.substring(0, 4)} ${text.substring(4, 8)} ${text.substring(8)}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2563EB),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
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

  bool _validatePassword() {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Passwords do not match');
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _validatePassword() && _agreedToTerms) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Successfully registered, navigate to success screen
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const RegistrationSuccessScreen(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 0.1);
              const end = Offset.zero;
              const curve = Curves.easeOutQuint;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              );
            },
          ),
        );
      }
    } else if (!_agreedToTerms) {
      _showErrorSnackBar('Please agree to the terms and conditions to continue');
    }
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildAccountInfoStep();
      default:
        return Container();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Field
            _buildFieldLabel('Full Name', true),
            _buildAnimatedField(
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocus,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person_outline),
                  suffixIcon: _nameController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.check_circle, color: Color(0xFF10B981)),
                    onPressed: null,
                  )
                      : null,
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (val) => setState(() {}),
              ),
            ),
            const SizedBox(height: 24),

            // Email Field
            _buildFieldLabel('Email Address', true),
            _buildAnimatedField(
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_phoneFocus),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onChanged: (val) => setState(() {}),
              ),
            ),
            const SizedBox(height: 24),

            // Phone and Aadhar in a row for larger screens
            LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Phone Number', true),
                              _buildAnimatedField(
                                _buildPhoneField(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Aadhar Number', true),
                              _buildAnimatedField(
                                _buildAadharField(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Phone Number', true),
                        _buildAnimatedField(_buildPhoneField()),
                        const SizedBox(height: 24),
                        _buildFieldLabel('Aadhar Number', true),
                        _buildAnimatedField(_buildAadharField()),
                      ],
                    );
                  }
                }
            ),
            const SizedBox(height: 24),

            // Address Field
            _buildFieldLabel('Address', true),
            _buildAnimatedField(
              TextFormField(
                controller: _addressController,
                focusNode: _addressFocus,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter your full address',
                  prefixIcon: Icon(Icons.home_outlined),
                  alignLabelWithHint: true,
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onChanged: (val) => setState(() {}),
              ),
            ),
            const SizedBox(height: 20),

            // Gender and DOB in a row for larger screens
            LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Gender', true),
                              _buildAnimatedField(
                                _buildGenderSelector(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Date of Birth', true),
                              _buildAnimatedField(
                                _buildDateField(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Gender', true),
                        _buildAnimatedField(_buildGenderSelector()),
                        const SizedBox(height: 24),
                        _buildFieldLabel('Date of Birth', true),
                        _buildAnimatedField(_buildDateField()),
                      ],
                    );
                  }
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      focusNode: _phoneFocus,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: const InputDecoration(
        hintText: 'Enter your 10-digit phone number',
        prefixIcon: Icon(Icons.phone_outlined),
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_aadharNumberFocus),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        } else if (value.length < 10) {
          return 'Phone number must be 10 digits';
        }
        return null;
      },
      onChanged: (val) => setState(() {}),
    );
  }

  Widget _buildAadharField() {
    return TextFormField(
      controller: _aadharNumberController,
      focusNode: _aadharNumberFocus,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12),
      ],
      decoration: const InputDecoration(
        hintText: 'Enter your Aadhar number',
        prefixIcon: Icon(Icons.credit_card_outlined),
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_addressFocus),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Aadhar number';
        } else if (value.length != 12) {
          return 'Aadhar number must be 12 digits';
        }
        return null;
      },
      onChanged: (val) => setState(() {}),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildGenderOption('Male', Icons.male_outlined),
              const SizedBox(width: 8),
              _buildGenderOption('Female', Icons.female_outlined),
              const SizedBox(width: 8),
              _buildGenderOption('Other', Icons.person_outline),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String value, IconData icon) {
    final bool isSelected = _selectedGender == value;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedGender = value;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2563EB).withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'DD/MM/YYYY',
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        suffixIcon: _dobController.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.edit_calendar_outlined, color: Color(0xFF2563EB)),
          onPressed: () => _selectDate(context),
        )
            : null,
      ),
      onTap: () => _selectDate(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your date of birth';
        }
        return null;
      },
    );
  }

  Widget _buildAccountInfoStep() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        // Security header
        Row(
        children: [
        Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.security,
          color: Color(0xFF2563EB),
          size: 20,
        ),
      ),
      const SizedBox(width: 12),
      const Text(
        'Account Security',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
      ],
    ),

    const SizedBox(height: 6),
    Padding(
    padding: const EdgeInsets.only(left: 42.0),
    child: Text(
    'Create a strong password to secure your account.',
    style: TextStyle(
    fontSize: 14,
    color: Colors.grey[600],
    ),
    ),
    ),
    const SizedBox(height: 24),

    // Password Field
    _buildFieldLabel('Create Password', true),
    _buildAnimatedField(
    TextFormField(
    controller: _passwordController,
    focusNode: _passwordFocus,
    obscureText: _obscurePassword,
    decoration: InputDecoration(
    hintText: 'Create a secure password',
    prefixIcon: const Icon(Icons.lock_outline),
    suffixIcon: IconButton(
    icon: Icon(
    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
    color: Colors.grey,
    ),
    onPressed: () {
    setState(() {
    _obscurePassword = !_obscurePassword;
    });
    },
    ),
    ),
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPasswordFocus),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Please enter a password';
    } else if (value.length < 8) {
    return 'Password must be at least 8 characters';
    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,}$').hasMatch(value)) {
    return 'Include uppercase, lowercase, number & special character';
    }
    return null;
    },
      onChanged: (val) => setState(() {}),
    ),
    ),
              const SizedBox(height: 24),

              // Confirm Password Field
              _buildFieldLabel('Confirm Password', true),
              _buildAnimatedField(
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirm your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  onChanged: (val) => setState(() {}),
                ),
              ),
              const SizedBox(height: 24),

              // Password strength indicator
              if (_passwordController.text.isNotEmpty)
                _buildPasswordStrengthIndicator(),

              const SizedBox(height: 24),

              // Terms and conditions checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreedToTerms = value ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                              text: 'I agree to the ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Show terms dialog
                                  _showTermsDialog();
                                },
                            ),
                            const TextSpan(
                              text: ' and ',
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Show privacy policy dialog
                                  _showPrivacyPolicyDialog();
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    // Calculate password strength
    final String password = _passwordController.text;
    double strength = 0;

    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]')) || password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    String strengthText = 'Weak';
    Color strengthColor = const Color(0xFFEF4444);

    if (strength >= 0.75) {
      strengthText = 'Strong';
      strengthColor = const Color(0xFF10B981);
    } else if (strength >= 0.5) {
      strengthText = 'Medium';
      strengthColor = const Color(0xFFF59E0B);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password Strength:',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Text(
              strengthText,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: strengthColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: strength,
            backgroundColor: const Color(0xFFE2E8F0),
            color: strengthColor,
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildPasswordRequirement(
              '8+ Characters',
              password.length >= 8,
            ),
            _buildPasswordRequirement(
              'Uppercase (A-Z)',
              password.contains(RegExp(r'[A-Z]')),
            ),
            _buildPasswordRequirement(
              'Lowercase (a-z)',
              password.contains(RegExp(r'[a-z]')),
            ),
            _buildPasswordRequirement(
              'Number or Symbol',
              password.contains(RegExp(r'[0-9]')) || password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordRequirement(String requirement, bool isMet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.check_circle_outline,
          size: 16,
          color: isMet ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
        ),
        const SizedBox(width: 6),
        Text(
          requirement,
          style: TextStyle(
            fontSize: 12,
            color: isMet ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'These Terms of Service ("Terms") govern your use of our patient registration application. By using our application, you agree to these terms in full. If you disagree with any part of these terms, you must not use our application.\n\n'
                'Our application is designed to collect and process personal and medical information for patient registration purposes. We are committed to protecting your privacy and handling your data in accordance with applicable laws and regulations.\n\n'
                'You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'This Privacy Policy describes how we collect, use, and share your personal information when you use our patient registration application.\n\n'
                'We collect information you provide directly to us, including your name, email address, phone number, Aadhar number, date of birth, gender, address, and other information you choose to provide.\n\n'
                'We use your information to provide our services, communicate with you, improve our application, and comply with legal obligations.\n\n'
                'We may share your information with healthcare providers, as necessary to provide medical services, and with service providers who perform services on our behalf.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
          if (isRequired)
            Text(
              ' *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedField(Widget child) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    // Header
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            color: Color(0xFF2563EB),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Intel-Medilocker',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'Patient Registration',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentStep == 0
                          ? 'Please provide your personal details to get started.'
                          : 'Create an account to save your information securely.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),

                    // Progress indicator
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Step ${_currentStep + 1} of 2',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: (_currentStep + 1) / 2,
                                backgroundColor: const Color(0xFFE2E8F0),
                                color: const Color(0xFF2563EB),
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${((_currentStep + 1) / 2 * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),

                    // Step content
                    _buildStepContent(_currentStep),

                    // Navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _currentStep--;
                              });
                            },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Back'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              minimumSize: const Size(120, 0),
                            ),
                          )
                        else
                          const SizedBox(width: 120),

                        ElevatedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () {
                            if (_currentStep < 1) {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _currentStep++;
                                });
                              }
                            } else {
                              _submitForm();
                            }
                          },
                          icon: _isLoading
                              ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Icon(_currentStep < 1 ? Icons.arrow_forward : Icons.check),
                          label: Text(_currentStep < 1 ? 'Next' : 'Register'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            minimumSize: const Size(120, 0),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Are you a doctor?',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DoctorLoginScreen(),
                              ),
                            );
                          },
                          child: const Text('Login here'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF10B981).withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF10B981),
                  size: 80,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Registration Successful!',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your account has been created successfully. You can now log in to access your patient dashboard.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PatientLoginScreen(),
                    ),
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.login),
                label: const Text('Login to Your Account'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreAccScreen2(),
                    ),
                        (route) => false,
                  );
                },
                child: const Text('Return to Home'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}