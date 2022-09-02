import 'dart:math';
import 'dart:ui';

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
      required this.items})
      : super(key: key);

  @override
  State<MenuFloat> createState() => _MenuFloatState<T>();
}

class _MenuFloatState<T> extends State<MenuFloat<T>>
    with SingleTickerProviderStateMixin {
  late int randomKey = Random().nextInt(100000);
  late GlobalObjectKey triggerKey =
      GlobalObjectKey<_MenuFloatState<T>>('trigger-key-$randomKey');
  late GlobalObjectKey menuKey =
      GlobalObjectKey<_MenuFloatState<T>>('menu-key-$randomKey');

  MenuFloatPosition? floatPosition;
  bool hasTriggerFocus = false;
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

    final triggerPositionAndSize = getWidgetPositionAndSizeRelativeToWindow(
        triggerKey.currentContext?.findRenderObject() as RenderBox);

    final overflowLeft = style.left - menuPositionAndSize.width;
    final hasOverflowLeft = overflowLeft < 0;
    if (hasOverflowLeft) {
      style.left = 0;
    }

    final windowWidth = window.physicalSize.width;
    final overflowRight =
        windowWidth - (style.left + menuPositionAndSize.width);

    final hasOverflowRight = overflowRight < 0;
    if (hasOverflowRight) {
      style.left = windowWidth - menuPositionAndSize.width;
    }

    final overflowTop = style.top - menuPositionAndSize.height;
    final hasOverflowTop = overflowTop < 0;
    if (hasOverflowTop) {
      style.top = triggerPositionAndSize.height;
    }

    final windowHeight = window.physicalSize.height;
    final overflowBottom =
        windowHeight - (style.top + menuPositionAndSize.height);
    final hasOverflowBottom = overflowBottom < 0;

    if (hasOverflowBottom) {
      style.top =
          triggerPositionAndSize.top - menuPositionAndSize.height - offset * 2;
    }
    return style;
  }

  MenuFloatPosition getIdealPosition() {
    final triggerPositionAndSize = getWidgetPositionAndSizeRelativeToWindow(
        triggerKey.currentContext?.findRenderObject() as RenderBox);

    MenuFloatPosition style = MenuFloatPosition(top: 0, left: 0);
    if (widget.right) {
      style.left =
          triggerPositionAndSize.left - menuFloatMaxWidth - (offset * 2);
      style.top = triggerPositionAndSize.top - menuFloatMaxHeight / 2;
    } else if (widget.left) {
      style.left = triggerPositionAndSize.left +
          triggerPositionAndSize.width +
          (offset * 2);
      style.top = triggerPositionAndSize.top - menuFloatMaxHeight / 2;
    } else if (widget.top) {
      style.left = triggerPositionAndSize.left;
      style.top = triggerPositionAndSize.top -
          (menuFloatMaxHeight - triggerPositionAndSize.height) +
          offset;
    } else {
      style.left = triggerPositionAndSize.left;
      style.top = triggerPositionAndSize.top +
          triggerPositionAndSize.height +
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
          setState(() {
            hasMenuFocus = false;
          });
          hideMenu(asyncClose: false);
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
                    if (mounted) {
                      setState(() {
                        hasMenuFocus = false;
                      });
                      hideMenu();
                    }
                  },
                  onEnter: (PointerEnterEvent e) {
                    if (mounted) {
                      setState(() {
                        hasMenuFocus = true;
                      });
                    }
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
    if (mounted) {
      if (menuKey.currentContext == null) {
        await Future.delayed(const Duration(milliseconds: 100));
        await setFloatPosition(overlayState);
        return;
      }
      overlayState?.setState(() {
        floatPosition = getIdealPosition();
      });
    }
  }

  void hideMenu({bool asyncClose = true}) async {
    if (asyncClose) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (!hasTriggerFocus && !hasMenuFocus && entry != null && entry!.mounted) {
      entry?.remove();
      setState(() {
        floatPosition = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: triggerKey,
        child: GestureDetector(
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: IgnorePointer(
                  ignoring: true,
                  child: widget.child,
                ),
                onEnter: (PointerEnterEvent e) {
                  setState(() {
                    hasTriggerFocus = true;
                  });
                },
                onExit: (PointerExitEvent e) {
                  setState(() {
                    hasTriggerFocus = false;
                  });
                  hideMenu();
                }),
            onTap: () {
              showMenu();
            }));
  }
}
