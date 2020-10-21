import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/mud_commands/mud_commands.dart';
import 'package:umudbro/blocs/terminal/terminal.dart';
import 'package:umudbro/models/models.dart';
import 'package:umudbro/widgets/add_mud_command.dart';

import 'mud_button.dart';

class MudButtons extends StatelessWidget {
  void showUpdateButtonDialog(context, MudCommandSlot slot, bool isUpdate) {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          titlePadding: EdgeInsets.symmetric(
              horizontal: 16.0),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0),
          children: [
            Padding(
                padding:
                const EdgeInsets.symmetric(
                    horizontal: 16.0),
                child: AddMudCommand(
                  slot: slot,
                  isUpdate: isUpdate,
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MudCommandsBloc, MudCommandsState>(
        builder: (context, state) {
      if (state is MudCommandsLoadPageSuccess) {
        final currentPage = state.mudCommandPages[state.currentPage];
        return GestureDetector(
            onHorizontalDragEnd: (details) {
              int direction;
              if (details.primaryVelocity < 0)
                direction = 1;
              else
                direction = -1;
              BlocProvider.of<MudCommandsBloc>(context).add(MudCommandsPageSwiped(
                  state.mudCommandPages, state.currentPage, direction));
            },
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: currentPage.columnCount,
                    ),
                    itemBuilder: (context, index) {
                      final int column = index % currentPage.columnCount;
                      final int row = index ~/ currentPage.columnCount;
                      final MudCommandSlot slot =
                          currentPage.mudCommandSlots?.firstWhere(
                        (s) => s.gridRow == row && s.gridColumn == column,
                        orElse: () => null,
                      );
                      if (slot != null) {
                        return SlotButton(
                          child: Text(slot.mudCommand.name),
                          row: slot.gridRow,
                          column: slot.gridColumn,
                          foreground: slot.foregroundColor,
                          background: slot.backgroundColor,
                          onPressed: () => BlocProvider.of<TerminalBloc>(context).add(TerminalDataSent(slot.mudCommand.commandText)),
                          onLongPress: () => showUpdateButtonDialog(context, slot, true),
                        );
                      }
                      return GestureDetector(
                          onLongPress: () {
                            BlocProvider.of<MudCommandsBloc>(context).add(
                                MudCommandsToggleEditPage(
                                    state.mudCommandPages, state.currentPage));
                          },
                          child: state.editing
                              ? SlotButton(
                                  row: row,
                                  column: column,
                                  child: Icon(Icons.add),
                                  onPressed: () => showUpdateButtonDialog(context, MudCommandSlot(gridRow: row, gridColumn: column), false),
                                )
                              : Container(color: Colors.white.withOpacity(0)));
                    },
                  ),
                )
              ],
            ),
          );
      }
      return GridView.count(crossAxisCount: 1);
    });
  }
}
