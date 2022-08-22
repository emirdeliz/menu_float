// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:menu_float/menu_float.dart';

import '__mock__/menu_float.mock.dart';

void mainTest(Widget target) {
  runApp(MenuFloatAppTest(target: target));
}

final menusOptions = productMock.map<MenuFloatOption<Product>>((e) {
  return MenuFloatOption<Product>(
      label: e.name,
      value: e,
      onClick: (Product v) {
        print(v.name);
      });
}).toList();

class MenuFloatAppTest extends StatelessWidget {
  final Widget target;
  const MenuFloatAppTest({
    Key? key,
    required this.target,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuFloatAppTestPage(
        target: target,
      ),
    );
  }
}

class MenuFloatAppTestPage extends StatefulWidget {
  const MenuFloatAppTestPage({Key? key, required this.target})
      : super(key: key);
  final Widget target;

  @override
  State<MenuFloatAppTestPage> createState() => _MenuFloatAppTestPageState();
}

class _MenuFloatAppTestPageState extends State<MenuFloatAppTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MenuFloat<Product>(
                  title: 'Hello menu float',
                  items: menusOptions,
                  child: widget.target,
                )
              ],
            )));
  }
}
