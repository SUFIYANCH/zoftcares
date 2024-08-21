import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final prefs = SharedPreferences.getInstance();

  void setToken(String token) async {
    await (await prefs).setString('accessToken', token);
  }
}

final storageProvider = Provider<StorageService>((ref) {
  return StorageService();
});
