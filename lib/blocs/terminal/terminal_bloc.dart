import 'dart:async';
import 'package:bloc/bloc.dart';

import 'terminal.dart';

class TerminalBloc extends Bloc<TerminalEvent, TerminalState> {
  TerminalBloc(TerminalState initialState) : super(initialState);

  @override
  Stream<TerminalState> mapEventToState(
    TerminalEvent event,
  ) async* {
    final currentState = state;
    if (event is TerminalDataReceived) {
        final List<String> buffer = currentState.buffer..add(event.data);
        yield TerminalBuffer(buffer);
    }
  }
}
