import 'package:flutter/material.dart';

class MenuFloatOption<T> {
  final String label;
  final T value;
  final Function(T v)? onClick;

  MenuFloatOption({
    required this.label,
    required this.value,
    this.onClick,
  });
}

class MenuFloatItem<T> extends StatelessWidget {
  final MenuFloatOption<T> option;

  const MenuFloatItem({Key? key, required this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      // decoration: BoxDecoration(
      //     color: Colors.white, border: Border.all(color: Colors.red)),
      child: Text(option.label,
          style: const TextStyle(color: Colors.black, fontSize: 12)),
    );
  }
}
