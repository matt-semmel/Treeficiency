import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../auth_service.dart';
import '../login_page.dart'; // Make sure to adjust the import path based on your project structure

void main() {
  testWidgets('LoginPage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Verify that the app displays the correct widgets.
    expect(find.text('Treefficiency'), findsOneWidget);
    expect(find.text('Save electricity. Save trees. Save the world.'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    // Perform a tap on the login button.
    await tester.tap(find.text('Login'));
    await tester.pump();

    // In a real-world scenario, you would need to mock the AuthService and validate its behavior.
    // For simplicity, we'll just check if the method is called.
    expect(AuthService().signInWithGoogleCalled, isTrue);
  });
}
