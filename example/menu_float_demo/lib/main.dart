import 'package:flutter/material.dart';

import 'menu_float_app.dart';

const double landscapeWidth = 1024;
const double landscapeHeight = 769;

void main() {
  runApp(const MenuFloatDemo());
}

class MenuFloatAppDemo extends StatelessWidget {
  final bool top;
  final bool left;
  final bool right;
  final double x;
  final double y;

  const MenuFloatAppDemo({
    Key? key,
    this.top = false,
    this.left = false,
    this.right = false,
    required this.x,
    required this.y,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuFloatAppTestPage(x: x, y: y, top: top, left: left, right: right);
  }
}

class MenuFloatDemo extends StatelessWidget {
  const MenuFloatDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Stack(
        children: const [
          // y: 0
          MenuFloatAppDemo(x: 0, y: 0),
          MenuFloatAppDemo(x: 500, y: 0),
          MenuFloatAppDemo(x: 930, y: 0),
          // y: 400
          MenuFloatAppDemo(x: 0, y: 400),
          MenuFloatAppDemo(x: 500, y: 400),
          MenuFloatAppDemo(x: 930, y: 400),
          // y: 730
          MenuFloatAppDemo(x: 0, y: 730),
          MenuFloatAppDemo(x: 500, y: 730),
          MenuFloatAppDemo(x: 930, y: 730),
        ],
      ),
    );
  }
}
