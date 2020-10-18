import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:sqflite_migration/sqflite_migration.dart';
import 'package:tuple/tuple.dart';
import 'package:umudbro/models/mud_command.dart';
import 'package:umudbro/models/mud_command_page.dart';
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
      ALTER TABLE servers ADD COLUMN buffer TEXT;
      '''
    ];
    final config = MigrationConfig(
        initializationScript: initialScript, migrationScripts: migrations);
    final String dbPath = join(path, 'umudbro_database.db');
    return openDatabaseWithMigration(dbPath, config);
  });

  // servers
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

  // mud commands
  @override
  Future<void> addMudCommand(MudCommand command) {
    // TODO: implement addCommand
    throw UnimplementedError();
  }

  @override
  Stream<List<MudCommand>> mudCommands() {
    // TODO: implement commands
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMudCommand(MudCommand command) {
    // TODO: implement deleteCommand
    throw UnimplementedError();
  }

  @override
  Future<void> updateMudCommand(MudCommand command) {
    // TODO: implement updateCommand
    throw UnimplementedError();
  }

  // mud command pages
  @override
  Future<void> addMudCommandPage(MudCommandPage command) {
    // TODO: implement addMudCommandPage
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMudCommandPage(MudCommandPage command) {
    // TODO: implement deleteMudCommandPage
    throw UnimplementedError();
  }

  @override
  Future<MudCommand> mudCommand(MudCommand mudCommand) {
    // TODO: implement mudCommand
    throw UnimplementedError();
  }

  @override
  Future<MudCommandPage> mudCommandPage(MudCommandPage mudCommand) {
    return UmudbroStubs().mudCommandPageStub();
  }

  @override
  Stream<List<MudCommandPage>> mudCommandPages() {
    // TODO: implement mudCommandPages
    throw UnimplementedError();
  }

  @override
  Future<void> updateMudCommandPage(MudCommandPage command) {
    // TODO: implement updateMudCommandPage
    throw UnimplementedError();
  }
}

class UmudbroStubs {
  Future<MudCommandPage> mudCommandPageStub() async {
    return MudCommandPage(id: 1, columnCount: 3, mudCommandSlots: <MudCommandSlot>[
      MudCommandSlot(mudCommand:
        MudCommand(
          id: 1,
          name: "look name",
          commandText: "look",
          tags: ["thing1", "thing2"],
        ),
        gridLocation: Tuple2(1, 1),
        backgroundColor: "#ffffff",
        foregroundColor: "#000000",
      ),
    ]);
  }
}
