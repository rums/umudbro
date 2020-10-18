import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/blocs/mud_commands/mud_commands_bloc.dart';
import 'package:umudbro/widgets/widgets.dart';

class TerminalStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MudCommandsBloc>(context).add(MudCommandsPageLoad());
    return Expanded(
      child: Stack(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: double.infinity,
              child: Terminal()),
        ],
      ),
    );
  }
}
