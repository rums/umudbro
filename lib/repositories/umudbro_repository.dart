import 'dart:async';

import 'package:umudbro/models/models.dart';

abstract class UmudbroRepository {
  Future<void> addServer(Server server);

  Future<void> deleteServer(Server server);

  Stream<List<Server>> servers();

  Future<Server> server(Server server);

  Future<void> updateServer(Server server);

  Future<void> setDefaultServer(Server server);

  Future<void> addCommand(Command command);

  Future<void> deleteCommand(Command command);

  Future<void> updateCommand(Command command);

  Stream<List<Command>> commands();
}