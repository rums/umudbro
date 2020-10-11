import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:umudbro/models/models.dart';
import 'package:umudbro/repositories/umudbro_repository.dart';

import 'servers.dart';

class ServersBloc extends Bloc<ServersEvent, ServersState> {
  ServersBloc({@required this.umudbroRepository}) : super(InitialServersState());

  final UmudbroRepository umudbroRepository;

  @override
  Stream<ServersState> mapEventToState(ServersEvent event) async* {
    if (event is ServersLoaded) {
      yield* _mapServersLoadedToState();
    }
    else if (event is ServerAddedEvent) {
      Server server = new Server(address: event.address, port: event.port);
      _saveServer(server);
      yield ServerAddedState(server);
    }
  }

  Future _saveServer(Server server) {
    return umudbroRepository.addServer(server);
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
}
