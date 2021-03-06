import 'package:flutter/material.dart';
import 'package:umudbro/models/mud_command_page.dart';

@immutable
abstract class MudCommandsState {}

class MudCommandsInitial extends MudCommandsState {}

class MudCommandsLoadPageInProgress extends MudCommandsState {}

class MudCommandsLoadPageSuccess extends MudCommandsState {
  final List<MudCommandPage> mudCommandPages;
  final int currentPage;
  final bool editing;

  MudCommandsLoadPageSuccess(this.mudCommandPages, this.currentPage, {this.editing = false});
}