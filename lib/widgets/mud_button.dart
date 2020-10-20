import 'package:flutter/material.dart';

class SlotButton extends StatelessWidget {
  final int row;
  final int column;
  final Color background;
  final Color foreground;
  final bool disabled;
  final Widget child;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;

  const SlotButton({Key key,
    this.child,
    this.row,
    this.column,
    this.background = Colors.white,
    this.foreground = Colors.black,
    this.onPressed,
    this.onLongPress,
    this.disabled = false})
      : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: this.onLongPress ?? () => null,
      child: Container(
        child: RaisedButton(
            textColor: foreground,
            color: background.withOpacity(1),
            onPressed: () =>
            disabled
                ? null
                : onPressed(),
            child: child),
      ),
    );
  }
}
