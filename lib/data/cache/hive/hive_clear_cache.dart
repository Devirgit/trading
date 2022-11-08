import 'package:trading/data/cache/hive/hive_base.dart';
import 'package:trading/data/cache/interface/clear_cache_interface.dart';

class HiveClearCache implements ClearCache {
  @override
  Future<void> clearAppCache() async {
    await HiveBase().clear(HiveBase.dataAppCache);
    await HiveBase().clear(HiveBase.stateAppCache);
  }
}
