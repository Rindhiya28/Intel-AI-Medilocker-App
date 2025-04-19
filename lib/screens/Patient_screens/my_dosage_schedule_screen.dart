import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

// Models
class Prescription {
  final String id;
  final String medicineName;
  final String dosage;
  final String frequency;
  final String duration;
  final DateTime startDate;
  final DateTime endDate;
  final String notes;
  final MedicineType type;
  Prescription({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.startDate,
    required this.endDate,
    this.notes = '',
    required this.type,
  });
  Prescription copyWith({
    String? id,
    String? medicineName,
    String? dosage,
    String? frequency,
    String? duration,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    MedicineType? type,
  }) {
    return Prescription(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      type: type ?? this.type,
    );
  }
}
enum MedicineType { tablet, capsule, liquid, injection, topical, other }
// Provider/Controller
class PrescriptionProvider extends ChangeNotifier {
  List<Prescription> _prescriptions = [];
  List<Prescription> _filteredPrescriptions = [];
  bool _isLoading = false;
  String _errorMessage = '';
  FilterOption _currentFilter = FilterOption.all;
  SortOption _currentSort = SortOption.newest;

  List<Prescription> get prescriptions => _filteredPrescriptions;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FilterOption get currentFilter => _currentFilter;
  SortOption get currentSort => _currentSort;

  PrescriptionProvider() {
    loadPrescriptions();
  }

  Future<void> loadPrescriptions() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call with delay
      await Future.delayed(Duration(seconds: 1));

