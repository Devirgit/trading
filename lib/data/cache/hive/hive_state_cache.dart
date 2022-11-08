import 'package:trading/data/cache/hive/hive_base.dart';
import 'package:trading/data/cache/interface/state_cache_interface.dart';

class HiveStateCache implements StateCache {
  static const _activeUrlKey = 'active_url';

  @override
  Future<String?> getUrl() async {
    return await HiveBase().read(HiveBase.stateAppCache, _activeUrlKey);
  }

  @override
  Future<void> setUrl(String path) {
    return HiveBase()
        .write(path, boxName: HiveBase.stateAppCache, keyName: _activeUrlKey);
  }
}
