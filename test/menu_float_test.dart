// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'menu_float_app_test.dart';

const String TITLE_WIDGET_TEST = 'Click me';
const double PORTRAIT_WIDTH = 1024;
const double PORTRAIT_HEIGHT = 767;
const double LANDSCAPE_WIDTH = PORTRAIT_HEIGHT;
const double LANDSCAPE_HEIGHT = PORTRAIT_WIDTH;

Widget makeTargetButton() {
  return ElevatedButton(
      onPressed: () => {}, child: const Text(TITLE_WIDGET_TEST));
}

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  group('have menu for the button', () {
    testWidgets('finds a Text widget', (tester) async {
      await binding.setSurfaceSize(const Size(PORTRAIT_WIDTH, PORTRAIT_HEIGHT));

      final target = makeTargetButton();
      await tester.pumpWidget(MenuFloatAppTest(target: target, x: 0, y: 0));

      await tester.pumpAndSettle();
      final button = find.byWidget(target);

      await tester.tap(button);
      await tester.pumpAndSettle();

      final menu = find.text(TITLE_WIDGET_TEST);
      expect(menu, findsOneWidget);
    });
  });
}
