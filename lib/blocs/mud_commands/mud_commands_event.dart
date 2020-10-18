import 'package:flutter/material.dart';
import 'package:umudbro/models/mud_command.dart';

@immutable
abstract class MudCommandsEvent {}

class MudCommandsPageLoad extends MudCommandsEvent {
}

class MudCommandPressed extends MudCommandsEvent {
  final MudCommand command;

  MudCommandPressed(this.command);
}

class MudCommandSaved extends MudCommandsEvent {
  final MudCommand command;

  MudCommandSaved(this.command);
}