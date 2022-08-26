import 'package:flutter/material.dart';

import 'menu_float_app.dart';

const String titleWidgetTarget = 'Click me';
const double landscapeWidth = 1024;
const double landscapeHeight = 769;

void main() {
  runApp(const MenuFloatDemo());
}

Widget makeTargetButton() {
  return ElevatedButton(
      onPressed: () => {}, child: const Text(titleWidgetTarget));
}

final target = makeTargetButton();

class MenuFloatAppDemo extends StatelessWidget {
  final Widget target;
  final bool top;
  final bool left;
  final bool right;
  final double x;
  final double y;

  const MenuFloatAppDemo({
    Key? key,
    required this.target,
    this.top = false,
    this.left = false,
    this.right = false,
    required this.x,
    required this.y,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuFloatAppTestPage(
        target: target, x: x, y: y, top: top, left: left, right: right);
  }
}

class MenuFloatDemo extends StatelessWidget {
  const MenuFloatDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Stack(
        children: [
          // y: 0
          MenuFloatAppDemo(target: target, x: 0, y: 0),
          MenuFloatAppDemo(target: target, x: 500, y: 0),
          MenuFloatAppDemo(target: target, x: 930, y: 0),
          // y: 400
          MenuFloatAppDemo(target: target, x: 0, y: 400),
          MenuFloatAppDemo(target: target, x: 500, y: 400),
          MenuFloatAppDemo(target: target, x: 930, y: 400),
          // y: 730
          MenuFloatAppDemo(target: target, x: 0, y: 730),
          MenuFloatAppDemo(target: target, x: 500, y: 730),
          MenuFloatAppDemo(target: target, x: 930, y: 730),
        ],
      ),
    );
  }
}
