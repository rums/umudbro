import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/widgets/widgets.dart';

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
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Wrap(
                      direction: Axis.horizontal,
                      children: state.buffer
                          .map((bufferItem) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TerminalBufferItem(
                                    bufferItem: bufferItem,
                                  ),
                                  Divider(),
                                ],
                              ))
                          .toList()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  PopupMenuButton(itemBuilder: (context) =>
                  <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "saveCommand",
                      child: Row(children: <Widget>[
                        Icon(Icons.add),
                        Text("Save command"),
                      ],),
                    )
                  ]),
                  Expanded(
                    child: TextField(
                      controller: commandTextController,
                      decoration: const InputDecoration(
                        hintText: "Enter a command",
                      ),
                    ),
                  ),
                  FlatButton(
                      onPressed: () => BlocProvider.of<TerminalBloc>(context)
                          .add(TerminalDataSent(commandTextController.text)),
                      child: Text("Send"))
                ],
              ),
            )
          ],
        );
      },
    );
  }
}