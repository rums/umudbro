import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/widgets/terminal_command_bar.dart';
import 'package:umudbro/widgets/widgets.dart';

class Terminal extends StatefulWidget {
  Terminal({Key key, this.buffer}) : super(key: key);
  final List<String> buffer;

  @override
  _TerminalState createState() => _TerminalState();
}

class _TerminalState extends State<Terminal> {
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
                      children: state is TerminalConnectSuccess
                          ? state.buffer
                              .map((bufferItem) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      TerminalBufferItem(
                                        bufferItem: bufferItem,
                                      ),
                                      Divider(),
                                    ],
                                  ))
                              .toList()
                          : []),
                ),
              ),
            ),
            TerminalCommandBar(),
          ],
        );
      },
    );
  }
}
