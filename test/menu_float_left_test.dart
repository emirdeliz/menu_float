import 'package:flutter_test/flutter_test.dart';
import 'menu_float_utils.dart';

void main() {
  group('menu float left: with y = 0', () {
    testWidgets('have menu for the button on top-left', (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await initializeAndTapAtPosition(tester, 0, 0, 40, 15);

      final menu = find.text(titleOptionMenu);
      expect(menu, findsOneWidget);

      await tester.tap(menu);
      await tester.pumpAndSettle();
      expect(find.text(titleOptionMenu), findsOneWidget);
    });

    testWidgets('have menu for the button on top-left', (tester) async {
      await initializeAndTapAtPosition(tester, 500, 0, 515, 15);

      final menu = find.text(titleOptionMenu);
      expect(menu, findsOneWidget);

      await tester.tap(menu);
      await tester.pumpAndSettle();
      expect(find.text(titleOptionMenu), findsOneWidget);
    });

    testWidgets('have menu for the button on top-left', (tester) async {
      await initializeAndTapAtPosition(tester, 930, 0, 945, 15);

      final menu = find.text(titleOptionMenu);
      expect(menu, findsOneWidget);

      await tester.tap(menu);
      await tester.pumpAndSettle();
      expect(find.text(titleOptionMenu), findsOneWidget);
    });
  });

  group('menu float left: with y = 400', () {
    testWidgets('have menu for the button on center-left', (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await initializeAndTapAtPosition(tester, 0, 400, 40, 415);

      final menu = find.text(titleOptionMenu);
      expect(menu, findsOneWidget);

      await tester.tap(menu);
      await tester.pumpAndSettle();
      expect(find.text(titleOptionMenu), findsOneWidget);
    });

    testWidgets('have menu for the button on center-left', (tester) async {
      await initializeAndTapAtPosition(tester, 500, 400, 515, 415);

      final menu = find.text(titleOptionMenu);
      expect(menu, findsOneWidget);

      await tester.tap(menu);
      await tester.pumpAndSettle();
      expect(find.text(titleOptionMenu), findsOneWidget);
    });

    testWidgets('have menu for the button on center-left', (tester) async {
      await initializeAndTapAtPosition(tester, 930, 400, 945, 415);

      final menu = find.text(titleOptionMenu);
      expect(menu, findsOneWidget);

      await tester.tap(menu);
      await tester.pumpAndSettle();
      expect(find.text(titleOptionMenu), findsOneWidget);
    });
  });

  group('menu float left: with y = 730', () {
    testWidgets('have menu for the button on bottom-left', (tester) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await initializeAndTapAtPosition(tester, 0, 730, 40, 745);

      final menu = find.text(titleOptionMenu);
      expect(menu, findsOneWidget);

      await tester.tap(menu);
      await tester.pumpAndSettle();
      expect(find.text(titleOptionMenu), findsOneWidget);
    });

    testWidgets('have menu for the button on bottom-left', (tester) async {
      await initializeAndTapAtPosition(tester, 500, 730, 515, 745);

      final menu = find.text(titleOptionMenu);
      expect(menu, findsOneWidget);

      await tester.tap(menu);
      await tester.pumpAndSettle();
      expect(find.text(titleOptionMenu), findsOneWidget);
    });

    testWidgets('have menu for the button on bottom-left', (tester) async {
      await initializeAndTapAtPosition(tester, 930, 730, 945, 745);

      final menu = find.text(titleOptionMenu);
      expect(menu, findsOneWidget);

      await tester.tap(menu);
      await tester.pumpAndSettle();
      expect(find.text(titleOptionMenu), findsOneWidget);
    });
  });
}
