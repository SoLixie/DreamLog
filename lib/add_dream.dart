import 'package:flutter/material.dart';
import 'db.dart';

class AddDreamScreen extends StatefulWidget {
  const AddDreamScreen({super.key});

  @override
  _AddDreamScreenState createState() => _AddDreamScreenState();
}

class _AddDreamScreenState extends State<AddDreamScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int _selectedHours = 0;
  int _selectedMinutes = 0;
  String? _selectedDreamType;
  bool _isFavorite = false; // Favorite option

  // Database instance
  final DBHelper _dbHelper = DBHelper();

  // Function to generate dream interpretation based on type
  String _generateInterpretation(String dreamType) {
    switch (dreamType) {
      case 'Lucid Dream':
        return 'A lucid dream is when you are aware that you are dreaming. It may signify personal growth and insight.';
      case 'Nightmare':
        return 'A nightmare may indicate feelings of fear or anxiety in waking life.';
      case 'Recurring Dream':
        return 'Recurring dreams often represent unresolved issues or emotions.';
      case 'Prophetic Dream':
        return 'A prophetic dream is believed to predict future events.';
      case 'Daydream':
        return 'Daydreams may reflect unfulfilled desires or wishes in your waking life.';
      case 'Normal Dream':
      default:
        return 'A normal dream could reflect everyday thoughts or experiences.';
    }
  }

  // Save the dream and exit
  Future<void> _saveDream(BuildContext context) async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedDreamType != null) {
      final dream = Dream(
        title: _titleController.text,
        description: _descriptionController.text,
        date: DateTime.now().toString(),
        sleepDuration: _selectedHours + (_selectedMinutes / 60),
        isFavorite: _isFavorite,
        interpretation: _generateInterpretation(_selectedDreamType!), // Generate interpretation
      );

      // Insert dream into the database
      await _dbHelper.insertDream(dream);

      // Clear the text fields after saving
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedDreamType = null;
        _selectedHours = 0;
        _selectedMinutes = 0;
        _isFavorite = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dream saved successfully!')),
      );

      // Close the page after saving
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields before saving.')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Dream'),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        centerTitle: true,
        leading: Container(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height, // Ensure full height of the screen
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dream Title
                _buildInputField(
                  label: 'Dream Title',
                  controller: _titleController,
                  maxLines: 1,
                  textColor: Colors.black,  // Set text color to black for better visibility
                ),
                const SizedBox(height: 20),

                // Dream Description
                _buildInputField(
                  label: 'Dream Description',
                  controller: _descriptionController,
                  maxLines: 5,
                  textColor: Colors.black,  // Set text color to black for better visibility
                ),
                const SizedBox(height: 20),

                // Sleep Duration (Hours and Minutes)
                _buildDurationPicker(),
                const SizedBox(height: 20),

                // Dream Type (Dropdown)
                _buildDropdown(
                  label: 'Dream Type',
                  value: _selectedDreamType,
                  items: <String>[
                    'Lucid Dream',
                    'Nightmare',
                    'Recurring Dream',
                    'Prophetic Dream',
                    'Daydream',
                    'Normal Dream',
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDreamType = newValue;
                    });
                  },
                  textColor: Colors.black,  // Set text color to black for better visibility
                ),
                const SizedBox(height: 20),

                // Favorite Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _isFavorite,
                      onChanged: (bool? value) {
                        setState(() {
                          _isFavorite = value!;
                        });
                      },
                    ),
                    const Text(
                      'Mark as Favorite',
                      style: TextStyle(color: Colors.black),  // Set text color to black for visibility
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Save Button (Centered)
                Center(
                  child: ElevatedButton(
                    onPressed: () => _saveDream(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
                    ),
                    child: const Text(
                      'Save Dream',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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

  // Helper method to build the input field
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required int maxLines,
    required Color textColor,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textColor),
        ),
      ),
      style: TextStyle(color: textColor),
    );
  }

  // Helper method to build the duration picker (Hours and Minutes)
  Widget _buildDurationPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDurationDropdown(
          label: 'Hours',
          value: _selectedHours,
          onChanged: (int? newValue) {
            setState(() {
              _selectedHours = newValue!;
            });
          },
          items: List.generate(24, (index) => index),
        ),
        _buildDurationDropdown(
          label: 'Minutes',
          value: _selectedMinutes,
          onChanged: (int? newValue) {
            setState(() {
              _selectedMinutes = newValue!;
            });
          },
          items: List.generate(60, (index) => index),
        ),
      ],
    );
  }

  // Helper method to build the dropdown for Hours and Minutes
  Widget _buildDurationDropdown({
    required String label,
    required int value,
    required ValueChanged<int?> onChanged,
    required List<int> items,
  }) {
    return Expanded(
      child: DropdownButtonFormField<int>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
        items: items.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString(), style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
      ),
    );
  }

  // Helper method to build the dropdown for Dream Type
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required Color textColor,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textColor),
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: textColor)),
        );
      }).toList(),
    );
  }
}