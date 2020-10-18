import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/mud_commands/mud_commands.dart';
import 'package:umudbro/models/models.dart';

class MudButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MudCommandsBloc, MudCommandsState>(
        builder: (context, state) {
      if (state is MudCommandsLoadPageSuccess) {
        final currentPage = state.mudCommandPage[0];
        return GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: currentPage.columnCount,
          ),
          itemBuilder: (context, index) {
            final int column = index % currentPage.columnCount;
            final int row = index ~/ currentPage.columnCount;
            final MudCommandSlot slot = currentPage.mudCommandSlots.firstWhere(
                (s) =>
                    s.gridLocation.item1 == row &&
                    s.gridLocation.item2 == column, orElse: () => null,);
            if (slot != null) {
              return RaisedButton(
                child: Text(slot.mudCommand.name),
                onPressed: () => null,
              );
            }
            return Container();
          },
        );
      }
      return GridView.count(crossAxisCount: 1);
    });
  }
}
