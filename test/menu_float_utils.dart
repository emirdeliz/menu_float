import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: avoid_relative_lib_imports
import '../example/lib/menu_float_example.dart';

/// A constant string that is used to find the widget.
const String titleWidgetTrigger = 'Button target';

/// A constant string that is used to find the widget.
const String titleOptionMenu = 'Mobile phone';

/// Setting the size of the window.
const double landscapeWidth = 1024;
const double landscapeHeight = 768;

/// It sets the size of the window
///
/// Args:
///   size (Size): The size of the window.
void setWindowSize(Size size) {
  TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  binding.window.physicalSizeTestValue = size;
  binding.window.devicePixelRatioTestValue = 1.0;
}

/// A function that is used to initialize the widget and tap at a specific position.
Future<void> initializeAndTapAtPosition(
    WidgetTester tester, double x, double y, double tapX, double tapY) async {
  setWindowSize(const Size(landscapeWidth, landscapeHeight));
  await tester.pumpWidget(MenuFloatExampleTest(x: x, y: y));
  await tester.pumpAndSettle();

  await tester.tapAt(Offset(tapX, tapY));
  await tester.pumpAndSettle(const Duration(seconds: 3));
  await tester.pump(const Duration(seconds: 3));
}
