import 'package:umudbro/models/models.dart';

abstract class TerminalEvent {
  const TerminalEvent();
}

class TerminalStarted extends TerminalEvent {
  final Server server;

  TerminalStarted({this.server});
}

class TerminalInfoReceived extends TerminalEvent {
  const TerminalInfoReceived(this.data) : super();
  final String data;

  @override
  String toString() => "DataReceived { data: $data }";
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
