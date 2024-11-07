import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamapp/add_dream.dart';

void main() {
  testWidgets('Add Dream Entry', (WidgetTester tester) async {
    // Build the AddDreamScreen widget.
    await tester.pumpWidget(MaterialApp(home: AddDreamScreen()));

    // Enter text into the title, description, and date fields, and sleep duration.
    await tester.enterText(find.byType(TextField).at(0), 'A New Dream');
    await tester.enterText(find.byType(TextField).at(1), 'This is a vivid dream description.');
    await tester.enterText(find.byType(TextField).at(2), '2024-11-04');
    await tester.enterText(find.byType(TextField).at(3), '6');

    // Tap the 'Add Dream' button.
    await tester.tap(find.text('Add Dream'));
    await tester.pump();

    // Verify that the title and description were inputted correctly.
    expect(find.text('A New Dream'), findsOneWidget);
    expect(find.text('This is a vivid dream description.'), findsOneWidget);
  });
}
