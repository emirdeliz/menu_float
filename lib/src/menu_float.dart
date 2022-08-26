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
  late int randomKey = Random().nextInt(100000);
  late GlobalObjectKey targetKey =
      GlobalObjectKey<_MenuFloatState<T>>('target-key-$randomKey');
  late GlobalObjectKey menuKey =
      GlobalObjectKey<_MenuFloatState<T>>('menu-key-$randomKey');

  MenuFloatPosition? floatPosition;
  bool hasTargetFocus = false;
  bool hasMenuFocus = false;
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
    final menuPositionAndSize = getWidgetPositionAndSizeRelativeToWindow(
        menuKey.currentContext?.findRenderObject() as RenderBox);

    final targetPositionAndSize = getWidgetPositionAndSizeRelativeToWindow(
        targetKey.currentContext?.findRenderObject() as RenderBox);

    final overflowLeft = style.left - menuPositionAndSize.width;
    final hasOverflowLeft = overflowLeft < 0;
    if (hasOverflowLeft) {
      style.left = 0;
    }

    final windowWidth = MediaQuery.of(context).size.width;
    final overflowRight =
        windowWidth - (style.left + menuPositionAndSize.width);

    final hasOverflowRight = overflowRight < 0;
    if (hasOverflowRight) {
      style.left = windowWidth - menuPositionAndSize.width;
    }

    final overflowTop = style.top - menuPositionAndSize.height;
    final hasOverflowTop = overflowTop < 0;
    if (hasOverflowTop) {
      style.top = targetPositionAndSize.height;
    }

    final windowHeight = MediaQuery.of(context).size.height;
    final overflowBottom =
        windowHeight - (style.top + menuPositionAndSize.height);
    final hasOverflowBottom = overflowBottom < 0;

    if (hasOverflowBottom) {
      style.top =
          targetPositionAndSize.top - menuPositionAndSize.height - offset * 2;
    }
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
      style.left = targetPositionAndSize.left;
      style.top = targetPositionAndSize.top -
          (menuFloatMaxHeight - targetPositionAndSize.height) +
          offset;
    } else {
      style.left = targetPositionAndSize.left;
      style.top = targetPositionAndSize.top +
          targetPositionAndSize.height +
          (offset * 2);
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

  Future<void> showMenu() async {
    final hasMenuOnWindow = floatPosition != null;
    if (hasMenuOnWindow) {
      return;
    }

    OverlayState? overlayState = Overlay.of(context);
    entry = OverlayEntry(
        maintainState: true,
        builder: (context) {
          return Positioned(
              left: floatPosition?.left,
              top: floatPosition?.top,
              child: MouseRegion(
                  onExit: (PointerExitEvent e) {
                    setState(() {
                      hasMenuFocus = false;
                    });
                    hideMenu();
                  },
                  onEnter: (PointerEnterEvent e) {
                    setState(() {
                      hasMenuFocus = true;
                    });
                  },
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Opacity(
                      opacity: floatPosition != null ? 1 : 0,
                      child: Container(
                          // width: floatPosition != null ? null : 0,
                          // height: floatPosition != null ? null : 0,
                          key: menuKey,
                          constraints: const BoxConstraints(
                              maxWidth: menuFloatMaxWidth,
                              maxHeight: menuFloatMaxHeight),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(-1, 3),
                              ),
                            ],
                          ),
                          child: Material(
                              child: ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: buildMenuFloatItems(),
                          ))),
                    )
                  ])));
        });
    overlayState?.insert(entry!);
    await setFloatPosition(overlayState);
  }

  Future<void> setFloatPosition(OverlayState? overlayState) async {
    if (menuKey.currentContext == null) {
      await Future.delayed(const Duration(milliseconds: 100));
      await setFloatPosition(overlayState);
      return;
    }
    overlayState?.setState(() {
      floatPosition = getIdealPosition();
    });
  }

  void hideMenu() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!hasTargetFocus && !hasMenuFocus && entry != null && entry!.mounted) {
      setState(() {
        floatPosition = null;
      });
      entry?.remove();
    }
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
                onEnter: (PointerEnterEvent e) {
                  setState(() {
                    hasTargetFocus = true;
                  });
                },
                onExit: (PointerExitEvent e) {
                  setState(() {
                    hasTargetFocus = false;
                  });
                  hideMenu();
                }),
            onTap: () {
              showMenu();
            }));
  }
}
