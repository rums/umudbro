import 'package:umudbro/models/models.dart';

enum TerminalOverlay {
  Buttons,
  Settings,
}

abstract class TerminalState {}

class TerminalInitial extends TerminalState {
  TerminalInitial() : super();
}

class TerminalConnectInProgress extends TerminalState {
  final Server server;
  final List<BufferItem> buffer;

  TerminalConnectInProgress({this.server, this.buffer});
}

class TerminalConnectSuccess extends TerminalState {
  final Server server;
  final List<BufferItem> buffer;
  final TerminalOverlay activeOverlay;
  final bool showOverlay;

  TerminalConnectSuccess(
      {this.server,
      this.buffer,
      this.activeOverlay = TerminalOverlay.Buttons,
      this.showOverlay = true})
      : super();
}
