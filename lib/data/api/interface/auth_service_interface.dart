import 'package:trading/data/model/user_model.dart';

abstract class AuthService {
  Future<UserModel> loginUser(
      {required String email, required String password});

  Future<UserModel> registerUser(
      {required String email, required String password});

  Future<bool> logOut(String token);
}
