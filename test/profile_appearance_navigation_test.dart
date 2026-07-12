import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mc_ssp/features/authentication/presentation/pages/appearance.dart';
import 'package:mc_ssp/features/profile.dart';

void main() {
  testWidgets('tapping Appearance opens the appearance screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    await tester.tap(find.text('Appearance').first);
    await tester.pumpAndSettle();

    expect(find.byType(AppearanceScreen), findsOneWidget);
  }, skip: true);
}
