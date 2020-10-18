import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:umudbro/models/models.dart';

import '../blocs.dart';
import 'terminal.dart';

class TerminalBloc extends Bloc<TerminalEvent, TerminalState> {
  final ServersBloc serversBloc;
  StreamSubscription serversSubscription;
  Map<int, Socket> sockets;

  TerminalBloc(this.serversBloc) : super(TerminalInitial()) {
    sockets = new Map<int, Socket>();
    serversSubscription = serversBloc.listen((state) {
      if (state is ServerLoadSuccess) {
        serversBloc.umudbroRepository
            .server(state.server)
            .then((server) => add(TerminalStarted(server: server)));
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
    add(TerminalInfoReceived("An error has been encountered."));
  }

  void killSocket(socket, server) {
    add(TerminalInfoReceived("The connection has been closed."));
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
          add(TerminalInfoReceived("Connected to $label!"));
        }).catchError((e, StackTrace trace) {
          print("Unable to connect: $e");
          add(TerminalInfoReceived("Could not connect to $label!"));
        });
        //Connect standard in to the socket
        stdin.listen((data) =>
            socket.write(new String.fromCharCodes(data).trim() + '\n'));
      } else {
        add(TerminalInfoReceived("Already connected to $label!"));
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
    if (event is TerminalStarted) {
      String label =
          event.server.name ?? "${event.server.address}:${event.server.port}";
      _startSocket(event.server, label);
      yield TerminalConnectSuccess(
          server: event.server,
          buffer: event.server.buffer == null ? null : event.server.buffer +
              [new InfoBufferItem(info: "Connecting to $label...")]);
    } else if (event is TerminalDataReceived || event is TerminalInfoReceived) {
      BufferItem item = _mapEventToBufferItem(event);
      final List<BufferItem> buffer = currentState.buffer..add(item);
      Server server =
          Server.from(currentState.server, buffer: buffer);
      serversBloc.add(ServerUpdated(server));
      yield TerminalConnectSuccess(server: state.server, buffer: buffer);
    } else if (event is TerminalDataSent) {
      BufferItem item = _mapEventToBufferItem(event);
      final List<BufferItem> buffer = currentState.buffer..add(item);
      sendCommand(currentState.server, event.data);
      yield TerminalConnectSuccess(server: state.server, buffer: buffer);
    }
  }

  BufferItem _mapEventToBufferItem(TerminalEvent event) {
    BufferItem item;
    if (event is TerminalInfoReceived) {
      item = new InfoBufferItem(info: event.data);
    } else if (event is TerminalDataReceived) {
      item = new ReceivedBufferItem(dataReceived: event.data);
    } else if (event is TerminalDataSent) {
      item = new SentBufferItem(dataSent: event.data);
    } else {
      item = new InfoBufferItem(info: "");
    }
    return item;
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
