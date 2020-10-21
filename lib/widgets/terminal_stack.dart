import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/blocs/mud_commands/mud_commands_bloc.dart';
import 'package:umudbro/widgets/widgets.dart';

class TerminalStack extends StatelessWidget {
  Widget buildOverlay(state) {
    if (state is TerminalConnectSuccess && state.showOverlay) {
      switch (state.activeOverlay) {
        case TerminalOverlay.Buttons:
          return MudButtons();
          break;
        case TerminalOverlay.Settings:
          return Container();
        default:
          return Container();
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MudCommandsBloc>(context).add(MudCommandsPageLoad());
    return BlocBuilder<TerminalBloc, TerminalState>(
      builder: (context, state) => Expanded(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
                child: Terminal()),
            Positioned.fill(
              bottom: 50,
              child: buildOverlay(state),
            ),
          ],
        ),
      ),
    );
  }
}
