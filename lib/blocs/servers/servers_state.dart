import 'package:umudbro/models/models.dart';

abstract class ServersState {
  final List<Server> servers;
  const ServersState(this.servers);
}

class InitialServersState extends ServersState {
  InitialServersState(List<Server> servers) : super(servers);
}

class ServerAddedState extends ServersState {
  final Server server;

  const ServerAddedState(this.server, List<Server> servers) : super(servers);
}

class ServerDeletedState extends ServersState {
  final Server server;

  ServerDeletedState(this.server, List<Server> servers) : super(servers);
}

class ServersLoadInProgress extends ServersState {
  ServersLoadInProgress(List<Server> servers) : super(servers);
}

class ServersLoadSuccess extends ServersState {
  ServersLoadSuccess(servers) : super(servers);
}