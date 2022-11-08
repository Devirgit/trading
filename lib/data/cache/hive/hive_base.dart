import 'package:trading/data/cache/hive/adapters/category_model_adapter.dart';
import 'package:trading/data/cache/hive/adapters/deal_model_adapter.dart';
import 'package:trading/data/cache/hive/adapters/stock_model_adapter.dart';
import 'package:hive_flutter/adapters.dart';

class HiveBase {
  static final HiveBase _instantce = HiveBase._internal();

  factory HiveBase() {
    return _instantce;
  }

  HiveBase._internal() {
    Hive.registerAdapter(StockModelAdapter());
    Hive.registerAdapter(DealModelAdapter());
    Hive.registerAdapter(DealListModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
  }

  static const stateAppCache = 'state_app_trade';
  static const dataAppCache = 'data_app_cache';

  Future<dynamic> read(String boxName, String keyName) async {
    final box = await Hive.openBox(boxName);
    return box.get(keyName);
  }

  Future<void> write(dynamic data,
      {required String boxName, required String keyName}) async {
    final box = await Hive.openBox(boxName);
    return await box.put(keyName, data);
  }

  Future<int> clear(String boxName) async {
    final box = await Hive.openBox(boxName);
    return box.clear();
  }

  Future<void> delete(String boxName, String keyName) async {
    final box = await Hive.openBox(boxName);
    return box.delete(keyName);
  }
}