      // Sample data
      _prescriptions = [
        Prescription(
          id: '1',
          medicineName: 'Paracetamol',
          dosage: '500mg',
          frequency: 'Twice a day',
          duration: '7 days',
          startDate: DateTime.now().subtract(Duration(days: 2)),
          endDate: DateTime.now().add(Duration(days: 5)),
          notes: 'Take after meals. Avoid alcohol while on this medication.',
          type: MedicineType.tablet,
        ),
        Prescription(
          id: '2',
          medicineName: 'Amoxicillin',
          dosage: '250mg',
          frequency: 'Three times a day',
          duration: '5 days',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 5)),
          notes: 'Take with water. Complete the full course even if you feel better.',
          type: MedicineType.capsule,
        ),
        Prescription(
          id: '3',
          medicineName: 'Omeprazole',
          dosage: '20mg',
          frequency: 'Once a day',
          duration: '14 days',
          startDate: DateTime.now().subtract(Duration(days: 15)),
          endDate: DateTime.now().subtract(Duration(days: 1)),
          notes: 'Take before breakfast.',
          type: MedicineType.capsule,
        ),
        Prescription(
          id: '4',
          medicineName: 'Vitamin D3',
          dosage: '1000 IU',
          frequency: 'Once daily',
          duration: '30 days',
          startDate: DateTime.now().subtract(Duration(days: 10)),
          endDate: DateTime.now().add(Duration(days: 20)),
          notes: 'Take with meals to improve absorption.',
          type: MedicineType.tablet,
        ),
        Prescription(
          id: '5',
          medicineName: 'Insulin',
          dosage: '10 units',
          frequency: 'Before meals',
          duration: 'Ongoing',
          startDate: DateTime.now().subtract(Duration(days: 60)),
          endDate: DateTime.now().add(Duration(days: 365)),
          notes: 'Keep refrigerated. Rotate injection sites.',
          type: MedicineType.injection,
        ),
      ];

      _applyFiltersAndSort();
      _isLoading = false;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load prescriptions: ${e.toString()}';
      _isLoading = false;
    }

    notifyListeners();
  }

  void _applyFiltersAndSort() {
    // Apply filters
    switch (_currentFilter) {
      case FilterOption.all:
        _filteredPrescriptions = List.from(_prescriptions);
        break;
      case FilterOption.active:
        final now = DateTime.now();
        _filteredPrescriptions = _prescriptions
            .where((prescription) => prescription.endDate.isAfter(now))
            .toList();
        break;
      case FilterOption.expired:
        final now = DateTime.now();
        _filteredPrescriptions = _prescriptions
            .where((prescription) => prescription.endDate.isBefore(now))
            .toList();
        break;
      case FilterOption.tablets:
        _filteredPrescriptions = _prescriptions
            .where((prescription) => prescription.type == MedicineType.tablet)
            .toList();
        break;
      case FilterOption.capsules:
        _filteredPrescriptions = _prescriptions
            .where((prescription) => prescription.type == MedicineType.capsule)
            .toList();
        break;
    }
    // Apply sort
    switch (_currentSort) {
      case SortOption.newest:
        _filteredPrescriptions.sort((a, b) => b.startDate.compareTo(a.startDate));
        break;
      case SortOption.oldest:
        _filteredPrescriptions.sort((a, b) => a.startDate.compareTo(b.startDate));
        break;
      case SortOption.nameAsc:
        _filteredPrescriptions.sort((a, b) => a.medicineName.compareTo(b.medicineName));
        break;
      case SortOption.nameDesc:
        _filteredPrescriptions.sort((a, b) => b.medicineName.compareTo(a.medicineName));
        break;
      case SortOption.durationLong:
        _filteredPrescriptions.sort((a, b) {
          int aDuration = a.endDate.difference(a.startDate).inDays;
          int bDuration = b.endDate.difference(b.startDate).inDays;
          return bDuration.compareTo(aDuration);
        });
        break;
      case SortOption.durationShort:
        _filteredPrescriptions.sort((a, b) {
          int aDuration = a.endDate.difference(a.startDate).inDays;
          int bDuration = b.endDate.difference(b.startDate).inDays;
          return aDuration.compareTo(bDuration);
        });
        break;
    }
  }

  void setFilter(FilterOption filter) {
    _currentFilter = filter;
    _applyFiltersAndSort();
    notifyListeners();
  }
  void setSort(SortOption sort) {
    _currentSort = sort;
    _applyFiltersAndSort();
    notifyListeners();
  }

  Future<void> addPrescription(Prescription prescription) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 800));
      _prescriptions.add(prescription);
      _applyFiltersAndSort();
      _isLoading = false;
    } catch (e) {
      _errorMessage = 'Failed to add prescription: ${e.toString()}';
      _isLoading = false;
    }

    notifyListeners();
  }

  Future<void> updatePrescription(Prescription updatedPrescription) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 800));
      final index = _prescriptions.indexWhere((p) => p.id == updatedPrescription.id);
      if (index != -1) {
        _prescriptions[index] = updatedPrescription;
        _applyFiltersAndSort();
      }
      _isLoading = false;
    } catch (e) {
      _errorMessage = 'Failed to update prescription: ${e.toString()}';
      _isLoading = false;
    }

    notifyListeners();
  }

  Future<void> deletePrescription(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 800));
      _prescriptions.removeWhere((p) => p.id == id);
      _applyFiltersAndSort();
      _isLoading = false;
    } catch (e) {
      _errorMessage = 'Failed to delete prescription: ${e.toString()}';
      _isLoading = false;
    }
    notifyListeners();
  }
  // For undo functionality
  Prescription? _lastDeletedPrescription;

  Future<void> deletePrescriptionWithUndo(String id) async {
    final prescriptionToDelete = _prescriptions.firstWhere((p) => p.id == id);
    _lastDeletedPrescription = prescriptionToDelete;

    await deletePrescription(id);
  }

  Future<void> undoDelete() async {
    if (_lastDeletedPrescription != null) {
      await addPrescription(_lastDeletedPrescription!);
      _lastDeletedPrescription = null;
    }
  }
}

enum FilterOption { all, active, expired, tablets, capsules }
enum SortOption { newest, oldest, nameAsc, nameDesc, durationLong, durationShort }

