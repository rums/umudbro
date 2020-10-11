abstract class TerminalState {
  final List<String> buffer;
  TerminalState({this.buffer});
}

class TerminalInitial extends TerminalState {
  TerminalInitial()
      : super(buffer: new List<String>());
}

class TerminalBuffer extends TerminalState {
  TerminalBuffer(List<String> buffer) : super(buffer: buffer);
}