abstract class ServersEvent {
  const ServersEvent();
}

class ServerAddedEvent extends ServersEvent {
  final String address;
  final int port;

  const ServerAddedEvent(this.address, this.port) : super();
}

class ServersLoaded extends ServersEvent {}