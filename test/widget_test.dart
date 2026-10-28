import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/main.dart';
import 'package:password_generator/widgets/custom_option_tile.dart';
import 'package:password_generator/widgets/password_strength_meter.dart';
import 'package:password_generator/core/dart_basics.dart';

/// Experiment 10a: Widget Tests for UI Components
void main() {
  group('Experiment 10a: UI Widget Testing', () {
    testWidgets('CustomOptionTile renders title and responds to switch toggles',
        (WidgetTester tester) async {
      bool switched = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomOptionTile(
              title: 'Include Numbers',
              subtitle: '0-9 digits',
              icon: Icons.pin_rounded,
              value: false,
              onChanged: (val) {
                switched = val;
              },
            ),
          ),
        ),
      );

      // Verify text presence
      expect(find.text('Include Numbers'), findsOneWidget);
      expect(find.text('0-9 digits'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);

      // Tap switch
      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(switched, isTrue);
    });

    testWidgets('PasswordStrengthMeter displays correct strength label',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              strength: PasswordStrength.strong,
              entropy: 92.4,
            ),
          ),
        ),
      );

      expect(find.text('Strength Analysis'), findsOneWidget);
      expect(find.text('Strong'), findsOneWidget);
      expect(find.text('92.4 bits'), findsOneWidget);
    });

    testWidgets('PassShieldApp root launches and renders generator screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const PassShieldApp());
      await tester.pumpAndSettle();

      // Verify App Bar & Header Elements
      expect(find.text('PassShield'), findsOneWidget);
      expect(find.text('GENERATED CIPHERTEXT'), findsOneWidget);
      expect(find.text('Password Length'), findsOneWidget);
      expect(find.text('Generate New Password'), findsOneWidget);
    });
  });
}
