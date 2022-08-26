import 'package:flutter/material.dart';

import 'menu_float_app.dart';

const String titleWidgetTrigger = 'Click me';
const double landscapeWidth = 1024;
const double landscapeHeight = 769;

void main() {
  runApp(const MenuFloatDemo());
}

Widget makeTriggerButton() {
  return ElevatedButton(
      onPressed: () => {}, child: const Text(titleWidgetTrigger));
}

final trigger = makeTriggerButton();

class MenuFloatAppDemo extends StatelessWidget {
  final Widget trigger;
  final bool top;
  final bool left;
  final bool right;
  final double x;
  final double y;

  const MenuFloatAppDemo({
    Key? key,
    required this.trigger,
    this.top = false,
    this.left = false,
    this.right = false,
    required this.x,
    required this.y,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuFloatAppTestPage(
        trigger: trigger, x: x, y: y, top: top, left: left, right: right);
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
          MenuFloatAppDemo(trigger: trigger, x: 0, y: 0),
          MenuFloatAppDemo(trigger: trigger, x: 500, y: 0),
          MenuFloatAppDemo(trigger: trigger, x: 930, y: 0),
          // y: 400
          MenuFloatAppDemo(trigger: trigger, x: 0, y: 400),
          MenuFloatAppDemo(trigger: trigger, x: 500, y: 400),
          MenuFloatAppDemo(trigger: trigger, x: 930, y: 400),
          // y: 730
          MenuFloatAppDemo(trigger: trigger, x: 0, y: 730),
          MenuFloatAppDemo(trigger: trigger, x: 500, y: 730),
          MenuFloatAppDemo(trigger: trigger, x: 930, y: 730),
        ],
      ),
    );
  }
}
