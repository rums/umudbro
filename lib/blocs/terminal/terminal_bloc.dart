import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';

import '../blocs.dart';
import 'terminal.dart';

class TerminalBloc extends Bloc<TerminalEvent, TerminalState> {
  final ServersBloc serversBloc;
  StreamSubscription serversSubscription;
  Socket socket;

  TerminalBloc(TerminalState initialState, this.serversBloc)
      : super(initialState) {
    serversSubscription = serversBloc.listen((state) {
      if (state is ServerConnectionRequested) {
        add(TerminalInitialized(server: state.server));
      }
    });
  }

  void dataHandler(data) {
    final String response = new String.fromCharCodes(data).trim();
    final String processedData = processResponse(response);
    this.add(TerminalDataReceived(processedData));
  }

  void errorHandler(error, StackTrace trace) {
    add(TerminalDataReceived("The server encountered an error and had to disconnect."));
  }

  void doneHandler() {
    add(TerminalDataReceived("The server closed the connection."));
    socket.destroy();
  }

  Future<bool> _startSocket(server, label) async {
    if (socket != null) {
      socket.close();
    }
    try {
      await Socket.connect(server.address, server.port).then((Socket sock) {
        socket = sock;
        socket.listen(dataHandler,
            onError: errorHandler, onDone: doneHandler, cancelOnError: false);
        add(TerminalDataReceived("Connected to $label!"));
      }).catchError((e, StackTrace trace) {
        print("Unable to connect: $e");
        add(TerminalDataReceived("Could not connect to $label!"));
      });
      //Connect standard in to the socket
      stdin.listen(
          (data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));
      return true;
    } catch (e) {
      return false;
    }
  }


  String processResponse(String response) {

  }

  @override
  Stream<TerminalState> mapEventToState(
    TerminalEvent event,
  ) async* {
    final currentState = state;
    if (event is TerminalInitialized) {
      String label = event.server.name ?? "${event.server.address}:${event.server.port}";
      _startSocket(event.server, label);
      yield TerminalActive(["Connecting to $label..."]);
    } else if (event is TerminalDataReceived) {
      final List<String> buffer = currentState.buffer..add(event.data);
      yield TerminalActive(buffer);
    }
  }

  @override
  Future<void> close() {
    serversSubscription.cancel();
    return super.close();
  }
}
