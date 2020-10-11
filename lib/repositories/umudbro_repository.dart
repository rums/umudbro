import 'dart:async';

import 'package:umudbro/models/models.dart';

abstract class UmudbroRepository {
  Future<void> addServer(Server server);

  Future<void> deleteServer(Server server);

  Stream<List<Server>> servers();

  Future<void> updateServer(Server server);
}