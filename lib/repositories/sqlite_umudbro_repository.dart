import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:sqflite_migration/sqflite_migration.dart';
import 'package:umudbro/models/command.dart';
import 'dart:async';
import 'package:umudbro/models/server.dart';
import 'package:umudbro/repositories/umudbro_repository.dart';

class SqliteUmudbroRepository implements UmudbroRepository {
  final Future<Database> database = getDatabasesPath().then((String path) {
    final initialScript = [
      '''
      CREATE TABLE servers(id INTEGER PRIMARY KEY, name TEXT, address TEXT, port INTEGER, do_connect INTEGER);
      '''
    ];
    final migrations = [
      '''
      ALTER TABLE servers ADD COLUMN name TEXT;
      ''',
      '''
      ALTER TABLE servers ADD COLUMN do_connect INTEGER;
      ''',
      '''
      ALTER TABLE servers ADD COLUMN buffer TEXT;
      '''
    ];
    final config = MigrationConfig(
        initializationScript: initialScript, migrationScripts: migrations);
    final String dbPath = join(path, 'umudbro_database.db');
    return openDatabaseWithMigration(dbPath, config);
  });

  @override
  Future<void> addServer(Server server) async {
    final Database db = await database;
    await db.insert('servers', server.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteServer(Server server) async {
    final Database db = await database;
    await db.delete(
      'servers',
      where: "id = ?",
      whereArgs: [server.id],
    );
  }

  @override
  Stream<List<Server>> servers() async* {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('servers');
    yield List.generate(maps.length, (i) {
      return Server.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateServer(Server server) async {
    final Database db = await database;

    await db.update(
      'servers',
      server.toMap(),
      where: "id = ?",
      whereArgs: [server.id],
    );
  }

  @override
  Future<void> setDefaultServer(Server server) async {
    final Database db = await database;

    await db.update(
      'servers',
      {'do_connect': 0},
      where: "id <> ?",
      whereArgs: [server.id],
    );
    await db.update(
      'servers',
      {'do_connect': 1},
      where: "id = ?",
      whereArgs: [server.id],
    );
  }

  @override
  Future<Server> server(Server whereServer) async {
    final Database db = await database;
    List<MapEntry> filledEntries = whereServer
        .toMap()
        .entries
        .where((element) => element.value != null)
        .toList();
    String where = filledEntries.map((e) => "${e.key} = ?").join(" and ");
    List<dynamic> whereArgs = filledEntries.map((e) => e.value).toList();
    final List<Map<String, dynamic>> maps =
        await db.query("servers", where: where, whereArgs: whereArgs);
    if (maps.length > 0) {
      return Server.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> addCommand(Command command) {
    // TODO: implement addCommand
    throw UnimplementedError();
  }

  @override
  Stream<List<Command>> commands() {
    // TODO: implement commands
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCommand(Command command) {
    // TODO: implement deleteCommand
    throw UnimplementedError();
  }

  @override
  Future<void> updateCommand(Command command) {
    // TODO: implement updateCommand
    throw UnimplementedError();
  }
}
