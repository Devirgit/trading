import 'package:trading/core/components/respons.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/domain/entitis/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class UserRepository {
  Stream<UserEntity> get userChange;

  Future<Respons<Failure, UserEntity>> logIn(String email, String password);

  Future<Respons<Failure, bool>> logOut(UserEntity user);

  Future<Respons<Failure, UserEntity>> autoLogin(bool val);

  Future<Respons<Failure, UserEntity>> registerUser(
      String email, String password);
  void dispose();
}

class UserEmailPassword extends Equatable {
  final String email;
  final String password;

  const UserEmailPassword({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
