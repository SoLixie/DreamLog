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
    final requestBody = jsonEncode({
      'inputs': "Interpret this dream: ${_controller.text}",
    });

    final response = await http.post(
      Uri.parse('https://api-inference.huggingface.co/models/HuggingFaceH4/zephyr-7b-beta'),
      headers: {
        'Authorization': 'Bearer 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', // Replace with your actual token
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Response: ${response.body}");
      if (data.isNotEmpty && data[0].containsKey('generated_text')) {
        setState(() {
          _interpretation = data[0]['generated_text'] ?? 'No interpretation found.';
        });
      } else {
        setState(() {
          _interpretation = 'Failed to interpret dream.';
        });
      }
    } else {
      setState(() {
        _interpretation = 'Failed to load interpretation. Status: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background.png', // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Main Content with SafeArea
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      'Enter your dream description:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12.0),
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
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 191, 96, 182),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _getInterpretation,
                        child: const Text(
                          'Get Interpretation',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),

                    // Scrollable Interpretation Output
                    if (_interpretation.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.4,
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _interpretation,
                              style: const TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
