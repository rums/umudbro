import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:umudbro/models/mud_command.dart';
import 'package:umudbro/models/mud_command_page.dart';
import 'package:umudbro/repositories/umudbro_repository.dart';

import 'mud_commands.dart';

class MudCommandsBloc extends Bloc<MudCommandsEvent, MudCommandsState> {
  MudCommandsBloc(MudCommandsState initialState, {@required this.umudbroRepository}) : super(initialState);

  final UmudbroRepository umudbroRepository;

  @override
  Stream<MudCommandsState> mapEventToState(MudCommandsEvent event) async* {
    if (event is MudCommandsPageLoad) {
      yield* _mapMudCommandsPageLoadToState(event);
    }
    else if (event is MudCommandSaved) {
      yield* _mapMudCommandSavedToState(event);
    }
  }

  Stream<MudCommandsState> _mapMudCommandsPageLoadToState(MudCommandsPageLoad event) async* {
    final MudCommandPage page = await umudbroRepository.mudCommandPage(MudCommandPage());
    yield MudCommandsLoadPageSuccess([page]);
  }

  Stream<MudCommandsState> _mapMudCommandSavedToState(MudCommandSaved event) async* {
    await _saveCommand(event.command);
    final MudCommandPage page = await umudbroRepository.mudCommandPage(MudCommandPage());
    yield MudCommandsLoadPageSuccess([page]);
  }

  Future _saveCommand(MudCommand command) {
    if (command.id != null) {
      return umudbroRepository.updateMudCommand(command);
    } else {
      return umudbroRepository.addMudCommand(command);
    }
  }
}
