import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

String localAttendanceCacheBoxName = 'local attendance cache';

class AttendanceDataStore {
  /// init the datastore
  init() async {
    //initialize hive
    await Hive.initFlutter();

    // open the box
    await Hive.openBox<List<dynamic>>(localAttendanceCacheBoxName);

    // see if the box's content exists
    final cacheBox = Hive.box<List<dynamic>>(localAttendanceCacheBoxName);
    // await cacheBox.delete(localAttendanceCacheBoxName);
    var cacheAttendances = cacheBox.get(localAttendanceCacheBoxName);
    if (cacheAttendances == null) {
      await cacheBox.put(localAttendanceCacheBoxName, []);
    }
  }

  /// get all attendance records from the local cache
  Future<List<dynamic>> get() async {
    final cacheBox = Hive.box<List<dynamic>>(localAttendanceCacheBoxName);
    return cacheBox.get(localAttendanceCacheBoxName) ?? [];
  }

  /// clear all attendance records from the local cache
  Future<void> clear() async {
    final cacheBox = Hive.box<List<dynamic>>(localAttendanceCacheBoxName);
    await cacheBox.put(localAttendanceCacheBoxName, []);
  }

  /// add an attendance record to the local cache.
  ///
  /// attendance model:
  /// ```dart
  /// {
  ///   user: {
  ///     int id,
  ///     String name,
  ///     String profile, // this should be a url
  ///   },
  ///   user_id: int,
  ///   time: DateTime,
  ///   note: String?,
  /// }
  /// ```
  ///
  Future<void> add(Map<String, dynamic> attendance) async {
    final cacheBox = Hive.box<List<dynamic>>(localAttendanceCacheBoxName);
    List<dynamic> cacheAttendances = await get();
    cacheAttendances.add(attendance);
    await cacheBox.put(localAttendanceCacheBoxName, cacheAttendances);
  }

  /// Remove an attendance record from the local cache.
  ///
  /// attendance model:
  /// ```dart
  /// {
  ///   user: {
  ///     int id,
  ///     String name,
  ///     String profile, // this should be a url
  ///   },
  ///   user_id: int,
  ///   time: DateTime,
  ///   note: String?,
  /// }
  /// ```
  ///
  Future<void> remove(dynamic attendance) async {
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
