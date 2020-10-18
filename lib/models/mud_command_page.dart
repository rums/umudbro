import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';
import 'package:umudbro/models/models.dart';

class MudCommandPage extends Equatable {
  final int id;
  final int columnCount;
  final List<MudCommandSlot> mudCommandSlots;

  MudCommandPage({this.id, this.columnCount, this.mudCommandSlots});

  @override
  List<Object> get props => [id, mudCommandSlots];
}

class MudCommandSlot extends Equatable {
  final MudCommand mudCommand;
  final Tuple2<int, int> gridLocation;
  final int backgroundColor;
  final int foregroundColor;

  MudCommandSlot({this.mudCommand, this.gridLocation, this.backgroundColor, this.foregroundColor});

  @override
  List<Object> get props => [mudCommand, gridLocation, backgroundColor, foregroundColor];
}