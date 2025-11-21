import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:easy_db/easy_db.dart';

class HiveDatabase implements DatabaseRepository {
  @override
  Future<void> init() async {
    await Hive.initFlutter();
  }

  @override
  Future<void> set(
      String collection, String id, Map<String, dynamic> data) async {
    final processedData = data.map((key, value) {
      if (value == DatabaseRepository.serverTS) {
        return MapEntry(key, DateTime.now());
      }
      return MapEntry(key, value);
    });

    final box = Hive.isBoxOpen(collection)
        ? Hive.box(collection)
        : await Hive.openBox(collection);
    await box.put(id, processedData);
  }

  @override
  Future<void> update(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    final processedData = data.map((key, value) {
      if (value == DatabaseRepository.serverTS) {
        return MapEntry(key, DateTime.now());
      }
      return MapEntry(key, value);
    });

    final box = Hive.isBoxOpen(collection)
        ? Hive.box(collection)
        : await Hive.openBox(collection);
    final existing = box.get(id) ?? {};
    final updated = {...existing, ...processedData};
    await box.put(id, updated);
  }

  @override
  Future<Map<String, dynamic>?> get(
    String collection,
    String id, {
    dynamic defaultValue,
  }) async {
    final box = Hive.isBoxOpen(collection)
        ? Hive.box(collection)
        : await Hive.openBox(collection);
    final data = box.get(id, defaultValue: defaultValue);
    if (data is Map) {
      return data.cast<String, dynamic>();
    } else {
      return data;
    }
  }

  @override
  Future<Map<String, dynamic>?> getAll(String collection) async {
    final box = Hive.isBoxOpen(collection)
        ? Hive.box(collection)
        : await Hive.openBox(collection);

    if (box.isEmpty) return null;

    final Map<String, dynamic> result = {};
    for (var key in box.keys) {
      final data = box.get(key);
      if (data is Map) {
        result[key.toString()] = data.cast<String, dynamic>();
      } else {
        result[key.toString()] = data;
      }
    }

    return result;
  }

  @override
  Future<bool> exists(String collection, String id) async {
    final box = Hive.isBoxOpen(collection)
        ? Hive.box(collection)
        : await Hive.openBox(collection);
    return box.containsKey(id);
  }

  @override
  Future<bool> existsWhere(
    String collection, {
    required Map<String, dynamic> where,
  }) async {
    final box = Hive.isBoxOpen(collection)
        ? Hive.box(collection)
        : await Hive.openBox(collection);
    for (var item in box.values) {
      bool matches = true;
      for (var entry in where.entries) {
        if (item[entry.key] != entry.value) {
          matches = false;
          break;
        }
      }
      if (matches) return true;
    }
    return false;
  }

  @override
  Future<void> delete(String collection, String id) async {
    final box = Hive.isBoxOpen(collection)
        ? Hive.box(collection)
        : await Hive.openBox(collection);
    await box.delete(id);
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String collection, {
    Map<String, dynamic> where = const {},
  }) async {
    final box = Hive.isBoxOpen(collection)
        ? Hive.box(collection)
        : await Hive.openBox(collection);

    if (where.isEmpty) {
      return box.values.map((item) {
        final data = item.cast<String, dynamic>();
        return data;
      }).toList();
    }

    return box.values
        .where((item) {
          for (var entry in where.entries) {
            if (item[entry.key] != entry.value) return false;
          }
          return true;
        })
        .map((item) => item.cast<String, dynamic>())
        .toList();
  }
}
