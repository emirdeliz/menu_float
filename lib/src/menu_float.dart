import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:menu_float/src/menu_float_item.dart';

const double menuFloatMaxWidth = 300;
const double menuFloatMaxHeight = 300;
const double offset = 3;

class MenuFloatPosition {
  double top;
  double left;

  MenuFloatPosition({required this.top, required this.left});
}

class MenuFloatIdealPosition extends MenuFloatPosition {
  double width;
  double height;
  MenuFloatIdealPosition({top, left, required this.width, required this.height})
      : super(top: top, left: left);
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

class _MenuFloatState<T> extends State<MenuFloat<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late int randomKey = Random().nextInt(1000);

  late GlobalObjectKey targetKey =
      GlobalObjectKey<_MenuFloatState<T>>('target-key-$randomKey');
  late GlobalObjectKey menuKey =
      GlobalObjectKey<_MenuFloatState<T>>('menu-key-$randomKey');

  MenuFloatPosition? floatPosition;
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

  MenuFloatPosition maybeCheckAndFixOverflow(MenuFloatPosition style) {
    final targetPositionAndSize = getWidgetPositionAndSizeRelativeToWindow(
        targetKey.currentContext?.findRenderObject() as RenderBox);

    final menuPositionAndSize = getWidgetPositionAndSizeRelativeToWindow(
        menuKey.currentContext?.findRenderObject() as RenderBox);

    final windowWidth = MediaQuery.of(context).size.width;
    final overflowWidth = windowWidth - targetPositionAndSize.left;

    // print("windowWidth $windowWidth overflowWidth $overflowWidth");

    final overflowLeft = style.left - menuPositionAndSize.width;
    final hasOverflowLeft = overflowLeft < 0;
    if (hasOverflowLeft) {
      final left = style.left + overflowLeft;
      style.left = left < 0 ? offset : left;
    }

    final overflowRight =
        windowWidth - (style.left + menuPositionAndSize.width);
    final hasOverflowRight = overflowRight < 0;
    if (hasOverflowRight) {
      style.left = overflowRight - offset;
    }

    // final offsetHeight = MediaQuery.of(context).size.height;
    // final overflowHeight = offsetHeight - targetPositionAndSize.top;
    // final overflowTop = style.top - menuFloatMaxHeight;

    // final hasOverflowTop = overflowTop < 0;
    // if (hasOverflowTop) {
    //   final top = style.top + overflowTop;
    //   style.top = top < 0 ? offset : top;
    // }

    // final overflowBottom = overflowHeight - targetPositionAndSize.height;
    // final hasOverflowBottom = overflowBottom > 0;

    // print("overflowBottom: $overflowBottom");

    // if (hasOverflowBottom) {
    //   style.top = offsetHeight - targetPositionAndSize.height - offset;
    //   double c = style.top;
    //   print("S $c");
    // }
    return style;
  }

  MenuFloatPosition getIdealPosition() {
    final targetPositionAndSize = getWidgetPositionAndSizeRelativeToWindow(
        targetKey.currentContext?.findRenderObject() as RenderBox);

    MenuFloatPosition style = MenuFloatPosition(top: 0, left: 0);
    if (widget.right) {
      style.left =
          targetPositionAndSize.left - menuFloatMaxWidth - (offset * 2);
      style.top = targetPositionAndSize.top - menuFloatMaxHeight / 2;
    } else if (widget.left) {
      style.left = targetPositionAndSize.left +
          targetPositionAndSize.width +
          (offset * 2);
      style.top = targetPositionAndSize.top - menuFloatMaxHeight / 2;
    } else if (widget.top) {
      style.left =
          targetPositionAndSize.left - (targetPositionAndSize.width * 2);
      style.top = targetPositionAndSize.top -
          (menuFloatMaxHeight - targetPositionAndSize.height) +
          offset;
    } else {
      style.left =
          targetPositionAndSize.left - (targetPositionAndSize.width * 2);
      style.top =
          targetPositionAndSize.top + targetPositionAndSize.height + offset;
    }

    return maybeCheckAndFixOverflow(style);
  }

  List<ListTile> buildMenuFloatItems() {
    List<ListTile> items = widget.items.map((e) {
      final onClick = e.onClick;
      return ListTile(
        title: MenuFloatItem<T>(option: e),
        onTap: () {
          if (onClick != null) {
            onClick(e.value);
          }
        },
      );
    }).toList();
    return items;
  }

  void showMenu() {
    final hasMenuOnWindow = floatPosition != null;
    if (hasMenuOnWindow) {
      return;
    }

    hasFocus = true;
    entry = OverlayEntry(builder: (context) {
      return Positioned(
          left: floatPosition?.left,
          top: floatPosition?.top,
          width: menuFloatMaxWidth,
          height: menuFloatMaxHeight,
          child: MouseRegion(
              onHover: (PointerHoverEvent e) {
                renewFocus();
              },
              onExit: (PointerExitEvent e) {
                hideMenu();
              },
              child: SizeTransition(
                sizeFactor: _expandAnimation,
                child: Opacity(
                    // opacity: floatPosition != null ? 1 : 0,
                    opacity: 1,
                    child: Container(
                        key: menuKey,
                        constraints: const BoxConstraints(
                            maxWidth: menuFloatMaxWidth,
                            maxHeight: menuFloatMaxHeight),
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
                        child: Material(
                            child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: buildMenuFloatItems(),
                        )))),
              )));
    });

    OverlayState? overlayState = Overlay.of(context);
    _animationController.addListener(() {
      overlayState!.setState(() {});
    });
    _animationController.forward();
    // overlayState!.insert(entry!);
    Overlay.of(context, rootOverlay: true)?.insert(entry!);
    setFloatPosition();
  }

  void setFloatPosition() async {
    final hasMenuOnWindow = menuKey.currentContext != null;
    if (hasMenuOnWindow) {
      setState(() {
        floatPosition = getIdealPosition();
      });
    }
  }

  void hideMenu() {
    hasFocus = false;
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      if (!hasFocus && entry != null && entry!.mounted) {
        setState(() {
          print('Removed....');
          entry?.remove();
          floatPosition = null;
        });
      }
    });
  }

  void renewFocus() {
    hasFocus = true;
  }

  // @override
  // void didUpdateWidget(covariant MenuFloat<T> oldWidget) {
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
        key: targetKey,
        child: GestureDetector(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IgnorePointer(
                ignoring: true,
                child: widget.child,
              ),
              onHover: (PointerHoverEvent e) {
                renewFocus();
              },
            ),
            onTap: () {
              showMenu();
            }));
  }
}
