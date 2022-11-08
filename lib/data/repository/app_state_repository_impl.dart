import 'package:trading/data/cache/interface/state_cache_interface.dart';
import 'package:trading/domain/repository/app_state_repository.dart';

class AppStateRepositoryImpl extends AppStateRepository {
  AppStateRepositoryImpl({required this.stateCache});
  final StateCache stateCache;

  @override
  Future<String> getPath() async {
    final url = await stateCache.getUrl();
    return url ?? '/';
  }

  @override
  Future<void> savePath(String path) async {
    return await stateCache.setUrl(path);
  }
}
