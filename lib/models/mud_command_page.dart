import 'dart:convert';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:umudbro/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mud_command_page.g.dart';

@JsonSerializable()
class MudCommandPage extends Equatable {
  final int id;
  final int columnCount;
  final List<MudCommandSlot> mudCommandSlots;

  MudCommandPage({this.id, this.columnCount, this.mudCommandSlots});

  bool slotIsOccupied(MudCommandSlot newSlot) {
    return mudCommandSlots.any((slot) =>
        slot.gridRow == newSlot.gridRow &&
        slot.gridColumn == newSlot.gridColumn);
  }

  @override
  List<Object> get props => [id, mudCommandSlots];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'column_count': columnCount,
      'mud_command_slots': json.encode(mudCommandSlots ?? []),
    };
  }

  static MudCommandPage fromMap(
      Map<String, dynamic> map, List<Map<String, dynamic>> commandMaps) {
    final commands = MudCommand.fromMapList(commandMaps);
    return MudCommandPage(
      id: map['id'],
      columnCount: map['column_count'],
      mudCommandSlots: map['mud_command_slots'] != null
          ? (json.decode(map['mud_command_slots']) as List)
              .map((i) => MudCommandSlot.fromJsonWithCommands(i, commands))
              .toList()
          : null,
    );
  }

  static MudCommandPage from(MudCommandPage page,
      {id, columnCount, mudCommandSlots}) {
    return new MudCommandPage(
      id: id ?? page?.id,
      columnCount: columnCount ?? page?.columnCount,
      mudCommandSlots: mudCommandSlots ?? page?.mudCommandSlots,
    );
  }

  @override
  factory MudCommandPage.fromJson(Map<String, dynamic> json) =>
      _$MudCommandPageFromJson(json);

  Map<String, dynamic> toJson() => _$MudCommandPageToJson(this);
}

@JsonSerializable()
class MudCommandSlot extends Equatable {
  final MudCommand mudCommand;
  final int gridRow;
  final int gridColumn;
  final int backgroundColorInt;
  final int foregroundColorInt;

  Color get backgroundColor => Color(backgroundColorInt);
  Color get foregroundColor => Color(foregroundColorInt);

  MudCommandSlot(
      {this.mudCommand,
      this.gridRow,
      this.gridColumn,
      this.backgroundColorInt,
      this.foregroundColorInt});

  @override
  List<Object> get props =>
      [mudCommand, gridRow, gridColumn, backgroundColorInt, foregroundColorInt];

  Map<String, dynamic> toMap() {
    return {
      'mud_command_id': mudCommand.id,
      'grid_row': gridRow,
      'grid_column': gridColumn,
      'background_color': backgroundColorInt,
      'foreground_color': foregroundColorInt,
    };
  }

  static MudCommandSlot fromMap(Map<String, dynamic> map) {
    return MudCommandSlot(
      mudCommand: map['mud_command'],
      gridRow: map['grid_row'],
      gridColumn: map['grid_column'],
      backgroundColorInt: map['background_color'],
      foregroundColorInt: map['foreground_color'],
    );
  }

  static MudCommandSlot from(MudCommandSlot slot,
      {mudCommand, gridRow, gridColumn, backgroundColor, foregroundColor}) {
    return new MudCommandSlot(
      mudCommand: mudCommand ?? slot?.mudCommand,
      gridRow: gridRow ?? slot?.gridRow,
      gridColumn: gridColumn ?? slot?.gridColumn,
      backgroundColorInt: backgroundColor ?? slot?.backgroundColorInt,
      foregroundColorInt: foregroundColor ?? slot?.foregroundColorInt,
    );
  }

  factory MudCommandSlot.fromJsonWithCommands(
      Map<String, dynamic> json, List<MudCommand> commands) {
    return MudCommandSlot(
      mudCommand: commands.firstWhere((element) =>
          element.id == MudCommand.fromJson(json['mudCommand']).id),
      gridRow: json['gridRow'] as int,
      gridColumn: json['gridColumn'] as int,
      backgroundColorInt: json['backgroundColor'] as int,
      foregroundColorInt: json['foregroundColor'] as int,
    );
  }

  @override
  factory MudCommandSlot.fromJson(Map<String, dynamic> json) =>
      _$MudCommandSlotFromJson(json);

  Map<String, dynamic> toJson() => _$MudCommandSlotToJson(this);
}
