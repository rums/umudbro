import 'package:flutter/material.dart';
import 'package:umudbro/models/command.dart';

@immutable
abstract class CommandsEvent {}

class CommandSaved extends CommandsEvent {
  final Command command;

  CommandSaved(this.command);
}