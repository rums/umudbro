import 'package:umudbro/models/models.dart';

abstract class ServersState {
  final List<Server> servers;
  const ServersState(this.servers);
}

class InitialServersState extends ServersState {
  InitialServersState(List<Server> servers) : super(servers);
}

class ServersLoadInProgress extends ServersState {
  ServersLoadInProgress(List<Server> servers) : super(servers);
}

class ServersLoadSuccess extends ServersState {
  ServersLoadSuccess(servers) : super(servers);
}

class ServerConnectionRequested extends ServersState {
  final Server server;

  ServerConnectionRequested(this.server, servers) : super(servers);
}

class ServerDisconnectionRequested extends ServersState {
  final Server server;

  ServerDisconnectionRequested(this.server, servers) : super(servers);
}