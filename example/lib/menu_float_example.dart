import 'package:flutter/material.dart';
import 'package:menu_float/menu_float.dart';
import '__mock__/menu_float.mock.dart';

const String titleWidgetTrigger = 'Button target';

/// A widget that is used to test the MenuFloat widget.
class MenuFloatExampleTest extends StatelessWidget {
  final bool top;
  final bool left;
  final bool right;
  final double x;
  final double y;

  const MenuFloatExampleTest({
    Key? key,
    this.top = false,
    this.left = false,
    this.right = false,
    required this.x,
    required this.y,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Stack(children: <Widget>[
      MenuFloatExampleTestPage(
        x: x,
        y: y,
        top: top,
        left: left,
        right: right,
      )
    ]));
  }
}

/// `MenuFloatExampleTestPage` is a `StatefulWidget` that creates a `MenuFloatExampleTestPageState`
class MenuFloatExampleTestPage extends StatefulWidget {
  final bool top;
  final bool left;
  final bool right;
  final double x;
  final double y;

  const MenuFloatExampleTestPage(
      {Key? key,
      required this.x,
      required this.y,
      this.top = false,
      this.left = false,
      this.right = false})
      : super(key: key);

  @override
  State<MenuFloatExampleTestPage> createState() =>
      _MenuFloatExampleTestPageState();
}

class _MenuFloatExampleTestPageState extends State<MenuFloatExampleTestPage> {
  String? selectedValue;

  /// It returns a list of MenuFloatOption objects, each of which has a title, a subtitle, and a
  /// callback function
  List<MenuFloatOption<Product>> makeMenuOptions() {
    final menusOptions = productMock.map<MenuFloatOption<Product>>((e) {
      return MenuFloatOption<Product>(
          label: Text(e.name,
              style: const TextStyle(color: Colors.black, fontSize: 12)),
          value: e,
          onClick: (Product v) {
            setState(() {
              selectedValue = e.name;
            });
          });
    }).toList();
    return menusOptions;
  }

  /// It returns a widget that, when tapped, triggers a Dart function
  Widget makeTriggerButton() {
    return ElevatedButton(
        onPressed: () => {}, child: Text(selectedValue ?? titleWidgetTrigger));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.x,
      top: widget.y,
      child: Container(
          alignment: Alignment.center,
          child: MenuFloat<Product>(
            items: makeMenuOptions(),
            top: widget.top,
            left: widget.left,
            right: widget.right,
            child: makeTriggerButton(),
          )),
    );
  }
}
