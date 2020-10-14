import 'package:umudbro/models/models.dart';

abstract class TerminalState {
  final Server server;
  final List<String> buffer;

  TerminalState({this.server, this.buffer});
}

class TerminalInitial extends TerminalState {
  final Server server;

  TerminalInitial({this.server}) : super(server: server, buffer: []);
}

class TerminalActive extends TerminalState {
  final Server server;
  final List<String> buffer;

  TerminalActive({this.server, this.buffer})
      : super(server: server, buffer: buffer);
}
