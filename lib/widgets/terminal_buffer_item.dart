import 'package:flutter/material.dart';
import 'package:umudbro/models/models.dart';

class TerminalBufferItem extends StatelessWidget {
  final BufferItem bufferItem;

  const TerminalBufferItem({Key key, this.bufferItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;
    if (bufferItem is InfoBufferItem) {
      textStyle = TextStyle(color: Colors.grey);
    } else if (bufferItem is ReceivedBufferItem) {
      textStyle = TextStyle(color: Colors.black);
    }
    else if (bufferItem is SentBufferItem) {
      textStyle = TextStyle(color: Colors.blue);
    }
    return Text(
      bufferItem.displayText,
      style: textStyle,
    );
  }
}
