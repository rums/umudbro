import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:umudbro/models/models.dart';
import 'dart:convert';

import '../blocs.dart';
import 'terminal.dart';

class TerminalBloc extends Bloc<TerminalEvent, TerminalState> {
  final ServersBloc serversBloc;
  StreamSubscription serversSubscription;
  Map<int, Socket> sockets;

  TerminalBloc(TerminalState initialState, this.serversBloc)
      : super(initialState) {
    sockets = new Map<int, Socket>();
    serversSubscription = serversBloc.listen((state) {
      if (state is ServerConnectionRequested) {
        serversBloc.umudbroRepository
            .server(state.server)
            .then((server) => add(TerminalInitialized(server: server)));
      } else if (state is ServerDisconnectionRequested) {
        Socket socket = sockets[state.server.id];
        killSocket(socket, state.server);
      }
    });
  }

  void dataHandler(socket, data) {
    final String response = new String.fromCharCodes(data).trim();
    // TODO: parse response using GMCP or whatever
    // final String processedData = processResponse(response);
    this.add(TerminalDataReceived(response));
  }

  void errorHandler(socket, error, StackTrace trace) {
    add(TerminalDataReceived("An error has been encountered."));
  }

  void killSocket(socket, server) {
    add(TerminalDataReceived("The connection has been closed."));
    sockets.remove(server.id);
    socket.destroy();
  }

  Future<bool> _startSocket(server, label) async {
    try {
      Socket socket = sockets[server.id];
      if (socket == null) {
        await Socket.connect(server.address, server.port).then((Socket sock) {
          socket = sock;
          sockets[server.id] = socket;
          socket.listen((data) => dataHandler(socket, data),
              onError: (error, trace) => errorHandler(socket, error, trace),
              onDone: () => killSocket(socket, server),
              cancelOnError: false);
          add(TerminalDataReceived("Connected to $label!"));
        }).catchError((e, StackTrace trace) {
          print("Unable to connect: $e");
          add(TerminalDataReceived("Could not connect to $label!"));
        });
        //Connect standard in to the socket
        stdin.listen((data) =>
            socket.write(new String.fromCharCodes(data).trim() + '\n'));
      } else {
        add(TerminalDataReceived("Already connected to $label!"));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  String processResponse(String response) {}

  @override
  Stream<TerminalState> mapEventToState(
    TerminalEvent event,
  ) async* {
    final currentState = state;
    if (event is TerminalInitialized) {
      String label =
          event.server.name ?? "${event.server.address}:${event.server.port}";
      _startSocket(event.server, label);
      List<String> previousBuffer = List<String>.from(
          event.server.buffer != null ? json.decode(event.server.buffer) : []);
      yield TerminalActive(
          server: event.server,
          buffer: previousBuffer + ["Connecting to $label..."]);
    } else if (event is TerminalDataReceived) {
      final List<String> buffer = currentState.buffer..add(event.data);
      Server server =
          Server.from(currentState.server, buffer: json.encode(buffer));
      serversBloc.add(ServerUpdated(server));
      yield TerminalActive(server: state.server, buffer: buffer);
    } else if (event is TerminalDataSent) {
      final List<String> buffer = currentState.buffer;
      sendCommand(currentState.server, event.data);
      yield TerminalActive(server: state.server, buffer: buffer);
    }
  }

  void sendCommand(Server server, String data) {
    sockets[server.id].write(data);
  }

  @override
  Future<void> close() {
    serversSubscription.cancel();
    return super.close();
  }
}
