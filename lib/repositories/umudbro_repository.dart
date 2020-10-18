import 'dart:async';

import 'package:umudbro/models/models.dart';

abstract class UmudbroRepository {
  Future<void> addServer(Server server);

  Future<void> deleteServer(Server server);

  Stream<List<Server>> servers();

  Future<Server> server(Server server);

  Future<void> updateServer(Server server);

  Future<void> setDefaultServer(Server server);

  Future<void> addMudCommand(MudCommand command);

  Future<void> deleteMudCommand(MudCommand command);

  Future<void> updateMudCommand(MudCommand command);

  Stream<List<MudCommand>> mudCommands();

  Future<MudCommand> mudCommand(MudCommand mudCommand);

  Future<void> addMudCommandPage(MudCommandPage command);

  Future<void> deleteMudCommandPage(MudCommandPage command);

  Future<void> updateMudCommandPage(MudCommandPage command);

  Stream<List<MudCommandPage>> mudCommandPages();

  Future<MudCommandPage> mudCommandPage(MudCommandPage mudCommand);
}