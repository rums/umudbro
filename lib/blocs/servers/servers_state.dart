import 'package:umudbro/models/models.dart';

abstract class ServersState {
  const ServersState();
}

class ServerInitial extends ServersState {
  ServerInitial() : super();
}

class ServerLoadListInProgress extends ServersState {
  ServerLoadListInProgress() : super();
}

class ServerLoadListSuccess extends ServersState {
  final List<Server> servers;
  ServerLoadListSuccess(this.servers) : super();
}

class ServerLoadSuccess extends ServersState {
  final Server server;

  ServerLoadSuccess(this.server) : super();
}