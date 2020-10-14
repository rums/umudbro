import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:umudbro/models/models.dart';
import 'package:umudbro/repositories/umudbro_repository.dart';

import 'servers.dart';

class ServersBloc extends Bloc<ServersEvent, ServersState> {
  ServersBloc({@required this.umudbroRepository}) : super(InitialServersState(new List<Server>()));

  final UmudbroRepository umudbroRepository;

  Future<Server> getDefaultServer() async {
    return umudbroRepository.server(new Server(doConnect: 1));
  }
  
  @override
  Stream<ServersState> mapEventToState(ServersEvent event) async* {
    if (event is ServersLoaded) {
      yield* _mapServersLoadedToState();
    }
    else if (event is ServerAdded) {
      yield* _mapServerAddedToState(event);
    }
    else if (event is ServerDeleted) {
      yield* _mapServerDeletedToState(event);
    }
    else if (event is ServerUpdated) {
      yield* _mapServerUpdatedToState(event);
    }
    else if (event is ServerConnected) {
      yield* _mapServerConnectedToState(event);
    }
    else if (event is ServerDisconnected) {
      yield* _mapServerDisconnectedToState(event);
    }
  }

  Stream<ServersState> _mapServersLoadedToState() async* {
    try {
      final servers = await this.umudbroRepository.servers().first;
      yield ServersLoadSuccess(
        servers
      );
    }
    catch (e) {
    }
  }

  Stream<ServersState> _mapServerAddedToState(ServerAdded event) async* {
    if (state is ServersLoadSuccess) {
      final List<Server> updatedServers =
          List.from((state as ServersLoadSuccess).servers)..add(event.server);
      await _addServer(event.server);
      yield ServersLoadSuccess(updatedServers);
    }
  }

  Stream<ServersState> _mapServerDeletedToState(ServerDeleted event) async* {
    if (state is ServersLoadSuccess) {
      final List<Server> updatedServers =
      (state as ServersLoadSuccess).servers
        .where((server) => server.id != event.server.id).toList();
      _deleteServer(event.server);
      yield ServersLoadSuccess(updatedServers);
    }
  }

  Stream<ServersState> _mapServerUpdatedToState(ServerUpdated event) async* {
    if (state is ServersLoadSuccess) {
      final List<Server> updatedServers =
      (state as ServersLoadSuccess).servers.map((server) {
        return server.id == event.server.id ? event.server : server;
      }).toList();
      await _updateServer(event.server);
      yield ServersLoadSuccess(updatedServers);
    }
  }

  Stream<ServersState> _mapServerConnectedToState(ServerConnected event) async* {
    if (state is ServersLoadSuccess) {
      final List<Server> updatedServers =
      (state as ServersLoadSuccess).servers.map((server) {
        return server.id == event.server.id ? event.server : server;
      }).toList();
      await _setDefaultServer(event.server);
      yield ServerConnectionRequested(event.server, updatedServers);
    }
  }

  Stream<ServersState> _mapServerDisconnectedToState(ServerDisconnected event) async* {
    if (state is ServersLoadSuccess) {
      final List<Server> updatedServers =
      (state as ServersLoadSuccess).servers.map((server) {
        return server.id == event.server.id ? event.server : server;
      }).toList();
      yield ServerDisconnectionRequested(event.server, updatedServers);
    }
  }

  Future _addServer(Server server) {
    return umudbroRepository.addServer(server);
  }

  Future _updateServer(Server server) {
    return umudbroRepository.updateServer(server);
  }

  Future _setDefaultServer(Server server) {
    return umudbroRepository.setDefaultServer(server);
  }

  Future _deleteServer(Server server) {
    return umudbroRepository.deleteServer(server);
  }
}
