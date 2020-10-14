import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:umudbro/blocs/blocs.dart';

class Terminal extends StatefulWidget {
  Terminal({Key key, this.buffer}) : super(key: key);
  final List<String> buffer;

  @override
  _TerminalState createState() => _TerminalState();
}

class _TerminalState extends State<Terminal> {
  final commandTextController = TextEditingController();

  @override
  void dispose() {
    commandTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TerminalBloc, TerminalState>(
      builder: (context, state) {
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Wrap(
                    direction: Axis.horizontal,
                      children: state.buffer
                          .map((data) => Column(
                                children: <Widget>[
                                  Text(data),
                                  Divider(),
                                ],
                              ))
                          .toList()),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commandTextController,
                      decoration: const InputDecoration(
                        hintText: "Enter a command",
                      ),
                    ),
                  ),
                  FlatButton(onPressed: () => BlocProvider.of<TerminalBloc>(context).add(TerminalDataSent(commandTextController.text)),
                      child: Text("Send"))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class TerminalFlowDelegate extends FlowDelegate {
  final Animation<double> menuAnimation;

  TerminalFlowDelegate({this.menuAnimation}) : super(repaint: menuAnimation);

  @override
  bool shouldRepaint(TerminalFlowDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i).width * i;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          dx * menuAnimation.value,
          0,
          0,
        ),
      );
    }
  }
}
