import '../models/health_entry.dart';
import '../services/db_service.dart';



class HealthRepository {
  final DBService _db = DBService();

  Future<void> addHealthEntry(HealthEntry entry) async => _db.insertHealthEntry(entry);
  Future<List<HealthEntry>> getAllEntries() async => _db.getAllEntries();
  Future<void> updateHealthEntry(HealthEntry entry) async => _db.updateHealthEntry(entry);
  Future<void> deleteHealthEntry(int id) async => _db.deleteHealthEntry(id);
}
