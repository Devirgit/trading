import 'dart:convert';

import 'package:trading/core/error/exception.dart';
import 'package:trading/data/model/user_model.dart';
import 'package:trading/data/cache/interface/user_cache_interface.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureCacheUserService implements CacheUserService {
  static const _userKey = 'auth';
  static FlutterSecureStorage? _storage;
  SecureCacheUserService() {
    _storage = const FlutterSecureStorage();
  }

  IOSOptions _getIOSOptions() => const IOSOptions(
        accountName: 'daytarde_secure_storage_service',
      );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        sharedPreferencesName: 'daytarde_secure_storage_service',
      );

  @override
  Future<UserModel> read() async {
    try {
      final response = await _storage?.read(
          key: _userKey,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());
      if (response != null) {
        return UserModel.fromJson(jsonDecode(response));
      } else {
        return UserModel.fromJson(UserModel.emptyToJson);
      }
    } on CacheException {
      return UserModel.fromJson(UserModel.emptyToJson);
    }
  }

  @override
  Future<void> write(Map<String, dynamic> user) async {
    return await _storage?.write(
        key: _userKey,
        value: jsonEncode(user),
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
  }
}
