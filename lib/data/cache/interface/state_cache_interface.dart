abstract class StateCache {
  Future<String?> getUrl();

  Future<void> setUrl(String path);
}
