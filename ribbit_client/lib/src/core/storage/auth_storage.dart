import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthStorage {
  Future<void> saveToken(String accessToken);
  Future<void> clearToken();
  Future<String?> getToken();
}

@Singleton(as: AuthStorage)
final class AuthStorageImpl implements AuthStorage {
  AuthStorageImpl(this._sharedPreferences);

  String? _token;
  final SharedPreferences _sharedPreferences;

  @override
  Future<String?> getToken() async => _token ??= _sharedPreferences.getString(
        _tokenPrefsKey,
      );

  @override
  Future<void> saveToken(String accessToken) =>
      _sharedPreferences.setString(_tokenPrefsKey, _token = accessToken);

  @override
  Future<void> clearToken() {
    _token = null;
    return _sharedPreferences.remove(_tokenPrefsKey);
  }

  static const _tokenPrefsKey = 'app_access_token';
}
