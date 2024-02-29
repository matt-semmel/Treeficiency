import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:../lib/pages/home_page.dart';

class MockApplianceDataBase extends Mock implements ApplianceDataBase {}

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('Renders HomePage Widget', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(Treeficiency());

      // Verify that the HomePage widget is rendered.
      expect(find.byType(home_page), findsOneWidget);
    });

    testWidgets('Tapping on refresh icon updates Tree Points', (WidgetTester tester) async {
      // Mock ApplianceDataBase
      final mockDatabase = MockApplianceDataBase();
      await tester.pumpWidget(Treeficiency(database: mockDatabase));

      // Tap on the refresh icon
      await tester.tap(find.byIcon(Icons.refresh_sharp));
      await tester.pump();

      // Verify that the updateTreeCounter method is called
      verify(mockDatabase.updateTreeCounter()).called(1);
    });

  });
}