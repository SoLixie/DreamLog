import 'package:flutter_test/flutter_test.dart';
import 'package:dreamapp/add_dream.dart'; // Import the AddDreamScreen class
import 'package:flutter/material.dart';

void main() {
  testWidgets('AddDreamScreen renders correctly', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(MaterialApp(home: AddDreamScreen()));

    // Verify if the widget shows up correctly
    expect(find.text('Add Dream'), findsOneWidget); // Checking if title is visible
  });
}