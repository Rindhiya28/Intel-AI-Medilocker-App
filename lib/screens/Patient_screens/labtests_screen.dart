import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class LabTestsScreen extends StatefulWidget {
  const LabTestsScreen({Key? key}) : super(key: key);

  @override
  _LabTestsScreenState createState() => _LabTestsScreenState();
}

class _LabTestsScreenState extends State<LabTestsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  String? _error;
  late LabData _labData;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isCached = false;

  @override
  void initState() {
    super.initState();
    _fetchLabData();
    // Set preferred orientation to prevent layout issues
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    // Reset orientation settings
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<void> _fetchLabData() async {
    // Check for cached data first
    if (_isCached) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Simulate API call
    try {
      // In a real app, you would fetch data from an API
      // final response = await http.get(Uri.parse('https://api.example.com/lab-results/patient-id'));
      // final data = jsonDecode(response.body);

      // Adding artificial delay for demonstration
      await Future.delayed(const Duration(milliseconds: 1500));

      // Using sample data for demonstration
      setState(() {
        _labData = sampleLabData;
        _isLoading = false;
        _isCached = true;
        _tabController = TabController(length: _labData.tests.length, vsync: this);

        // Listen for tab changes to update screen reader announcements
        _tabController.addListener(() {
          if (_tabController.indexIsChanging) {
            final testName = _labData.tests[_tabController.index].name;
            // Announce tab change to screen readers
            SemanticsService.announce("Showing $testName results", Directionality.of(context));
          }
        });
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load lab test results: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat.yMMMMd().format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get device size to handle responsive layout
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: const Color(0xFF2D6CDF),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF2D6CDF),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: const Color(0xFF2D6CDF),
            fontSize: isSmallScreen ? 18 : 22,
            fontWeight: FontWeight.bold,
          ),
          toolbarHeight: isSmallScreen ? 48 : 56,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: const Color(0xFF2D6CDF),
          unselectedLabelColor: Colors.grey.shade700,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(fontSize: isSmallScreen ? 13 : 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: isSmallScreen ? 13 : 14),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Laboratory Results'),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Share report',
              onPressed: () {
                // Share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share report')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.print_outlined),
              tooltip: 'Print report',
              onPressed: () {
                // Print functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Print report')),
                );
              },
            ),
          ],
        ),
        body: _buildBody(isSmallScreen),
        floatingActionButton: !_isLoading && _error == null
            ? FloatingActionButton(
          backgroundColor: const Color(0xFF2D6CDF),
          tooltip: 'Download report as PDF',
          child: const Icon(Icons.download_outlined),
          onPressed: () {
            // Download functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Download report as PDF')),
            );
          },
        )
            : null,
      ),
    );
  }

  Widget _buildBody(bool isSmallScreen) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Loading lab results...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6CDF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                    _isCached = false;
                  });
                  _fetchLabData();
                },
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isCached = false;
        });
        await _fetchLabData();
      },
      color: const Color(0xFF2D6CDF),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: _buildPatientInfoCard(isSmallScreen),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: const Color(0xFF2D6CDF),
                      tabs: _labData.tests.map((test) {
                        return Tab(
                          text: test.name,
                        );
                      }).toList(),
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: _labData.tests.map((test) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildTestCard(test, isSmallScreen, constraints.maxWidth),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildNotesCard(isSmallScreen),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPatientInfoCard(bool isSmallScreen) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2D6CDF).withOpacity(0.9),
                  const Color(0xFF2D6CDF).withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'patient_avatar',
                        child: CircleAvatar(
                          radius: isSmallScreen ? 20 : 24,
                          backgroundColor: Colors.white,
                          child: Text(
                            _labData.patientInfo.name.substring(0, 1),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D6CDF),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _labData.patientInfo.name,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${_labData.patientInfo.id}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.event_note,
                              size: 16,
                              color: Color(0xFF2D6CDF),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(_labData.testDate),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D6CDF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Colors.white30,
                    height: 1,
                  ),
                  const SizedBox(height: 16),
                  isSmallScreen
                      ? Column(
                    children: [
                      _buildInfoItem(
                        Icons.cake_outlined,
                        'Date of Birth',
                        _labData.patientInfo.dob,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoItem(
                        Icons.person_outline,
                        'Gender',
                        _labData.patientInfo.gender,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoItem(
                        Icons.medical_services_outlined,
                        'Ordered By',
                        _labData.orderedBy,
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          Icons.cake_outlined,
                          'Date of Birth',
                          _labData.patientInfo.dob,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          Icons.person_outline,
                          'Gender',
                          _labData.patientInfo.gender,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          Icons.medical_services_outlined,
                          'Ordered By',
                          _labData.orderedBy,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.white70,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTestCard(Test test, bool isSmallScreen, double maxWidth) {
    final abnormalResults = test.results.where((r) => r.flag != 'normal').toList();

    return Card(

      margin: EdgeInsets.all(isSmallScreen ? 12 : 16),

      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (abnormalResults.isNotEmpty) ...[
            _buildAbnormalResultsSection(abnormalResults, isSmallScreen),
            const Divider(height: 1),
          ],
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),

            child: Text(
              'Detailed Results',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          _buildResultsTable(test, isSmallScreen, maxWidth),
        ],
      ),
    );
  }

  Widget _buildAbnormalResultsSection(List<TestResult> abnormalResults, bool isSmallScreen) {
    final gridCrossAxisCount = isSmallScreen ? 1 : (abnormalResults.length == 1 ? 1 : 2);

    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.priority_high,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Abnormal Results',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                semanticsLabel: 'Abnormal Results detected',
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCrossAxisCount,
              childAspectRatio: isSmallScreen ? 3.0 : 2.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: abnormalResults.length,
            itemBuilder: (context, index) {
              final result = abnormalResults[index];
              return  Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getFlagColor(result.flag).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getFlagColor(result.flag).withOpacity(0.3),
                    width: 1,

                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      result.parameter,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 8,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          result.value,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: _getFlagColor(result.flag),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          result.unit,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getFlagColor(result.flag).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _capitalizeFirstLetter(result.flag),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: _getFlagColor(result.flag),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTable(Test test, bool isSmallScreen, double maxWidth) {
    // If screen is too small for horizontal scroll or on mobile, use a vertical layout
    if (isSmallScreen || maxWidth < 600) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16, 0, 16, isSmallScreen ? 12 : 16),
        itemCount: test.results.length,
        itemBuilder: (context, index) {
          final result = test.results[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: result.flag != 'normal'
                ? _getFlagColor(result.flag).withOpacity(0.05)
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: result.flag != 'normal'
                    ? _getFlagColor(result.flag).withOpacity(0.2)
                    : Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          result.parameter,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getFlagColor(result.flag).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getFlagColor(result.flag).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _capitalizeFirstLetter(result.flag),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: _getFlagColor(result.flag),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        result.value,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: result.flag != 'normal'
                              ? _getFlagColor(result.flag)
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        result.unit,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Reference: ${result.referenceRange}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // For larger screens, use the horizontal data table
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(16, 0, 16, isSmallScreen ? 12 : 16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2D6CDF).withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: DataTable(
            headingRowHeight: 50,
            dataRowHeight: 56,
            horizontalMargin: 24,
            columnSpacing: 24,
            headingTextStyle: const TextStyle(
              color: Color(0xFF2D6CDF),
              fontWeight: FontWeight.bold,
            ),
            columns: const [
              DataColumn(label: Text('Parameter')),
              DataColumn(
                label: Text('Result'),
                numeric: true,
              ),
              DataColumn(label: Text('Unit')),
              DataColumn(label: Text('Reference Range')),
              DataColumn(label: Text('Status')),
            ],
            rows: test.results.map((result) {
              return DataRow(
                color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (result.flag != 'normal') {
                      return result.flag == 'high'
                          ? Colors.red.withOpacity(0.05)
                          : Colors.blue.withOpacity(0.05);
                    }
                    return null;
                  },
                ),
                cells: [
                  DataCell(
                    Text(
                      result.parameter,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(
                    Text(
                      result.value,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: result.flag != 'normal'
                            ? _getFlagColor(result.flag)
                            : Colors.black,
                      ),
                    ),
                  ),
                  DataCell(Text(result.unit)),
                  DataCell(Text(result.referenceRange)),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getFlagColor(result.flag).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getFlagColor(result.flag).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _capitalizeFirstLetter(result.flag),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: _getFlagColor(result.flag),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      );
  }
  }

  Widget _buildNotesCard(bool isSmallScreen) {
    return Card(
      margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes & Comments',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _labData.notes,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This report is for informational purposes only and should be reviewed by a healthcare professional.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
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

  Color _getFlagColor(String flag) {
    switch (flag.toLowerCase()) {
      case 'high':
        return Colors.red.shade700;
      case 'low':
        return Colors.blue.shade700;
      default:
        return Colors.green.shade700;
    }
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

// Sample data models
class LabData {
  final String testDate;
  final PatientInfo patientInfo;
  final String orderedBy;
  final List<Test> tests;
  final String notes;

  LabData({
    required this.testDate,
    required this.patientInfo,
    required this.orderedBy,
    required this.tests,
    required this.notes,
  });
}

class PatientInfo {
  final String name;
  final String id;
  final String dob;
  final String gender;

  PatientInfo({
    required this.name,
    required this.id,
    required this.dob,
    required this.gender,
  });
}

class Test {
  final String name;
  final List<TestResult> results;

  Test({
    required this.name,
    required this.results,
  });
}

class TestResult {
  final String parameter;
  final String value;
  final String unit;
  final String referenceRange;
  final String flag;

  TestResult({
    required this.parameter,
    required this.value,
    required this.unit,
    required this.referenceRange,
    required this.flag,
  });
}

// Sample data for testing
final sampleLabData = LabData(
  testDate: '2025-03-15',
  patientInfo: PatientInfo(
    name: 'John Smith',
    id: 'PT-10025489',
    dob: 'Jan 15, 1975',
    gender: 'Male',
  ),
  orderedBy: 'Dr. Sarah Connor',
  tests: [
    Test(
      name: 'Complete Blood Count',
      results: [
        TestResult(
          parameter: 'WBC',
          value: '11.5',
          unit: 'K/uL',
          referenceRange: '4.5-11.0',
          flag: 'high',
        ),
        TestResult(
          parameter: 'RBC',
          value: '5.2',
          unit: 'M/uL',
          referenceRange: '4.5-5.9',
          flag: 'normal',
        ),
        TestResult(
          parameter: 'Hemoglobin',
          value: '15.1',
          unit: 'g/dL',
          referenceRange: '13.5-17.5',
          flag: 'normal',
        ),
        TestResult(
          parameter: 'Hematocrit',
          value: '45.0',
          unit: '%',
          referenceRange: '41.0-53.0',
          flag: 'normal',
        ),
        TestResult(
          parameter: 'Platelets',
          value: '145',
          unit: 'K/uL',
          referenceRange: '150-450',
          flag: 'low',
        ),
      ],
    ),
    Test(
      name: 'Lipid Panel',
      results: [
        TestResult(
          parameter: 'Total Cholesterol',
          value: '210',
          unit: 'mg/dL',
          referenceRange: '< 200',
          flag: 'high',
        ),
        TestResult(
          parameter: 'HDL Cholesterol',
          value: '45',
          unit: 'mg/dL',
          referenceRange: '> 40',
          flag: 'normal',
        ),
        TestResult(
          parameter: 'LDL Cholesterol',
          value: '135',
          unit: 'mg/dL',
          referenceRange: '< 130',
          flag: 'high',
        ),
        TestResult(
          parameter: 'Triglycerides',
          value: '150',
          unit: 'mg/dL',
          referenceRange: '< 150',
          flag: 'normal',
        ),
      ],
    ),
    Test(
      name: 'Metabolic Panel',
      results: [
        TestResult(
          parameter: 'Glucose',
          value: '105',
          unit: 'mg/dL',
          referenceRange: '70-99',
          flag: 'high',
        ),
        TestResult(
          parameter: 'BUN',
          value: '15',
          unit: 'mg/dL',
          referenceRange: '7-20',
          flag: 'normal',
        ),
        TestResult(
          parameter: 'Creatinine',
          value: '0.9',
          unit: 'mg/dL',
          referenceRange: '0.6-1.2',
          flag: 'normal',
        ),
        TestResult(
          parameter: 'Sodium',
          value: '138',
          unit: 'mmol/L',
          referenceRange: '135-145',
          flag: 'normal',
        ),
        TestResult(
          parameter: 'Potassium',
          value: '3.4',
          unit: 'mmol/L',
          referenceRange: '3.5-5.0',
          flag: 'low',
        ),
        TestResult(
          parameter: 'Calcium',
          value: '9.2',
          unit: 'mg/dL',
          referenceRange: '8.5-10.5',
          flag: 'normal',
        ),
      ],
    ),
    Test(
      name: 'Thyroid Panel',
      results: [
        TestResult(
          parameter: 'TSH',
          value: '2.5',
          unit: 'mIU/L',
          referenceRange: '0.4-4.0',
          flag: 'normal',
        ),
        TestResult(
          parameter: 'Free T4',
          value: '1.1',
          unit: 'ng/dL',
          referenceRange: '0.8-1.8',
          flag: 'normal',
        ),
        TestResult(
          parameter: 'Free T3',
          value: '3.2',
          unit: 'pg/mL',
          referenceRange: '2.3-4.2',
          flag: 'normal',
        ),
      ],
    ),
  ],
  notes: 'Patient presented with fatigue and shortness of breath. WBC count is elevated which may indicate an infection. Platelets are slightly below the reference range. Lipid panel shows elevated total cholesterol and LDL. Consider follow-up testing in 3 months after dietary and lifestyle modifications. Patient also shows slightly elevated glucose levels which should be monitored.',
);