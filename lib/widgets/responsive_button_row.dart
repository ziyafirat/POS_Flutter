import 'package:flutter/material.dart';

/// A responsive row widget that automatically adjusts button widths
/// If there is 1 button → it takes full width
/// If there are 2 buttons → they each take half width
/// If there are 3 buttons → they each take one-third width
/// If there are 2 buttons with custom flex → one takes 2/3 width, other takes 1/3 width
class ResponsiveButtonRow extends StatelessWidget {
  final List<ResponsiveButton> buttons;
  final double spacing;
  final EdgeInsetsGeometry? padding;

  const ResponsiveButtonRow({
    super.key,
    required this.buttons,
    this.spacing = 10.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget content;

    if (buttons.length == 1) {
      // Single button takes full width
      content = SizedBox(width: double.infinity, child: buttons.first.button);
    } else {
      // Multiple buttons in a row with flex
      final List<Widget> rowChildren = [];

      for (int i = 0; i < buttons.length; i++) {
        final responsiveButton = buttons[i];

        // Add button with flex
        rowChildren.add(
          Expanded(flex: responsiveButton.flex, child: responsiveButton.button),
        );

        // Add spacing between buttons (except after the last button)
        if (i < buttons.length - 1) {
          rowChildren.add(SizedBox(width: spacing));
        }
      }

      content = Row(children: rowChildren);
    }

    // Apply padding if provided
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return content;
  }
}

/// Configuration for a button in a responsive row
class ResponsiveButton {
  final Widget button;
  final int flex; // 1 = normal width, 2 = double width, etc.

  const ResponsiveButton({required this.button, this.flex = 1});

  /// Create a button with normal width (flex: 1)
  static ResponsiveButton normal(Widget button) {
    return ResponsiveButton(button: button, flex: 1);
  }

  /// Create a button with double width (flex: 2)
  static ResponsiveButton wide(Widget button) {
    return ResponsiveButton(button: button, flex: 2);
  }

  /// Create a button with custom flex value
  static ResponsiveButton custom(Widget button, int flex) {
    return ResponsiveButton(button: button, flex: flex);
  }
}
