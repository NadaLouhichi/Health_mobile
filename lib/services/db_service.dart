import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/health_entry.dart';

class DBService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    if (kIsWeb) {
      throw UnsupportedError('SQLite is not supported on web.');
    }

    // ✅ Handle desktop
    if (!Platform.isAndroid && !Platform.isIOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      final dbPath = await databaseFactoryFfi.getDatabasesPath();
      final path = join(dbPath, 'health_tracker.db');
      return await databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE health_entries (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                date TEXT,
                bmi REAL,
                caloriesBurned REAL,
                caloriesConsumed REAL
              )
            ''');
          },
        ),
      );
    }

    // ✅ Handle mobile
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'health_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE health_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            bmi REAL,
            caloriesBurned REAL,
            caloriesConsumed REAL
          )
        ''');
      },
    );
  }



  // CREATE
  Future<int> insertHealthEntry(HealthEntry entry) async {
    final db = await database;
    return await db.insert('health_entries', entry.toMap());
  }

  // READ
  Future<List<HealthEntry>> getAllEntries() async {
    final db = await database;
    final maps = await db.query('health_entries', orderBy: 'date DESC');
    return maps.map((e) => HealthEntry.fromMap(e)).toList();
  }

  // UPDATE
  Future<int> updateHealthEntry(HealthEntry entry) async {
    final db = await database;
    return await db.update(
      'health_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  // DELETE
  Future<int> deleteHealthEntry(int id) async {
    final db = await database;
    return await db.delete('health_entries', where: 'id = ?', whereArgs: [id]);
  }
}
