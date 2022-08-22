// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'menu_float_app_test.dart';

const String TITLE_WIDGET_TEST = 'Click me';
const double PORTRAIT_WIDTH = 1024;
const double PORTRAIT_HEIGHT = 768;
const double LANDSCAPE_WIDTH = PORTRAIT_HEIGHT;
const double LANDSCAPE_HEIGHT = PORTRAIT_WIDTH;

Widget makeTargetButton() {
  return ElevatedButton(
      onPressed: () => {}, child: const Text(TITLE_WIDGET_TEST));
}

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Have menu for the button', (tester) async {
      await binding.setSurfaceSize(const Size(PORTRAIT_WIDTH, PORTRAIT_HEIGHT));

      final target = makeTargetButton();
      tester.pumpWidget(MenuFloatAppTest(target: target, x: 0, y: 0));

      await tester.pumpAndSettle();
      final button = find.byWidget(target);

      await tester.tap(button);
      await tester.pumpAndSettle();

      final menu = find.text(TITLE_WIDGET_TEST);
      expect(menu, findsOneWidget);

      // tester.pumpWidget(

      // // Verify the counter starts at 0.
      // expect(find.text('0'), findsOneWidget);

      // // Finds the floating action button to tap on.
      // final Finder fab = find.byTooltip('Increment');

      // // Emulate a tap on the floating action button.
      // await tester.tap(fab);

      // // Trigger a frame.
      // await tester.pumpAndSettle();

      // // Verify the counter increments by 1.
      // expect(find.text('1'), findsOneWidget);
    });
  });
}
