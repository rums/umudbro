import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/terminal/terminal.dart';

import '../widgets/terminal.dart';

class HomeScreen extends StatefulWidget {
  final String server;
  final int port;

  HomeScreen({Key key, this.server, this.port}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  Socket socket;
  TerminalBloc _terminalBloc;

  void dataHandler(data) {
    String out = new String.fromCharCodes(data).trim();
    print(out);
    _terminalBloc.add(TerminalDataReceived(out));
  }

  void errorHandler(error, StackTrace trace){
    print(error);
  }

  void doneHandler(){
    socket.destroy();
  }

  void _startSocket(server, port) {
    setState(() {
      try {
      Socket.connect(server, port).then((Socket sock) {
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
    }
    catch (e) {
    }});
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    _terminalBloc = BlocProvider.of<TerminalBloc>(context);
    this._startSocket(widget.server, widget.port);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TerminalBloc, TerminalState>(
      builder: (context, state) {
        return Terminal(buffer: state.buffer);
        },
    );
  }
}