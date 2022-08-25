import 'package:flutter/material.dart';
import 'package:menu_float/menu_float.dart';

import '__mock__/menu_float.mock.dart';

const double landscapeWidth = 1024;
const double landscapeHeight = 768;
final menusOptions = productMock.map<MenuFloatOption<Product>>((e) {
  return MenuFloatOption<Product>(
      label: e.name,
      value: e,
      onClick: (Product v) {
        // ignore: avoid_print
        print(v.name);
      });
}).toList();

class MenuFloatAppTest extends StatelessWidget {
  final Widget target;
  final bool top;
  final bool left;
  final bool right;
  final double x;
  final double y;

  const MenuFloatAppTest({
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
    return MediaQuery(
        data: const MediaQueryData(size: Size(landscapeWidth, landscapeHeight)),
        child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(initialEntries: <OverlayEntry>[
              OverlayEntry(builder: (BuildContext context) {
                return Stack(children: <Widget>[
                  MenuFloatAppTestPage(
                    target: target,
                    x: x,
                    y: y,
                    top: top,
                    left: left,
                    right: right,
                  )
                ]);
              })
            ])));
  }
}

class MenuFloatAppTestPage extends StatefulWidget {
  final bool top;
  final bool left;
  final bool right;
  final double x;
  final double y;
  final Widget target;

  const MenuFloatAppTestPage(
      {Key? key,
      required this.target,
      required this.x,
      required this.y,
      this.top = false,
      this.left = false,
      this.right = false})
      : super(key: key);

  @override
  State<MenuFloatAppTestPage> createState() => _MenuFloatAppTestPageState();
}

class _MenuFloatAppTestPageState extends State<MenuFloatAppTestPage> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.x,
      top: widget.y,
      child: Container(
          alignment: Alignment.center,
          child: MenuFloat<Product>(
            title: 'Hello menu float',
            items: menusOptions,
            top: widget.top,
            left: widget.left,
            right: widget.right,
            child: widget.target,
          )),
    );
  }
}
