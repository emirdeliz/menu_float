// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'menu_float_app.dart';

const String titleWidgetTarget = 'Click me';
const String titleOptionMenu = 'Telefone';

Widget makeTargetButton() {
  return ElevatedButton(
      onPressed: () => {}, child: const Text(titleWidgetTarget));
}

Future<void> initializeAndTapAtPosition(
    WidgetTester tester, double x, double y, double tapX, double tapY) async {
  final target = makeTargetButton();
  await tester.pumpWidget(MenuFloatAppTest(target: target, x: x, y: y));
  await tester.pumpAndSettle();

  await tester.tapAt(Offset(tapX, tapY));
  await tester.pumpAndSettle(const Duration(seconds: 3));
  await tester.pump(const Duration(seconds: 3));
}

void main() {
  group('menu float: left', () {
    testWidgets('have menu for the button on top-left', (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await initializeAndTapAtPosition(tester, 0, 0, 40, 15);

      final menu = find.text(titleOptionMenu);
      expect(menu, findsOneWidget);
    });

    testWidgets('have menu for the button on center-left', (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await initializeAndTapAtPosition(tester, 40, 400, 40, 415);

      final menu = find.text(titleOptionMenu);
      expect(menu, findsOneWidget);
    });

    testWidgets('have menu for the button on bottom-left', (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await initializeAndTapAtPosition(tester, 40, 730, 40, 745);

      final menu = find.text(titleOptionMenu);
      expect(menu, findsOneWidget);
    });
  });
}
