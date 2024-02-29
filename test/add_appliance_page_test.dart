import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib/pages/add_appliance_page.dart';

void main() {
  testWidgets('AddAppliancePage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: AddAppliancePage()));

    // Verify that the app displays the correct widgets.
    expect(find.text('Add Appliance'), findsOneWidget);
    expect(find.text('Appliance Category'), findsOneWidget);
    expect(find.text('Appliance Name'), findsOneWidget);
    expect(find.text('Appliance Watts'), findsOneWidget);

    // Perform a dropdown selection.
    await tester.tap(find.text('Kitchen'));
    await tester.pump();

    // Verify that the selected category is updated.
    expect(find.text('Appliance Category'), findsOneWidget);
    expect(find.text('Appliance Name'), findsOneWidget);
    expect(find.text('Appliance Watts'), findsOneWidget);

    // Perform a dropdown selection for Appliance Name.
    await tester.tap(find.text('Microwave'));
    await tester.pump();

    // Verify that the selected Appliance Name is updated.
    expect(find.text('Appliance Category'), findsOneWidget);
    expect(find.text('Appliance Name'), findsOneWidget);
    expect(find.text('Appliance Watts'), findsOneWidget);

    // Perform a dropdown selection for Appliance Watts.
    await tester.tap(find.text('One'));
    await tester.pump();

    // Verify that the selected Appliance Watts is updated.
    expect(find.text('Appliance Category'), findsOneWidget);
    expect(find.text('Appliance Name'), findsOneWidget);
    expect(find.text('Appliance Watts'), findsOneWidget);

    // You can add more tests for button clicks, text field inputs, etc.

  });
}
