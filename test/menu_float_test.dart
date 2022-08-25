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
  testWidgets('have menu for the button', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeAndTapAtPosition(tester, 0, 0, 40, 15);

    final menu = find.text(titleOptionMenu);
    expect(menu, findsOneWidget);
  });
}
