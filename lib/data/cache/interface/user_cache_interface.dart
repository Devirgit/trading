import 'package:trading/data/model/user_model.dart';

abstract class CacheUserService {
  Future<UserModel> read();
  Future<void> write(Map<String, dynamic> user);
}
