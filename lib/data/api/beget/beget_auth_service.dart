import 'package:trading/core/components/device_info.dart';
import 'package:trading/data/api/interface/auth_service_interface.dart';
import 'package:trading/data/api/beget/beget_base.dart';
import 'package:trading/data/model/user_model.dart';
import 'package:dio/dio.dart';

class BegetAuthService implements AuthService {
  Future<UserModel> auth(String command,
      {required String email, required String password}) async {
    String device = await DeviceInfo.name();
    final options = RequestOptions(
        path: command,
        method: 'POST',
        queryParameters: {
          'email': email,
          'password': password,
          'device_name': device
        });
    return await BegetBase()
        .request(options, (respons) => UserModel.fromJson(respons));
  }

  @override
  Future<UserModel> loginUser(
      {required String email, required String password}) async {
    return await auth('login', email: email, password: password);
  }

  @override
  Future<UserModel> registerUser(
      {required String email, required String password}) async {
    return await auth('register', email: email, password: password);
  }

  @override
  Future<bool> logOut(String token) async {
    final options = RequestOptions(
      path: 'logout',
      method: 'POST',
      headers: {'Authorization': 'Bearer $token'},
    );
    return await BegetBase().request(options, (respons) => true);
  }
}
