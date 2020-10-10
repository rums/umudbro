import 'package:flutter/material.dart';
import 'dart:io';

Socket socket;

class Terminal extends StatefulWidget {
  Terminal({Key key, this.server, this.port}) : super(key: key);
  final String server;
  final int port;

  @override
  _TerminalState createState() => _TerminalState();
}

class _TerminalState extends State<Terminal> {
  String _output;

  void dataHandler(data) {
    String out = new String.fromCharCodes(data).trim();
    print(new String.fromCharCodes(data).trim());
    setState(() {
      _output = "$_output\n$out";
    });
  }

  void errorHandler(error, StackTrace trace){
    print(error);
  }

  void doneHandler(){
    socket.destroy();
  }

  void _startSocket(server, port) {
    setState(() {
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
    });
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    this._output = "";
    this._startSocket(widget.server, widget.port);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Text(
      '$_output'
    );
  }
}
