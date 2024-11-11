import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DreamInterpretationScreen extends StatefulWidget {
  const DreamInterpretationScreen({super.key});

  @override
  _DreamInterpretationScreenState createState() =>
      _DreamInterpretationScreenState();
}

class _DreamInterpretationScreenState extends State<DreamInterpretationScreen> {
  final TextEditingController _controller = TextEditingController();
  String _interpretation = '';

  // Function to fetch interpretation from the API
  Future<void> _getInterpretation() async {
    final response = await http.post(
      Uri.parse('https://jaspreet04-dreaminterpreter.hf.space/run/predict'),
      headers: {
        'Authorization':
            'Bearer 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', // Replace with your actual token
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'data': [
          _controller.text
        ], // 'data' is often the key in Hugging Face models
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _interpretation = data['data'][0] ??
            'No interpretation found.'; // Use correct key here
      });
    } else {
      setState(() {
        _interpretation =
            'Failed to load interpretation. Status: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/background.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Space at the top
            const SizedBox(height: 100),

            // Title
            const Text(
              'Enter your dream description:',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20.0),

            // Dream Description Input Field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Dream Description',
                  labelStyle: TextStyle(color: Colors.black54),
                ),
                maxLines: 5,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20.0),

            // Get Interpretation Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 191, 96, 182),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5, // Slight shadow
                ),
                onPressed: _getInterpretation,
                child: const Text(
                  'Get Interpretation',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30.0),

            // Display Interpretation
            if (_interpretation.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Text(
                  _interpretation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
