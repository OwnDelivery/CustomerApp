class InMemoryRepository {
  static InMemoryRepository? _instance;

  static InMemoryRepository get instance =>
      _instance ??= InMemoryRepository._();

  InMemoryRepository._();

  final Map<String, dynamic> _storage = {};

  void put(String key, dynamic value) {
    _storage[key] = value;
  }

  bool contains(String key) {
    return _storage.containsKey(key);
  }

  dynamic get(String key) {
    return _storage[key];
  }
}
