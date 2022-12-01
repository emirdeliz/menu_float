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
  final double width;
  final double height;
  MenuFloatIdealPosition({
    top,
    left,
    required this.width,
    required this.height,
  }) : super(top: top, left: left);
}

class MenuFloat<T> extends StatefulWidget {
  final Widget child;
  final List<MenuFloatOption<T>> items;
  final double? offsetTop;
  final double? offsetBottom;
  final double? offsetLeft;
  final double? offsetRight;
  final bool top;
  final bool left;
  final bool right;

  const MenuFloat({
    Key? key,
    this.top = false,
    this.left = false,
    this.right = false,
    this.offsetTop = 0,
    this.offsetLeft = 0,
    this.offsetBottom,
    this.offsetRight,
    required this.child,
    required this.items,
  }) : super(key: key);

  @override
  State<MenuFloat> createState() => _MenuFloatState<T>();
}

class _MenuFloatState<T> extends State<MenuFloat<T>>
    with SingleTickerProviderStateMixin {
  /// Generating a random number to be used as a key for the menu.
  late int randomKey = Random().nextInt(100000);

  /// Creating a unique key for the trigger element.
  late GlobalObjectKey triggerKey =
      GlobalObjectKey<_MenuFloatState<T>>('trigger-key-$randomKey');

  /// Creating a unique key for the menu element.
  late GlobalObjectKey menuKey =
      GlobalObjectKey<_MenuFloatState<T>>('menu-key-$randomKey');

  /// A nullable variable.
  MenuFloatPosition? floatPosition;

  /// This is a variable that is used to check if the trigger element has the focus.
  bool hasTriggerFocus = false;

  /// This is a variable that is used to check if the trigger element has the focus.
  bool hasMenuFocus = false;

  /// This is a variable that is used to store the menu element.
  OverlayEntry? entry;

  /// Get the info about the element relative to the window like positions x, y, width, and height.
  /// Returns a MenuFloatIdealPosition.
  MenuFloatIdealPosition _getWidgetPositionAndSizeRelativeToWindow(
      BuildContext? menuKeyContext) {
    final navigator = Navigator.of(context);
    final RenderBox renderBox = menuKeyContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(
      Offset.zero, 
      ancestor: navigator.context.findRenderObject(),
    );
    final double top = position.dy;
    final double left = position.dx;
    final double width = renderBox.size.width;
    final double height = renderBox.size.height;

    return MenuFloatIdealPosition(
        top: top, left: left, width: width, height: height);
  }

  /// Check if the menu position is outside of the window.
  /// If true this means that the menu will be cut after opens.
  /// To fix this the method calc a new position considering to point in the other direction.
  /// Returns a MenuFloatPosition.
  MenuFloatPosition _maybeCheckAndFixOverflow(MenuFloatPosition style) {
    /// This is getting the position and size of the trigger element relative to the window.
    final menuPositionAndSize =
        _getWidgetPositionAndSizeRelativeToWindow(menuKey.currentContext);

    /// This is getting the position and size of the trigger element relative to the window.
    final triggerPositionAndSize =
        _getWidgetPositionAndSizeRelativeToWindow(triggerKey.currentContext);

    const overflowWidth = 5.00;

    /// This is getting the overflow of the menu on the left side of the window.
    final overflowLeft = style.left - menuPositionAndSize.width;

    /// This is checking if the menu position is outside of the window.
    /// If true this means that the menu will be cut after opens.
    final hasOverflowLeft = overflowLeft - overflowWidth < 0;
    if (hasOverflowLeft) {
      /// Setting the left position of the menu to fix the overflow.
      style.left = overflowWidth;
    }

    final windowWidth = MediaQuery.of(context).size.width;

    /// This is getting the overflow of the menu on the right side of the window.
    final overflowRight =
        windowWidth - (style.left + menuPositionAndSize.width);

    /// This is checking if the menu position is outside of the window.
    /// If true this means that the menu will be cut after opens.
    final hasOverflowRight = overflowRight - overflowWidth < 0;
    if (hasOverflowRight) {
      /// Setting the left position of the menu to fix the overflow.
      style.left = windowWidth - menuPositionAndSize.width;
    }

    /// Getting the overflow of the menu on the top side of the window.
    final overflowTop = style.top - menuPositionAndSize.height;

    /// Checking if the menu position is outside of the window.
    final hasOverflowTop = overflowTop < 0;
    if (hasOverflowTop) {
      /// Setting the top position of the menu to fix the overflow.
      style.top = triggerPositionAndSize.height;
    }

    final windowHeight = MediaQuery.of(context).size.height;

    /// Calculating the overflow of the menu from the bottom of the screen.
    final overflowBottom =
        windowHeight - (style.top + menuPositionAndSize.height);

    /// Checking if the overflowBottom is less than 0.
    final hasOverflowBottom = overflowBottom < 0;
    if (hasOverflowBottom) {
      /// Setting the top position of the menu to fix the overflow.
      style.top = (triggerPositionAndSize.top -
          menuPositionAndSize.height -
          offset * 2);
    }

    return style;
  }

  /// Calculate the menu position and apply the fix if the position in on the outside of the window.
  /// Returns a MenuFloatPosition.
  MenuFloatPosition _getIdealPosition() {
    /// This is getting the position and size of the trigger element relative to the window.
    final triggerPositionAndSize =
        _getWidgetPositionAndSizeRelativeToWindow(triggerKey.currentContext);

    MenuFloatPosition style = MenuFloatPosition(top: 0, left: 0);
    if (widget.right) {
      /// Setting the left position of the menu to the left position of the trigger minus the menu's max
      /// width minus the offset times 2.
      style.left =
          triggerPositionAndSize.left - menuFloatMaxWidth - (offset * 2);

      /// The above code is setting the top position of the menu to be the top position of the trigger
      /// minus half the height of the menu.
      style.top = triggerPositionAndSize.top - menuFloatMaxHeight / 2;
    } else if (widget.left) {
      /// Setting the style.left property to the triggerPositionAndSize.left +
      /// triggerPositionAndSize.width + (offset * 2).
      style.left = triggerPositionAndSize.left +
          triggerPositionAndSize.width +
          (offset * 2);

      /// Setting the top position of the menu to be the top position of the trigger minus half the
      /// height of the menu.
      style.top = triggerPositionAndSize.top - menuFloatMaxHeight / 2;
    } else if (widget.top) {
      /// Setting the style.left property of the tooltip to the left position of the trigger.
      style.left = triggerPositionAndSize.left;

      /// Setting the top position of the menu to the top position of the trigger minus the difference
      /// between the max height of the menu and the height of the trigger plus the offset.
      style.top = triggerPositionAndSize.top -
          (menuFloatMaxHeight - triggerPositionAndSize.height) +
          offset;
    } else {
      /// Setting the style.left property of the tooltip to the left position of the trigger.
      style.left = triggerPositionAndSize.left;

      /// Setting the top position of the style to the top position of the trigger plus the height of the
      /// trigger plus the offset times 2.
      style.top = triggerPositionAndSize.top +
          triggerPositionAndSize.height +
          (offset * 2);
    }

    /// This is checking if the menu position is outside of the window.
    /// If true this means that the menu will be cut after opens.
    /// To fix this the method calc a new position considering to point in the other direction.
    final styleOverflow = _maybeCheckAndFixOverflow(style);
    return styleOverflow;
  }

  /// Build a menu items to a ListTile.
  /// Returns a List<ListTile>.
  List<ListTile> _buildMenuFloatItems() {
    List<ListTile> items = widget.items.map((e) {
      final onClick = e.onClick;
      return ListTile(
        title: MenuFloatItem<T>(option: e),
        onTap: () {
          setState(() {
            hasMenuFocus = false;
          });
          _hideMenu(asyncClose: false);
          if (onClick != null) {
            onClick(e.value);
          }
        },
      );
    }).toList();
    return items;
  }

  /// Insert the overlay element with the menu inside itself and set the menu position.
  /// Returns Future<void>.
  Future<void> _showMenu() async {
    /// This is checking if the menu is already on the window.
    final hasMenuOnWindow = floatPosition != null;
    if (hasMenuOnWindow) {
      return;
    }

    /// Getting the overlay state of the context.
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
                  _hideMenu();
                }
              },
              onEnter: (PointerEnterEvent e) {
                if (mounted) {
                  setState(() {
                    hasMenuFocus = true;
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.only(
                  top: widget.offsetTop ?? 0,
                  bottom: widget.offsetBottom ?? 0,
                  left: widget.offsetLeft ?? 0,
                  right: widget.offsetRight ?? 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Opacity(
                      opacity: floatPosition != null ? 1 : 0,
                      child: Container(
                          // width: floatPosition != null ? null : 0,
                          // height: floatPosition != null ? null : 0,
                          key: menuKey,
                          constraints: const BoxConstraints(
                            maxWidth: menuFloatMaxWidth,
                            maxHeight: menuFloatMaxHeight,
                          ),
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
                            children: _buildMenuFloatItems(),
                          ))),
                    )
                  ],
                ),
              ),
            ),
          );
        });
    overlayState?.insert(entry!);

    /// Waiting for the menu to be rendered and then setting the position.
    await _setFloatPosition(overlayState);
  }

  /// Set the menu position. If the menu doesn't will be rendered yet await and call itself.
  /// Returns Future<void>.
  Future<void> _setFloatPosition(OverlayState? overlayState) async {
    /// Checking if the widget is mounted or not.
    if (mounted) {
      /// Checking if the menu is open or not.
      final hasMenuOnWindow = menuKey.currentContext != null;
      if (!hasMenuOnWindow) {
        /// Delaying the execution of the code by 100 milliseconds.
        await Future.delayed(const Duration(milliseconds: 100));

        /// Setting the position of the overlay.
        await _setFloatPosition(overlayState);
        return;
      }
      overlayState?.setState(() {
        floatPosition = _getIdealPosition();
      });
    }
  }

  /// Remove the overlay element with menu items.
  /// The asyncClose specifies if depends on another async function. If true wait to finish.
  void _hideMenu({bool asyncClose = true}) async {
    /// Checking if the asyncClose is true.
    if (asyncClose) {
      await Future.delayed(const Duration(milliseconds: 300));
    }

    /// Checking if the entry is not null and mounted.
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
              _hideMenu();
            }),
        onTap: () {
          _showMenu();
        },
      ),
    );
  }
}
