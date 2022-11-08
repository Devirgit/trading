import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/user_entity.dart';
import 'package:trading/domain/repository/user_repository.dart';

class AttemptAutoLoginIn extends UseCase<UserEntity, bool> {
  AttemptAutoLoginIn(UserRepository authRepository)
      : _authRepository = authRepository;

  final UserRepository _authRepository;

  @override
  Future<Respons<Failure, UserEntity>> call(bool params) async {
    return await _authRepository.autoLogin(params);
  }
}
