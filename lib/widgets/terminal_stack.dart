import 'package:flutter/material.dart';
import 'package:umudbro/widgets/widgets.dart';

class TerminalStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: double.infinity,
              child: Terminal()),
          Container(
            width: double.infinity,
            height: 500,
            child: MudButtons(),
          )
        ],
      ),
    );
  }
}
