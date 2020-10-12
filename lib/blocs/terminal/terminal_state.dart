abstract class TerminalState {
  final List<String> buffer;
  TerminalState({this.buffer});
}

class TerminalInitial extends TerminalState {
  TerminalInitial()
      : super(buffer: new List<String>());
}

class TerminalActive extends TerminalState {
  TerminalActive(List<String> buffer) : super(buffer: buffer);
}