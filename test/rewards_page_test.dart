import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treefficiency/data/database.dart';
import 'package:treefficiency/pages/rewards_page.dart'; // Make sure to adjust the import path based on your project structure

void main() {
  testWidgets('RewardsPage UI Test', (WidgetTester tester) async {
    // Mock data for testing
    final db = ApplianceDatabase();
    db.totalPoints[1] = 50; // Adjust points as needed

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: RewardsPage(),
      routes: {
        '/rewardsPage': (context) => RewardsPage(),
      },
    ));

    // Verify that the app displays the correct widgets.
    expect(find.text(' Rewards  '), findsOneWidget);
    expect(find.text('Tree Points: 50.00'), findsOneWidget);
    expect(find.text('  REDEEMED  '), findsNWidgets(2)); // Assumes two rewards with 'REDEEMED' text
    expect(find.text('COST: 50pts  '), findsOneWidget);
    expect(find.text('COST: 100pts'), findsOneWidget);
    expect(find.text('GET: 1000pts'), findsOneWidget);

    // Perform a tap on a button (e.g., 'REDEEMED') and verify the state change.
    await tester.tap(find.text('  REDEEMED  ').first);
    await tester.pump();

    // Verify that the state has changed (you might need to adjust the condition based on your actual implementation).
    expect(db.themes[2], isTrue);
  });
}
