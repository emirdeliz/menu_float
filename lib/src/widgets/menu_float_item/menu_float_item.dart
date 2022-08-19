import 'package:flutter/material.dart';

class MenuFloatOption<T> {
  final String label;
  final T value;

  MenuFloatOption({required this.label, required this.value});
}

class MenuFloatItem<T> extends StatelessWidget {
  final MenuFloatOption option;

  const MenuFloatItem({Key? key, required this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print('CLICK!!!');
        },
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              alignment: Alignment.centerLeft,
              color: Colors.white,
              // decoration: BoxDecoration(
              //     color: Colors.white, border: Border.all(color: Colors.red)),
              child: Text(option.label,
                  style: const TextStyle(color: Colors.black, fontSize: 12)),
            )));
  }
}
