import 'package:flutter_test/flutter_test.dart';
import 'package:airscope/app.dart';

void main() {
  testWidgets('AirScopeApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AirScopeApp());
    expect(find.text('AirScope App Initialized'), findsOneWidget);
  });
}