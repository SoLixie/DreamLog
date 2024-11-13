import 'package:flutter/material.dart';
import 'db.dart'; // Import your DatabaseHelper class

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Function to delete all entries from the 'dreams' table
  Future<void> _deleteAllDreamEntries(BuildContext context) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('dreams'); // Deletes all rows in the 'dreams' table
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All dream entries have been removed from the database!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting dream entries: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildDeleteAllEntriesButton(context), // Button to delete all dream entries
            ],
          ),
        ),
      ),
    );
  }

  // Button to delete all entries in the 'dreams' table
  Widget _buildDeleteAllEntriesButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _deleteAllDreamEntries(context),
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: _buttonDecoration(),
        child: const Center(
          child: Text(
            'Delete All Dream Entries',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Button decoration styling
  BoxDecoration _buttonDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      gradient: const LinearGradient(
        colors: [
          Color(0xFF4A90E2), // Blue gradient start
          Color(0xFF7F57C2), // Purple gradient end
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 4,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
