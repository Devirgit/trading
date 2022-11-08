import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/user_entity.dart';
import 'package:trading/domain/repository/user_repository.dart';

class LogOutUser extends UseCase<bool, UserEntity> {
  LogOutUser(UserRepository authRepository) : _authRepository = authRepository;

  final UserRepository _authRepository;

  @override
  Future<Respons<Failure, bool>> call(UserEntity params) async {
    return await _authRepository.logOut(params);
  }
}
