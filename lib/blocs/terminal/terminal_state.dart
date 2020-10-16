import 'package:umudbro/models/models.dart';

abstract class TerminalState {
  final Server server;
  final List<BufferItem> buffer;

  TerminalState({this.server, this.buffer});
}

class TerminalInitial extends TerminalState {
  final Server server;

  TerminalInitial({this.server}) : super(server: server, buffer: []);
}

class TerminalConnectSuccess extends TerminalState {
  final Server server;
  final List<BufferItem> buffer;

  TerminalConnectSuccess({this.server, this.buffer})
      : super(server: server, buffer: buffer);
}
