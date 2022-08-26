import 'package:flutter/material.dart';

import 'menu_float_app.dart';

const String titleWidgetTarget = 'Click me';
// const String titleOptionMenu = 'Telefone';
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

class MenuFloatDemo extends StatelessWidget {
  const MenuFloatDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu Float Demo',
      home: Stack(
        children: [
          // y: 0
          MenuFloatAppTest(target: target, x: 0, y: 0),
          MenuFloatAppTest(target: target, x: 500, y: 0),
          MenuFloatAppTest(target: target, x: 930, y: 0),
          // y: 400
          MenuFloatAppTest(target: target, x: 0, y: 400),
          MenuFloatAppTest(target: target, x: 500, y: 400),
          MenuFloatAppTest(target: target, x: 930, y: 400),
          // y: 730
          MenuFloatAppTest(target: target, x: 0, y: 730),
          MenuFloatAppTest(target: target, x: 500, y: 730),
          MenuFloatAppTest(target: target, x: 930, y: 730),
        ],
      ),
    );
  }
}
