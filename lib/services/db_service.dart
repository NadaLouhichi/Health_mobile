import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import '../models/health_entry.dart';

class DBService {
  static const String hiveBoxName = 'health_entries';

  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  static Database? _sqliteDb;
  static Box<HealthEntry>? _hiveBox;

  Future<void> init() async {
    if (kIsWeb) {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(HealthEntryAdapter());
      }
      _hiveBox ??= await Hive.openBox<HealthEntry>(hiveBoxName);
    } else {
      if (!Platform.isAndroid && !Platform.isIOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'health_tracker.db');

      _sqliteDb ??= await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE health_entries (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              date TEXT,
              bmi REAL,
              caloriesBurned REAL,
              caloriesConsumed REAL,
              bmr REAL,
              dailyCalories REAL
            )
          ''');
        },
      );
    }
  }

  Future<void> insertHealthEntry(HealthEntry entry) async {
    if (kIsWeb) {
      await _hiveBox!.add(entry);
    } else {
      await _sqliteDb!.insert('health_entries', entry.toMap());
    }
  }

  Future<List<HealthEntry>> getAllEntries() async {
    if (kIsWeb) {
      return _hiveBox!.values.toList().cast<HealthEntry>();
    } else {
      final maps = await _sqliteDb!.query(
        'health_entries',
        orderBy: 'date DESC',
      );
      return maps.map((e) => HealthEntry.fromMap(e)).toList();
    }
  }

  Future<void> updateHealthEntry(HealthEntry entry) async {
    if (kIsWeb) {
      await entry.save();
    } else {
      await _sqliteDb!.update(
        'health_entries',
        entry.toMap(),
        where: 'id = ?',
        whereArgs: [entry.id],
      );
    }
  }

  Future<void> deleteHealthEntry(int id) async {
    if (kIsWeb) {
      final entry = _hiveBox!.values.firstWhere(
        (e) => e.id == id,
        orElse: () => throw Exception('Entry not found'),
      );
      await entry.delete();
    } else {
      await _sqliteDb!.delete(
        'health_entries',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }
}
