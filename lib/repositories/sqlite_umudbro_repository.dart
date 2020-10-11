import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:umudbro/models/server.dart';
import 'package:umudbro/repositories/umudbro_repository.dart';

class SqliteUmudbroRepository implements UmudbroRepository {
  final Future<Database> database = getDatabasesPath().then((String path) {
    return openDatabase(
      join(path, 'umudbro_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE servers(id INTEGER PRIMARY KEY, address TEXT, port INTEGER)",
        );
      },
      version: 1,
    );
  });

  @override
  Future<void> addServer(Server server) async {
    final Database db = await database;
    await db.insert(
      'servers',
      server.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  @override
  Future<void> deleteServer(Server server) {
    // TODO: implement deleteServer
    throw UnimplementedError();
  }

  @override
  Stream<List<Server>> servers() async* {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('servers');
    yield List.generate(maps.length, (i) {
      return Server(
        id: maps[i]['id'],
        address: maps[i]['address'],
        port: maps[i]['port'],
      );
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
  }}