import 'package:umudbro/models/models.dart';

abstract class ServersEvent {
  const ServersEvent();
}

class ServerAdded extends ServersEvent {
  final Server server;

  const ServerAdded(this.server) : super();
}

class ServerDeleted extends ServersEvent {
  final Server server;

  ServerDeleted(this.server);
}

class ServerUpdated extends ServersEvent {
  final Server server;

  ServerUpdated(this.server);
}

class ServersLoaded extends ServersEvent {}

class ServerConnected extends ServersEvent {
  final Server server;

  ServerConnected(this.server);
}