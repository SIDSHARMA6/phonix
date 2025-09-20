import 'package:flutter_test/flutter_test.dart';
import 'package:joyeeform/main.dart';

void main() {
  testWidgets('Quiz app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizApp());

    // Verify that Phoenix header is displayed
    expect(find.text('PHOENIX'), findsOneWidget);

    // Verify that first question is displayed
    expect(find.textContaining('Do you ever have a problem'), findsOneWidget);

    // Verify that answer options are displayed
    expect(find.text('Yes, every time'), findsOneWidget);
  });
}
