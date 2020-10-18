import 'dart:async';
import 'package:bloc/bloc.dart';

import 'commands.dart';

class CommandsBloc extends Bloc<CommandsEvent, CommandsState> {
  CommandsBloc(CommandsState initialState) : super(initialState);

  @override
  CommandsState get initialState => InitialCommandsState();

  @override
  Stream<CommandsState> mapEventToState(CommandsEvent event) async* {
    // TODO: Add your event logic
  }
}
