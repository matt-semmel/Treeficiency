import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_project_name/pages/tips_page.dart'; // Adjust import path based on your project structure

void main() {
  testWidgets('TipsPage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: TipsPage(),
      routes: {
        '/tipsPage': (context) => TipsPage(),
      },
    ));

    // Verify that the app displays the correct widgets.
    expect(find.text('Tips'), findsOneWidget);
    expect(find.textContaining("Install a Programmable Thermostat"), findsOneWidget);
    expect(find.textContaining("Use Energy-Efficient Lighting"), findsOneWidget);
    // ... add more expect statements for other tips

    // You can perform other tests, such as scrolling and checking interactions.

    // Example: Scroll down
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pump();

    // Example: Check if a tip is still visible after scrolling
    expect(find.textContaining("Reduce Water Heating Costs"), findsOneWidget);
  });
}
