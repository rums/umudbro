import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:umudbro/blocs/blocs.dart';

class Terminal extends StatelessWidget {
  Terminal({Key key, this.buffer}) : super(key: key);
  final List<String> buffer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TerminalBloc, TerminalState>(
      builder: (context, state) {
        return Markdown(shrinkWrap: true, data: state.buffer.join("\n\n"));
      },
    );
  }
}
