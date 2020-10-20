import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:umudbro/models/mud_command_page.dart';
import 'package:umudbro/repositories/umudbro_repository.dart';

import 'mud_commands.dart';

class MudCommandsBloc extends Bloc<MudCommandsEvent, MudCommandsState> {
  MudCommandsBloc(MudCommandsState initialState,
      {@required this.umudbroRepository})
      : super(initialState);

  final UmudbroRepository umudbroRepository;

  @override
  Stream<MudCommandsState> mapEventToState(MudCommandsEvent event) async* {
    if (event is MudCommandsPageLoad) {
      yield* _mapMudCommandsPageLoadToState(event);
    } else if (event is MudCommandSlotSaved) {
      yield* _mapMudCommandSavedToState(event);
    } else if (event is MudCommandsPageSwiped) {
      yield* _mapMudCommandsPageSwipedToState(event);
    } else if (event is MudCommandsToggleEditPage) {
      yield* _mapMudCommandsEditStartedToState(event);
    }
  }

  Stream<MudCommandsState> _mapMudCommandsPageLoadToState(
      MudCommandsPageLoad event) async* {
    List<MudCommandPage> pages =
        await umudbroRepository.mudCommandPages().first;
    if (pages.length == 0) {
      umudbroRepository.addMudCommandPage(MudCommandPage(columnCount: 3));
      pages = await umudbroRepository.mudCommandPages().first;
    }
    yield MudCommandsLoadPageSuccess(pages, 0);
  }

  Stream<MudCommandsState> _mapMudCommandSavedToState(
      MudCommandSlotSaved event) async* {
    if (state is MudCommandsLoadPageSuccess) {
      final currentState = state as MudCommandsLoadPageSuccess;
      await _saveCommandSlot(
          event.slot, currentState.mudCommandPages[currentState.currentPage]);
      yield MudCommandsLoadPageSuccess(
          currentState.mudCommandPages, currentState.currentPage);
    }
  }

  Stream<MudCommandsState> _mapMudCommandsPageSwipedToState(
      MudCommandsPageSwiped event) async* {
    final newIndex = (event.currentPage + event.direction) % event.pages.length;
    yield MudCommandsLoadPageSuccess(event.pages, newIndex);
  }

  Stream<MudCommandsState> _mapMudCommandsEditStartedToState(
      MudCommandsToggleEditPage event) async* {
    if (state is MudCommandsLoadPageSuccess) {
      final currentState = state as MudCommandsLoadPageSuccess;
      yield MudCommandsLoadPageSuccess(event.pages, event.currentPage,
          editing: !currentState.editing);
    }
  }

  Future _saveCommandSlot(MudCommandSlot slot, MudCommandPage page) {
    final oldSlots = page.mudCommandSlots ?? [];
    final newSlots = oldSlots
      ..removeWhere((element) =>
          element.gridRow == slot.gridRow &&
          element.gridColumn == slot.gridColumn)
      ..add(slot);
    final newPage = MudCommandPage(
        columnCount: page.columnCount, id: page.id, mudCommandSlots: newSlots);
    return umudbroRepository.updateMudCommandPage(newPage);
  }
}
