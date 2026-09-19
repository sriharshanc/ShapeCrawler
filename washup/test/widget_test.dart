import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:washup/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows the empty plan state and can generate a fair rota', (tester) async {
    await tester.pumpWidget(const WashupApp());
    await tester.pumpAndSettle();

    expect(find.text('Washup'), findsOneWidget);
    expect(find.text('No rota yet'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Generate plan'));
    await tester.pumpAndSettle();

    expect(find.text('No rota yet'), findsNothing);
    expect(find.textContaining('Washer 1'), findsWidgets);
  });

  testWidgets('bottom navigation switches between the four sections', (tester) async {
    await tester.pumpWidget(const WashupApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Setup'));
    await tester.pumpAndSettle();
    expect(find.text('Building setup'), findsOneWidget);

    await tester.tap(find.text('Flats'));
    await tester.pumpAndSettle();
    expect(find.text('Flats & tenants'), findsOneWidget);
  });
}
