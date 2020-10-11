abstract class TerminalEvent {
  const TerminalEvent();
}

class TerminalDataReceived extends TerminalEvent {
  const TerminalDataReceived(this.data) : super();
  final String data;

  @override
  String toString() => "DataReceived { data: $data }";
}
