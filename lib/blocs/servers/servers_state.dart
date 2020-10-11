import 'package:umudbro/models/models.dart';

abstract class ServersState {
  const ServersState();
}

class InitialServersState extends ServersState {
  InitialServersState() : super();
}

class ServerAddedState extends ServersState {
  final Server server;

  const ServerAddedState(this.server) : super();
}

class ServersLoadInProgress extends ServersState {}

class ServersLoadSuccess extends ServersState {
  final List<Server> servers;

  ServersLoadSuccess(this.servers) : super();
}