import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:umudbro/models/models.dart';
import 'package:umudbro/repositories/umudbro_repository.dart';

import 'servers.dart';

class ServersBloc extends Bloc<ServersEvent, ServersState> {
  ServersBloc({@required this.umudbroRepository}) : super(InitialServersState(new List<Server>()));

  final UmudbroRepository umudbroRepository;

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
      _saveServer(event.server);
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

  Future _saveServer(Server server) {
    return umudbroRepository.addServer(server);
  }

  Future _deleteServer(Server server) {
    return umudbroRepository.deleteServer(server);
  }
}
