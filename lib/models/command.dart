import 'dart:convert';

import 'package:equatable/equatable.dart';

class Command extends Equatable {
  final int id;
  final String name;
  final String commandText;
  final List<String> tags;

  Command({this.id, this.name, this.commandText, this.tags});

  @override
  List<Object> get props => [id, name, commandText, tags];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'commandText': commandText,
      'tags': tags,
    };
  }

  static Command fromMap(Map<String, dynamic> map) {
    return new Command(
      id: map['id'],
      name: map['name'],
      commandText: map['commandText'],
      tags: json.decode(map['tags']),
    );
  }

  static Command from(Command command, {name, commandText, tags}) {
    return new Command(
      id: command.id,
      name: name ?? command.name,
      commandText: commandText ?? command.commandText,
      tags: tags ?? command.tags,
    );
  }
}