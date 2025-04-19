import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DietPlanScreen extends StatefulWidget {
  const DietPlanScreen({Key? key}) : super(key: key);

  @override
  _DietPlanScreenState createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  // List of Indian states
  final List<String> indianStates = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka',
    'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram',
    'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu',
    'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
    'Andaman and Nicobar Islands', 'Chandigarh', 'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi', 'Jammu and Kashmir', 'Ladakh', 'Lakshadweep', 'Puducherry'
  ];

  String? selectedState;
  String dietMode = 'Vegetarian'; // Default is Vegetarian
  Map<String, dynamic>? dietPlan;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> getDietPlan() async {
    if (selectedState == null) {
      setState(() {
        errorMessage = 'Please select a state';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
      dietPlan = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.35:5000/get_diet_chart'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'state': selectedState!,
          'diet_type': dietMode,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          if (responseData.containsKey('diet_chart')) {
            dietPlan = _parseDietChart(responseData['diet_chart']);
          } else {
            dietPlan = responseData;
          }
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load diet plan: ${response.statusCode}';
          if (response.body.isNotEmpty) {
            try {
              final errorBody = jsonDecode(response.body);
              if (errorBody['error'] != null) {
                errorMessage = errorBody['error'];
              }
            } catch (e) {
              // If body isn't valid JSON, just show the status code
            }
          }
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error connecting to server: $e';
      });
    }
  }

  // Helper method to parse diet chart text into structured format
  Map<String, dynamic> _parseDietChart(String dietChartText) {
    final result = {
      'breakfast': [],
      'lunch': [],
      'dinner': [],
      'snacks': []
    };

    final lines = dietChartText.split('\n');
    String currentSection = '';

    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      if (trimmedLine.toLowerCase().contains('breakfast')) {
        currentSection = 'breakfast';
      } else if (trimmedLine.toLowerCase().contains('lunch')) {
        currentSection = 'lunch';
      } else if (trimmedLine.toLowerCase().contains('dinner')) {
        currentSection = 'dinner';
      } else if (trimmedLine.toLowerCase().contains('snack')) {
        currentSection = 'snacks';
      } else if (currentSection.isNotEmpty &&
          result.containsKey(currentSection) &&
          !trimmedLine.toLowerCase().contains('calorie') &&
          trimmedLine.length > 3) {
        result[currentSection]?.add(trimmedLine);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Regional Diet Plan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade600,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green.shade100, Colors.white],
              stops: const [0.0, 0.3],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with info
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.restaurant_menu,
                          size: 40,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Customized Diet Plan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Get regional diet recommendations based on your location and preferences',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // State selection dropdown with an improved look
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Your State',
                        labelStyle: TextStyle(fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      icon: const Icon(Icons.location_on, color: Colors.green),
                      value: selectedState,
                      isExpanded: true,
                      items: indianStates.map((String state) {
                        return DropdownMenuItem<String>(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedState = newValue;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Diet mode selection with improved UI
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Diet Preference',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    dietMode = 'Vegetarian';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: dietMode == 'Vegetarian' ? Colors.green.shade100 : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: dietMode == 'Vegetarian' ? Colors.green : Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.eco,
                                        color: dietMode == 'Vegetarian' ? Colors.green : Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Vegetarian',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    dietMode = 'Non-Vegetarian';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: dietMode == 'Non-Vegetarian' ? Colors.red.shade50 : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: dietMode == 'Non-Vegetarian' ? Colors.red.shade300 : Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.restaurant,
                                        color: dietMode == 'Non-Vegetarian' ? Colors.red.shade400 : Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Non-Vegetarian',
                                        style: TextStyle(fontWeight: FontWeight.w500),
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
                ),

                const SizedBox(height: 20),

                // Get Diet Plan button with improved styling
                ElevatedButton(
                  onPressed: isLoading ? null : getDietPlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.food_bank),
                      SizedBox(width: 8),
                      Text(
                        'Get Diet Plan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Error message with better styling
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade400),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Results section with improved cards
                if (dietPlan != null && !isLoading)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                'Recommended Diet Plan for ${selectedState}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView(
                              children: [
                                _buildMealSectionCard('Breakfast', dietPlan!['breakfast'], Icons.wb_sunny_outlined),
                                _buildMealSectionCard('Lunch', dietPlan!['lunch'], Icons.wb_sunny),
                                _buildMealSectionCard('Snacks', dietPlan!['snacks'], Icons.coffee),
                                _buildMealSectionCard('Dinner', dietPlan!['dinner'], Icons.nightlight_round),
                              ],
                            ),
                          ),
                        ],
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

  // Improved helper method to build each meal section as a card
  Widget _buildMealSectionCard(String title, List<dynamic> items, IconData icon) {
    // Handle empty meal sections gracefully
    if (items.isEmpty) {
      return SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green.shade600),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16, color: Colors.green)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}