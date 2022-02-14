import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

String localAttendanceCacheBoxName = 'local attendance cache';

class AttendanceDataStore {
  init() async {
    //initialize hive
    await Hive.initFlutter();

    // open the box
    await Hive.openBox<List<dynamic>>(localAttendanceCacheBoxName);

    final cacheBox = Hive.box<List<dynamic>>(localAttendanceCacheBoxName);
    // await cacheBox.delete(localAttendanceCacheBoxName);
    var cacheAttendances = cacheBox.get(localAttendanceCacheBoxName);
    if (cacheAttendances == null) {
      await cacheBox.put(localAttendanceCacheBoxName, []);
    }
  }

  Future<List<dynamic>> get() async {
    final cacheBox = Hive.box<List<dynamic>>(localAttendanceCacheBoxName);
    return cacheBox.get(localAttendanceCacheBoxName) ?? [];
  }

  Future<void> add(Map<String, dynamic> attendance) async {
    final cacheBox = Hive.box<List<dynamic>>(localAttendanceCacheBoxName);
    List<dynamic> cacheAttendances = await get();
    cacheAttendances.add(attendance);
    await cacheBox.put(localAttendanceCacheBoxName, cacheAttendances);
  }

  Future<void> remove(Map<String, dynamic> attendance) async {
    final cacheBox = Hive.box<List<dynamic>>(localAttendanceCacheBoxName);
    List<dynamic> cacheAttendances = await get();
    cacheAttendances.remove(attendance);
    await cacheBox.put(localAttendanceCacheBoxName, cacheAttendances);
  }

  /// to be used with ValueListenableBuilder
  ValueListenable<Box<List<dynamic>>> get localCacheListenable =>
      Hive.box<List<dynamic>>(localAttendanceCacheBoxName).listenable();
}

final localAttendanceCacheProvider = Provider<AttendanceDataStore>(
  (ref) => throw UnimplementedError(),
);
