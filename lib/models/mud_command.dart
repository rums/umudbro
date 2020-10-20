import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import 'package:equatable/equatable.dart';

part 'mud_command.g.dart';

@JsonSerializable()
class MudCommand extends Equatable {
  static const TABLE = 'mud_commands';
  final int id;
  final String name;
  final String commandText;
  final List<String> tags;

  MudCommand({this.id, this.name, this.commandText, this.tags});

  @override
  List<Object> get props => [id, name, commandText, tags];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'command_text': commandText,
      'tags': json.encode(tags ?? []),
    };
  }

  static MudCommand fromMap(Map<String, dynamic> map) {
    return new MudCommand(
      id: map['id'],
      name: map['name'],
      commandText: map['command_text'],
      tags: map['tags'] != null ? List<String>.from(json.decode(map['tags'])) : [],
    );
  }

  static List<MudCommand> fromMapList(List<Map<String, dynamic>> maps) {
    return maps.map((map) => MudCommand.fromMap(map)).toList();
  }

  static MudCommand from(MudCommand command, {id, name, commandText, tags}) {
    return new MudCommand(
      id: id ?? command?.id,
      name: name ?? command?.name,
      commandText: commandText ?? command?.commandText,
      tags: tags ?? command?.tags,
    );
  }

  @override
  factory MudCommand.fromJson(Map<String, dynamic> json) =>
      _$MudCommandFromJson(json);

  Map<String, dynamic> toJson() => _$MudCommandToJson(this);
}
