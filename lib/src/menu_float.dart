import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:menu_float/src/menu_float_item.dart';

const double menuFloatWidthDefault = 300;
const double menuFloatHeightDefault = 300;

class MenuFloatPosition {
  double top;
  double left;

  MenuFloatPosition({required this.top, required this.left});
}

class MenuFloat<T> extends StatefulWidget {
  final Widget child;
  final String title;
  final List<MenuFloatOption<T>> items;
  final bool top;
  final bool left;
  final bool right;

  const MenuFloat(
      {Key? key,
      this.top = false,
      this.left = false,
      this.right = false,
      required this.child,
      required this.title,
      required this.items})
      : super(key: key);

  @override
  State<MenuFloat> createState() => _MenuFloatState<T>();
}

class MenuFloatIdealPosition extends MenuFloatPosition {
  double width;
  double height;
  MenuFloatIdealPosition({top, left, required this.width, required this.height})
      : super(top: top, left: left);
}

class _MenuFloatState<T> extends State<MenuFloat>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late GlobalKey mouseRegionKey = GlobalKey();
  late GlobalKey menuFloatRegionKey = GlobalKey();

  bool hasFocus = false;
  OverlayEntry? entry;

  MenuFloatIdealPosition getWidgetPositionAndSizeRelativeToWindow(
      RenderBox? renderBox) {
    final position = renderBox?.localToGlobal(Offset.zero);
    final double top = position?.dy ?? 0;
    final double left = position?.dx ?? 0;
    final double width = renderBox?.size.width ?? 0;
    final double height = renderBox?.size.height ?? 0;
    return MenuFloatIdealPosition(
        top: top, left: left, width: width, height: height);
  }

  MenuFloatPosition getIdealPosition() {
    final mouseRegionPositionSize = getWidgetPositionAndSizeRelativeToWindow(
        mouseRegionKey.currentContext?.findRenderObject() as RenderBox);

    MenuFloatPosition style = MenuFloatPosition(top: 0, left: 0);
    double offset = 3;

    if (widget.right) {
      style.left =
          mouseRegionPositionSize.left - menuFloatWidthDefault - (offset * 2);
      style.top = mouseRegionPositionSize.top - menuFloatHeightDefault / 2;
    } else if (widget.left) {
      style.left = mouseRegionPositionSize.left +
          mouseRegionPositionSize.width +
          (offset * 2);
      style.top = mouseRegionPositionSize.top - menuFloatHeightDefault / 2;
    } else if (widget.top) {
      style.left =
          mouseRegionPositionSize.left - (mouseRegionPositionSize.width * 2);
      style.top = mouseRegionPositionSize.top -
          (menuFloatHeightDefault - mouseRegionPositionSize.height * 2) +
          offset;
    } else {
      style.left =
          mouseRegionPositionSize.left - (mouseRegionPositionSize.width * 2);
      style.top =
          mouseRegionPositionSize.top - mouseRegionPositionSize.height - offset;
    }

    final offsetWidth = MediaQuery.of(context).size.width;
    final overflowWidth = offsetWidth - mouseRegionPositionSize.left;
    final overflowLeft =
        (style.left + overflowWidth) - mouseRegionPositionSize.width;
    final hasOverflowLeft = overflowLeft < 0;
    if (hasOverflowLeft) {
      final left = style.left + overflowLeft;
      style.left = left < 0 ? offset : left;
    }

    final overflowRight = overflowWidth - mouseRegionPositionSize.width;
    final hasOverflowRight = overflowRight < 0;
    if (hasOverflowRight) {
      style.left = offsetWidth - mouseRegionPositionSize.width - offset;
    }
    return style;
  }

  List<Widget> buildMenuFloatItems() {
    List<MenuFloatItem<T>> items = widget.items.map((e) {
      return MenuFloatItem<T>(
        option: e.value,
        onClick: (T v) {
          print(e.label);
        },
      );
    }).toList();
    return items;
  }

  void showMenu() {
    if (hasFocus) {
      return;
    }

    hasFocus = true;
    entry = OverlayEntry(builder: (context) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        MenuFloatPosition style = getIdealPosition();
        return Stack(
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.none,
            children: [
              Positioned.fromRect(
                  rect: Rect.fromLTWH(style.left, style.top,
                      menuFloatWidthDefault, menuFloatHeightDefault),
                  child: MouseRegion(
                    onHover: (PointerHoverEvent e) {
                      renewFocus();
                    },
                    onExit: (PointerExitEvent e) {
                      hideMenu();
                    },
                    child: SizeTransition(
                      sizeFactor: _expandAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                            child: Column(children: buildMenuFloatItems())),
                        //width: double.maxFinite,
                      ),
                    ),
                  )),
            ]);
      });
    });
    Overlay.of(context)?.insert(entry!);
  }

  void hideMenu() {
    hasFocus = false;
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (!hasFocus && entry != null && entry!.mounted) {
        entry?.remove();
      }
    });
  }

  void renewFocus() {
    hasFocus = true;
  }

  // @override
  // void didUpdateWidget(covariant MenuFloat oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                  child: MouseRegion(
                    key: mouseRegionKey,
                    cursor: SystemMouseCursors.click,
                    child: widget.child,
                    onExit: (PointerExitEvent e) {
                      hideMenu();
                    },
                  ),
                  onTap: () {
                    showMenu();
                  })
            ]));
  }
}
