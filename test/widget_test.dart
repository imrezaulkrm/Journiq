import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
void main() {
  testWidgets('Flutter test harness renders a Journiq surface', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Text('Journiq')));
    expect(find.text('Journiq'), findsOneWidget);
  });
}
