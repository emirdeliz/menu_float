import 'package:flutter/material.dart';
import 'package:menu_float/demo/__mock__/menu_float.mock.dart';
import 'package:menu_float/menu_float.dart';
import 'package:menu_float/src/widgets/menu_float_item/menu_float_item.dart';

void main() {
  runApp(const MenuFloatDemo());
}

class MenuFloatDemo extends StatelessWidget {
  const MenuFloatDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MenuFloatDemoPage(title: 'Menu Float Demo Page'),
    );
  }
}

class MenuFloatDemoPage extends StatefulWidget {
  const MenuFloatDemoPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MenuFloatDemoPage> createState() => _MenuFloatDemoPageState();
}

class _MenuFloatDemoPageState extends State<MenuFloatDemoPage> {
  @override
  Widget build(BuildContext context) {
    final menusOptions = productMock.map<MenuFloatOption<Product>>((e) {
      return MenuFloatOption<Product>(label: e.name, value: e);
    }).toList();

    return Scaffold(
        appBar: null,
        body: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            MenuFloat<Product>(
              title: 'Hello menu float bottom',
              items: menusOptions,
              child: Text('Hover me'),
            ),
            MenuFloat<Product>(
              title: 'Hello menu float top',
              top: true,
              items: menusOptions,
              child: Text('Hover me'),
            ),
            MenuFloat<Product>(
              title: 'Hello menu float Left',
              left: true,
              items: menusOptions,
              child: Text('Hover me'),
            ),
            MenuFloat(
              title: 'Hello menu float Right',
              right: true,
              items: menusOptions,
              child: Text('Hover me'),
            )
          ],
        ));
  }
}
