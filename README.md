# menu_float

[![Menu Float Actions](https://github.com/emirdeliz/menu_float/actions/workflows/main.yml/badge.svg)](https://github.com/emirdeliz/menu_float/actions/workflows/main.yml)

This widget makes a floating menu appear in the window when clicking on another widget, like a button or link, for example.

<img src="https://github.com/emirdeliz/menu_float/blob/master/assets/example.gif" width="300" height="auto" alt="Menu float - example"/>

## Getting Started
The use is very simple. The menu float receives a generic object to determine what object it has to send after the options click.

```dart
class Product {
  final String name;
  final double value;
  ...
}

final options = [
  MenuFloatOption<T>(
    label: e.name,
    value: e,
    onClick: (Product v) {
      final n = v.name;
      print('Product is: $n');
    })
  ),
  ...
]

MenuFloat<Product>(
  items: options,
  child: ElevatedButton(
    onPressed: () => {}, 
    child: const Text('Click me')
  ),
))
```

For more details see the project demo in the [example
](https://github.com/emirdeliz/menu_float/tree/master/example/menu_float_demo)folder.

About the props:

| **Prop**  | **Type** | **Description** |
|-----------|----------|---------------------------------------------------------------------|
| **top** | boolean | Define the priority to open the menu on top of the trigger. |
| **left** | boolean | Define the priority to open the menu on left of the trigger. |
| **right** | boolean | Define the priority to open the menu on right of the trigger. |
| **child** | Widget | Trigger widget (like ElevatedButton, Text and etc...). |
| **items** | List<MenuFloatOption<T>> | Menu options. |
