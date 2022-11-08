import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/user_entity.dart';
import 'package:trading/domain/repository/user_repository.dart';

class LoginUserEmail extends UseCase<UserEntity, UserEmailPassword> {
  LoginUserEmail(UserRepository authRepository)
      : _authRepository = authRepository;

  final UserRepository _authRepository;

  @override
  Future<Respons<Failure, UserEntity>> call(UserEmailPassword params) async {
    return await _authRepository.logIn(params.email, params.password);
  }
}
