import 'package:flutter_test/flutter_test.dart';
import 'package:capsule/main.dart';

void main() {
  testWidgets('CapsuleApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CapsuleApp());
    expect(find.text('Capsule'), findsOneWidget);
  });
}
