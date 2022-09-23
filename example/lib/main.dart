import 'package:flutter/material.dart';

import 'menu_float_example.dart';

const double landscapeWidth = 1024;
const double landscapeHeight = 769;

void main() {
  runApp(const MenuFloatDemo());
}

class MenuFloatExampleDemo extends StatelessWidget {
  final bool top;
  final bool left;
  final bool right;
  final double x;
  final double y;

  const MenuFloatExampleDemo({
    Key? key,
    this.top = false,
    this.left = false,
    this.right = false,
    required this.x,
    required this.y,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuFloatExampleTestPage(
        x: x, y: y, top: top, left: left, right: right);
  }
}

/// This class is a stateless widget that creates a menu float button
class MenuFloatDemo extends StatelessWidget {
  const MenuFloatDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Stack(
        children: const [
          // y: 0
          MenuFloatExampleDemo(x: 0, y: 0),
          MenuFloatExampleDemo(x: 500, y: 0),
          MenuFloatExampleDemo(x: 930, y: 0),
          // y: 400
          MenuFloatExampleDemo(x: 0, y: 400),
          MenuFloatExampleDemo(x: 500, y: 400),
          MenuFloatExampleDemo(x: 930, y: 400),
          // y: 730
          MenuFloatExampleDemo(x: 0, y: 730),
          MenuFloatExampleDemo(x: 500, y: 730),
          MenuFloatExampleDemo(x: 930, y: 730),
        ],
      ),
    );
  }
}
