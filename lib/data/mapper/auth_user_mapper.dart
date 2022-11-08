import 'package:trading/data/model/user_model.dart';
import 'package:trading/domain/entitis/user_entity.dart';

class UserMapper {
  static UserEntity fromApi(UserModel user) {
    return UserEntity(
      email: user.email,
      token: user.token,
    );
  }

  static Map<String, dynamic> toJson(UserEntity user) {
    return {'email': user.email, 'token': user.token};
  }
}