// Animation and UI helpers
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final BoxBorder? border;

  const GlassmorphicContainer({
    Key? key,
    required this.child,
    required this.width,
    required this.height,
    this.borderRadius = 20,
    this.blur = 10,
    this.opacity = 0.2,
    this.borderColor = Colors.white,
    this.borderWidth = 1.5,
    this.gradient,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: 400,
          height: 320,
          decoration: BoxDecoration(
            gradient: gradient ?? LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ?? Border.all(
              width: borderWidth,
              color: borderColor.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// Screens
class PrescriptionsScreen extends StatefulWidget {
  @override
  _PrescriptionsScreenState createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> with SingleTickerProviderStateMixin {
  final PrescriptionProvider _provider = PrescriptionProvider();
  late AnimationController _animationController;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Show app bar elevation when scrolling
    _scrollController.addListener(() {
      if (_scrollController.offset > 0 && !_animationController.isAnimating) {
        _animationController.forward();
      } else if (_scrollController.offset <= 0 && !_animationController.isAnimating) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAnimatedAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4285F4),
              Color(0xFF03A9A9),
            ],
          ),
        ),
        child: _buildBody(),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 100 * (1 - _animationController.value)),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: _animationController.value,
              child: child,
            ),
          );
        },

      ),
    );
  }

  PreferredSizeWidget _buildAnimatedAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return AppBar(
            backgroundColor: Colors.teal.withOpacity(0.8 * _animationController.value),
            elevation: 10 * _animationController.value,
            title: Text(
              'Dosage Schedule',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,

            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10 * _animationController.value,
                  sigmaY: 10 * _animationController.value,
                ),
                child: Container(color: Colors.transparent),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  _provider.loadPrescriptions();
                  _showSuccessSnackBar('Refreshed prescriptions');
                },
              ),
              IconButton(
                icon: Icon(Icons.filter_list, color: Colors.white),
                onPressed: () => _showFilterOptions(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation: _provider,
      builder: (context, child) {
        if (_provider.isLoading && _provider.prescriptions.isEmpty) {
          return _buildLoadingState();
        }

        if (_provider.errorMessage.isNotEmpty && _provider.prescriptions.isEmpty) {
          return _buildErrorWidget();
        }

        if (_provider.prescriptions.isEmpty) {
          return _buildEmptyState();
        }

        return Stack(
          children: [
            Positioned.fill(
              child: RefreshIndicator(
                onRefresh: () => _provider.loadPrescriptions(),
                color: Colors.white,
                backgroundColor: Colors.teal.withOpacity(0.7),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  itemCount: _provider.prescriptions.length + 1, // +1 for top padding
                  padding: EdgeInsets.fromLTRB(16, 110, 16, 100),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildListHeader();
                    }

                    final itemIndex = index - 1;
                    return _buildAnimatedListItem(
                      _provider.prescriptions[itemIndex],
                      itemIndex,
                    );
                  },
                ),
              ),
            ),
            if (_provider.isLoading)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Loading prescriptions...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Medications',
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildFilterChip(),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Showing ${_provider.prescriptions.length} prescriptions',
            style: textTheme.titleSmall?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip() {
    String filterText;
    IconData filterIcon;

    switch (_provider.currentFilter) {
      case FilterOption.all:
        filterText = 'All';
        filterIcon = Icons.list;
        break;
      case FilterOption.active:
        filterText = 'Active';
        filterIcon = Icons.check_circle;
        break;
      case FilterOption.expired:
        filterText = 'Expired';
        filterIcon = Icons.history;
        break;
      case FilterOption.tablets:
        filterText = 'Tablets';
        filterIcon = Icons.local_pharmacy;
        break;
      case FilterOption.capsules:
        filterText = 'Capsules';
        filterIcon = Icons.medication;
        break;
    }

    return GestureDetector(
      onTap: () => _showFilterOptions(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              filterIcon,
              size: 16,
              color: Colors.white,
            ),
            SizedBox(width: 4),
            Text(
              filterText,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedListItem(Prescription prescription, int index) {
    // Staggered animation
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutQuad,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: _buildPrescriptionCard(prescription),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: GlassmorphicContainer(
        width: 300,
        height: 300,
        borderRadius: 20,
        blur: 20,
        opacity: 0.2,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 70,
                color: Colors.white.withOpacity(0.8),
              ),
              SizedBox(height: 24),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              Text(
                _provider.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24),
              _buildGlassButton(
                onTap: () => _provider.loadPrescriptions(),
                icon: Icons.refresh,
                label: 'Try Again',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: GlassmorphicContainer(
        width: 300,
        height: 350,
        borderRadius: 20,
        blur: 20,
        opacity: 0.2,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.medical_services_outlined,
                size: 80,
                color: Colors.white.withOpacity(0.8),
              ),
              SizedBox(height: 24),
              Text(
                'No prescriptions found',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Add your first prescription to start tracking your medications',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 32),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          // Add a subtle shadow for depth
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrescriptionCard(Prescription prescription) {
    final now = DateTime.now();
    final isActive = now.isBefore(prescription.endDate);
    final dateFormat = DateFormat('MMM dd, yyyy');
    final daysBetween = prescription.endDate.difference(prescription.startDate).inDays;
    final daysRemaining = isActive ? prescription.endDate.difference(now).inDays : 0;
    final progress = isActive ? (daysBetween - daysRemaining) / daysBetween : 1.0;

    IconData medicineIcon;
    Color medicineColor;

    switch (prescription.type) {
      case MedicineType.tablet:
        medicineIcon = Icons.local_pharmacy;
        medicineColor = Colors.blue;
        break;
      case MedicineType.capsule:
        medicineIcon = Icons.medication;
        medicineColor = Colors.orange;
        break;
      case MedicineType.liquid:
        medicineIcon = Icons.water_drop;
        medicineColor = Colors.purple;
        break;
      case MedicineType.injection:
        medicineIcon = Icons.vaccines;
        medicineColor = Colors.red;
        break;
      case MedicineType.topical:
        medicineIcon = Icons.spa;
        medicineColor = Colors.green;
        break;
      case MedicineType.other:
        medicineIcon = Icons.medical_services;
        medicineColor = Colors.grey;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          GlassmorphicContainer(
            width: double.infinity,
            height: prescription.notes.isNotEmpty ? 220 : 180,
            borderRadius: 20,
            blur: 10,
            opacity: 0.1,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
            ),
            child: Column(
              children: [
                // Header with medicine name
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: isActive
                        ? medicineColor.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? medicineColor.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          medicineIcon,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prescription.medicineName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              prescription.dosage,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.green.withOpacity(0.3)
                              : Colors.red.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isActive
                                ? Colors.green.withOpacity(0.3)
                                : Colors.red.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          isActive ? 'Active' : 'Expired',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
// Body with details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Frequency and duration
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white70,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              prescription.frequency,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white70,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              prescription.duration,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        // Date information
                        Row(
                          children: [
                            Text(
                              'Started:',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              dateFormat.format(prescription.startDate),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Ends:',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              dateFormat.format(prescription.endDate),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Progress indicator
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  isActive
                                      ? '$daysRemaining days remaining'
                                      : 'Completed ${daysBetween} days',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '${(progress * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isActive ? medicineColor : Colors.grey,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),

                        // Notes if available
                        if (prescription.notes.isNotEmpty) ...[
                          SizedBox(height: 12),
                          Text(
                            'Notes:',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            prescription.notes,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
// Action buttons
          Positioned(
            right: 10,
            bottom: 10,
            child: Row(
              children: [

                SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.delete,
                  onTap: () => _deletePrescription(prescription.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  void _deletePrescription(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Prescription'),
        content: Text('Are you sure you want to delete this prescription?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop();
              _provider.deletePrescriptionWithUndo(id);
              _showUndoSnackBar();
            },
          ),
        ],
      ),
    );
  }

  void _showUndoSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Prescription deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            _provider.undoDelete();
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.blueAccent,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.blueAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 400,
      borderRadius: 20,
      blur: 20,
      opacity: 0.2,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Filter & Sort',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.2)),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Filter by Status'),
                  _buildFilterOption(
                    label: 'All Prescriptions',
                    icon: Icons.list,
                    isSelected: _provider.currentFilter == FilterOption.all,
                    onTap: () {
                      _provider.setFilter(FilterOption.all);
                      Navigator.pop(context);
                    },
                  ),
                  _buildFilterOption(
                    label: 'Active Only',
                    icon: Icons.check_circle,
                    isSelected: _provider.currentFilter == FilterOption.active,
                    onTap: () {
                      _provider.setFilter(FilterOption.active);
                      Navigator.pop(context);
                    },
                  ),
                  _buildFilterOption(
                    label: 'Expired Only',
                    icon: Icons.history,
                    isSelected: _provider.currentFilter == FilterOption.expired,
                    onTap: () {
                      _provider.setFilter(FilterOption.expired);
                      Navigator.pop(context);
                    },
                  ),

                  _buildSectionHeader('Filter by Type'),
                  _buildFilterOption(
                    label: 'Tablets Only',
                    icon: Icons.local_pharmacy,
                    isSelected: _provider.currentFilter == FilterOption.tablets,
                    onTap: () {
                      _provider.setFilter(FilterOption.tablets);
                      Navigator.pop(context);
                    },
                  ),
                  _buildFilterOption(
                    label: 'Capsules Only',
                    icon: Icons.medication,
                    isSelected: _provider.currentFilter == FilterOption.capsules,
                    onTap: () {
                      _provider.setFilter(FilterOption.capsules);
                      Navigator.pop(context);
                    },
                  ),

                  _buildSectionHeader('Sort by'),
                  _buildFilterOption(
                    label: 'Newest First',
                    icon: Icons.trending_down,
                    isSelected: _provider.currentSort == SortOption.newest,
                    onTap: () {
                      _provider.setSort(SortOption.newest);
                      Navigator.pop(context);
                    },
                  ),
                  _buildFilterOption(
                    label: 'Oldest First',
                    icon: Icons.trending_up,
                    isSelected: _provider.currentSort == SortOption.oldest,
                    onTap: () {
                      _provider.setSort(SortOption.oldest);
                      Navigator.pop(context);
                    },
                  ),
                  _buildFilterOption(
                    label: 'A-Z by Name',
                    icon: Icons.sort_by_alpha,
                    isSelected: _provider.currentSort == SortOption.nameAsc,
                    onTap: () {
                      _provider.setSort(SortOption.nameAsc);
                      Navigator.pop(context);
                    },
                  ),
                  _buildFilterOption(
                    label: 'Z-A by Name',
                    icon: Icons.sort_by_alpha,
                    isSelected: _provider.currentSort == SortOption.nameDesc,
                    onTap: () {
                      _provider.setSort(SortOption.nameDesc);
                      Navigator.pop(context);
                    },
                  ),
                  _buildFilterOption(
                    label: 'Longest Duration',
                    icon: Icons.calendar_month,
                    isSelected: _provider.currentSort == SortOption.durationLong,
                    onTap: () {
                      _provider.setSort(SortOption.durationLong);
                      Navigator.pop(context);
                    },
                  ),
                  _buildFilterOption(
                    label: 'Shortest Duration',
                    icon: Icons.calendar_today,
                    isSelected: _provider.currentSort == SortOption.durationShort,
                    onTap: () {
                      _provider.setSort(SortOption.durationShort);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildFilterOption({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
