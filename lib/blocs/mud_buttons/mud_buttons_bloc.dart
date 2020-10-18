import 'dart:async';
import 'package:bloc/bloc.dart';

import 'mud_buttons.dart';

class MudButtonsBloc extends Bloc<MudButtonsEvent, MudButtonsState> {
  MudButtonsBloc(MudButtonsState initialState) : super(initialState);

  @override
  MudButtonsState get initialState => MudButtonsInitial();

  @override
  Stream<MudButtonsState> mapEventToState(MudButtonsEvent event) async* {
    // TODO: Add your event logic
  }
}
