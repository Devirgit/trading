abstract class AppStateRepository {
  Future<String> getPath();

  Future<void> savePath(String path);
}
