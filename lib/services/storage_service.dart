import 'package:get_storage/get_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final GetStorage _box = GetStorage();

  /// Write a value to storage
  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  /// Read a value from storage
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  /// Check if a key exists
  bool hasKey(String key) {
    return _box.hasData(key);
  }

  /// Remove a key
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  /// Clear all storage
  Future<void> erase() async {
    await _box.erase();
  }
}
