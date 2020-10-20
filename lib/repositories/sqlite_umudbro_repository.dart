import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:sqflite_migration/sqflite_migration.dart';
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
      ''',
      '''
      CREATE TABLE mud_commands(id INTEGER PRIMARY KEY, name TEXT, command_text TEXT, tags TEXT);
      ''',
      '''
      CREATE TABLE mud_command_pages(id INTEGER PRIMARY KEY, column_count INTEGER, mud_command_slots TEXT);
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
  Future<int> addMudCommand(MudCommand command) async {
    final Database db = await database;
    return db.insert('mud_commands', command.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Stream<List<MudCommand>> mudCommands() async* {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mud_commands');
    yield List.generate(maps.length, (i) {
      return MudCommand.fromMap(maps[i]);
    });
  }

  @override
  Future<MudCommand> mudCommand(MudCommand whereCommand) async {
    final Database db = await database;
    List<MapEntry> filledEntries = whereCommand
        .toMap()
        .entries
        .where((element) => element.value != null)
        .toList();
    String where = filledEntries.map((e) => "${e.key} = ?").join(" and ");
    List<dynamic> whereArgs = filledEntries.map((e) => e.value).toList();
    final List<Map<String, dynamic>> maps =
        await db.query("mud_commands", where: where, whereArgs: whereArgs);
    if (maps.length > 0) {
      return MudCommand.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> deleteMudCommand(MudCommand command) async {
    final Database db = await database;
    await db.delete(
      'mud_commands',
      where: "id = ?",
      whereArgs: [command.id],
    );
  }

  @override
  Future<int> updateMudCommand(MudCommand command) async {
    final Database db = await database;

    var id = await db.update(
      'mud_commands',
      command.toMap(),
      where: "id = ?",
      whereArgs: [command.id],
    );
    return id;
  }

  // mud command pages
  @override
  Future<int> addMudCommandPage(MudCommandPage page) async {
    final Database db = await database;

    MudCommandPage hydratedPage;
    List<MudCommandSlot> hydratedSlots = await hydrateSlots(page.mudCommandSlots ?? []);
    hydratedPage = MudCommandPage.from(page, mudCommandSlots: hydratedSlots);
    var id = await db.insert('mud_command_pages', hydratedPage.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  @override
  Future<void> deleteMudCommandPage(MudCommandPage page) async {
    final Database db = await database;
    await db.delete(
      'mud_command_pages',
      where: "id = ?",
      whereArgs: [page.id],
    );
  }

  @override
  Future<MudCommandPage> mudCommandPage(MudCommandPage mudCommand) {
    return UmudbroStubs().mudCommandPageStub(1);
  }

  @override
  Stream<List<MudCommandPage>> mudCommandPages() async* {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mud_command_pages');
    final List<Map<String, dynamic>> commands = await db.query('mud_commands');
    yield List.generate(maps.length, (i) {
      return MudCommandPage.fromMap(maps[i], commands);
    });
  }

  @override
  Future<void> updateMudCommandPage(MudCommandPage page) async {
    final Database db = await database;

    MudCommandPage hydratedPage;
    List<MudCommandSlot> hydratedSlots = await hydrateSlots(page.mudCommandSlots ?? []);
    hydratedPage = MudCommandPage.from(page, mudCommandSlots: hydratedSlots);

    await db.update(
      'mud_command_pages',
      hydratedPage.toMap(),
      where: "id = ?",
      whereArgs: [page.id],
    );
  }

  Future<List<MudCommandSlot>> hydrateSlots(List<MudCommandSlot> slots) async {
    List<MudCommandSlot> hydratedSlots = [];
    for (var slot in slots) {
      if (slot.mudCommand.id == null) {
        var id = await addMudCommand(slot.mudCommand);
        hydratedSlots.add(MudCommandSlot.from(slot,
            mudCommand: MudCommand.from(slot.mudCommand, id: id)));
      } else {
        updateMudCommand(slot.mudCommand);
        hydratedSlots.add(slot);
      }
    }
    return hydratedSlots;
  }

  Future<int> _addEntity(entity) async {
    final Database db = await database;
    var id = await db.insert(entity.table, entity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }
}

class UmudbroStubs {
  Future<MudCommandPage> mudCommandPageStub(id) async {
    return MudCommandPage(
        id: id,
        columnCount: 3,
        mudCommandSlots: <MudCommandSlot>[
          MudCommandSlot(
            mudCommand: MudCommand(
              id: 1,
              name: "look",
              commandText: "look",
              tags: ["basics"],
            ),
            gridRow: Random().nextInt(3),
            gridColumn: Random().nextInt(3),
            backgroundColorInt: 0xff00ff00,
            foregroundColorInt: 0xff000000,
          ),
          MudCommandSlot(
            mudCommand: MudCommand(
              id: 2,
              name: "inventory",
              commandText: "inventory",
              tags: ["basics"],
            ),
            gridRow: Random().nextInt(3),
            gridColumn: Random().nextInt(3),
            backgroundColorInt: 0xff00ff00,
            foregroundColorInt: 0xff000000,
          ),
          MudCommandSlot(
            mudCommand: MudCommand(
              id: 3,
              name: "kill all",
              commandText: "kill all",
              tags: ["basics"],
            ),
            gridRow: Random().nextInt(3),
            gridColumn: Random().nextInt(3),
            backgroundColorInt: 0xff00ff00,
            foregroundColorInt: 0xff000000,
          ),
        ]..shuffle());
  }

  Stream<List<MudCommandPage>> mudCommandPagesStub() async* {
    yield* new Stream.fromIterable([
      [
        await mudCommandPageStub(1),
        await mudCommandPageStub(2),
        await mudCommandPageStub(3)
      ]..shuffle()
    ]);
  }
}
