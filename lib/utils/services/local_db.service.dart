import 'dart:developer';

import 'package:guest_allow/utils/db/user_collection.db.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class LocalDbService {
  LocalDbService._();

  static late Isar _db;

  static Future initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    _db = await Isar.open(
      [UserLocalDataSchema],
      directory: dir.path,
    );
  }

  static Isar get db => _db;

  Future close() async {
    await _db.close();
  }

  static Future<void> clearLocalData() async {
    try {
      await _db.writeTxn(() async {
        await _db.userLocalDatas.filter().userIdIsNotEmpty().deleteAll();
      });
    } catch (e) {
      log('Error in clearLocalData: $e');
    }
  }

  static Future<void> insertUserLocalData(UserLocalData userLocalData) async {
    try {
      await _db.writeTxn(() async {
        await _db.userLocalDatas.put(userLocalData);
      });
    } catch (e) {
      log('Error in insertUserLocalData: $e');
    }
  }

  static Future<UserLocalData?> getUserLocalData() async {
    try {
      return await _db.userLocalDatas.get(1);
    } catch (e) {
      log('Error in getUserLocalData: $e');
      return null;
    }
  }

  static String getUserToken() {
    return _db.userLocalDatas.getSync(1)?.token ?? '';
  }

  static UserLocalData? getUserLocalDataSync() {
    return _db.userLocalDatas.getSync(1);
  }

  static setUserLocalData(UserLocalData user) async {
    await _db.writeTxn(() async {
      await _db.userLocalDatas.put(user);
    });
  }
}
