import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DreamInterpretationScreen extends StatefulWidget {
  const DreamInterpretationScreen({Key? key}) : super(key: key);

  @override
  _DreamInterpretationScreenState createState() =>
      _DreamInterpretationScreenState();
}

class _DreamInterpretationScreenState
    extends State<DreamInterpretationScreen> {
  final TextEditingController _controller = TextEditingController();
  String _interpretation = '';

  // Function to fetch interpretation from the API
  Future<void> _getInterpretation() async {
    final response = await http.post(
      Uri.parse(
          'https://analyzemydream-api.vercel.app/analyzer/AMD_eGAJxoXdKl0LQe8A5nfmlr3ZpkRNbzwq'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'dream_description': _controller.text,
        'lang': 'en',
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _interpretation = data['interpretation'] ?? 'No interpretation found.';
      });
    } else {
      setState(() {
        _interpretation = 'Failed to load interpretation.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add space at the top to push everything down
            const SizedBox(height: 100), // Adjust this value for desired position
            
            const Text(
              'Enter your dream description:',
              style: TextStyle(fontSize: 18, color: Colors.white), // White text for better visibility
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Dream Description',
                labelStyle: TextStyle(color: Colors.white), // White label text
              ),
              maxLines: 5,
              style: const TextStyle(color: Colors.white), // White input text
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E78), // Button color
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _getInterpretation, // Trigger interpretation
              child: const Text('Get Interpretation', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16.0),
            if (_interpretation.isNotEmpty)
              Text(
                _interpretation,
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}