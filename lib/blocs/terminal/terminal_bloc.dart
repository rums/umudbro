import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';

import 'terminal.dart';

class TerminalBloc extends Bloc<TerminalEvent, TerminalState> {
  TerminalBloc(TerminalState initialState) : super(initialState);

  Socket socket;

  void dataHandler(data) {
    String out = new String.fromCharCodes(data).trim();
    print(out);
    this.add(TerminalDataReceived(out));
  }

  void errorHandler(error, StackTrace trace){
    print(error);
  }

  void doneHandler(){
    socket.destroy();
  }

  Future<bool> _startSocket(server, port) async {
      try {
        await Socket.connect(server, port).then((Socket sock) {
          socket = sock;
          socket.listen(dataHandler,
              onError: errorHandler,
              onDone: doneHandler,
              cancelOnError: false);
        }).catchError((e, StackTrace trace) {
          print("Unable to connect: $e");
        });
        //Connect standard in to the socket
        stdin.listen((data) => socket.write(new String.fromCharCodes(data).trim() + '\n'));
        return true;
      }
      catch (e) {
        return false;
      }
  }

  @override
  Stream<TerminalState> mapEventToState(
    TerminalEvent event,
  ) async* {
    final currentState = state;
    if (event is TerminalInitialized) {
      bool success = await _startSocket(event.address, event.port);
      if (success) {
        final List<String> buffer = [
          "Connected to ${event.address}:${event.port}"
        ];
        yield TerminalBuffer(buffer);
      }
      else {
        final List<String> buffer = [
          "Could not connect to ${event.address}:${event.port}"
        ];
        yield TerminalBuffer(buffer);
      }
    }
    else if (event is TerminalDataReceived) {
        final List<String> buffer = currentState.buffer..add(event.data);
        yield TerminalBuffer(buffer);
    }
  }
}
