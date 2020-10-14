import 'package:umudbro/models/models.dart';

abstract class TerminalEvent {
  const TerminalEvent();
}

class TerminalInitialized extends TerminalEvent {
  final Server server;

  TerminalInitialized({this.server});
}

class TerminalDataReceived extends TerminalEvent {
  const TerminalDataReceived(this.data) : super();
  final String data;

  @override
  String toString() => "DataReceived { data: $data }";
}

class TerminalDataSent extends TerminalEvent {
  const TerminalDataSent(this.data) : super();
  final String data;

  @override
  String toString() => "DataSent { data: $data }";
}
