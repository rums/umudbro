import 'package:flutter/material.dart';
import 'package:umudbro/models/mud_command.dart';
import 'package:umudbro/models/mud_command_page.dart';

@immutable
abstract class MudCommandsEvent {}

class MudCommandsPageLoad extends MudCommandsEvent {
}

class MudCommandPressed extends MudCommandsEvent {
  final MudCommand command;

  MudCommandPressed(this.command);
}

class MudCommandSlotSaved extends MudCommandsEvent {
  final MudCommandSlot slot;

  MudCommandSlotSaved(this.slot);
}

class MudCommandsPageSwiped extends MudCommandsEvent {
  final List<MudCommandPage> pages;
  final int currentPage;
  final int direction;

  MudCommandsPageSwiped(this.pages, this.currentPage, this.direction);
}

class MudCommandsToggleEditPage extends MudCommandsEvent {
  final List<MudCommandPage> pages;
  final int currentPage;

  MudCommandsToggleEditPage(this.pages, this.currentPage);
}