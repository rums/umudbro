import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';

class TerminalCommandBar extends StatefulWidget {
  final bool focusCommandBar;

  const TerminalCommandBar({Key key, this.focusCommandBar = false}) : super(key: key);

  @override
  _TerminalCommandBarState createState() => _TerminalCommandBarState();
}

class _TerminalCommandBarState extends State<TerminalCommandBar> {
  final commandTextController = TextEditingController();

  _TerminalCommandBarState();

  @override
  void dispose() {
    commandTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            PopupMenuButton(
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: "saveCommand",
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.add),
                            Text("Save command"),
                          ],
                        ),
                      )
                    ]),
            Expanded(
              child: TextField(
                onEditingComplete: () => BlocProvider.of<TerminalBloc>(context).add(TerminalToggleCommandBar(forceCommandBar: false, focusCommandBar: false)),
                autofocus: widget.focusCommandBar,
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
      ),
    );
  }
}
