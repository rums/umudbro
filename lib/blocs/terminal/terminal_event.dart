abstract class TerminalEvent {
  const TerminalEvent();
}

class TerminalInitialized extends TerminalEvent {
  final String address;
  final int port;

  TerminalInitialized({this.address = "192.168.254.11", this.port = 4242});
}

class TerminalDataReceived extends TerminalEvent {
  const TerminalDataReceived(this.data) : super();
  final String data;

  @override
  String toString() => "DataReceived { data: $data }";
}
