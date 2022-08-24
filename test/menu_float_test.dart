// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'menu_float_app.dart';

const String TITLE_WIDGET_TARGET = 'Click me';
const String TITLE_OPTION_MENU = 'Telefone';
const double LANDSCAPE_WIDTH = 1024;
const double LANDSCAPE_HEIGHT = 769;

Widget makeTargetButton() {
  return ElevatedButton(
      onPressed: () => {}, child: const Text(TITLE_WIDGET_TARGET));
}

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  group('have menu for the button', () {
    testWidgets('finds a Text widget', (tester) async {
      await binding
          .setSurfaceSize(const Size(LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT));

      final target = makeTargetButton();
      await tester.pumpWidget(MenuFloatAppTest(target: target, x: 0, y: 0));

      await tester.pumpAndSettle();
      final button = find.byWidget(target);

      await tester.tap(button);
      await tester.pumpAndSettle();

      final menu = find.text(TITLE_WIDGET_TARGET);
      expect(menu, findsOneWidget);
    });
  });
}
