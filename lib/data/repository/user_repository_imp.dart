import 'dart:async';

import 'package:trading/core/error/auth_failure.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/core/error/exception.dart';
import 'package:trading/core/components/respons.dart';
import 'package:trading/data/api/interface/auth_service_interface.dart';
import 'package:trading/data/cache/interface/clear_cache_interface.dart';
import 'package:trading/data/model/user_model.dart';
import 'package:trading/data/cache/interface/user_cache_interface.dart';
import 'package:trading/data/mapper/auth_user_mapper.dart';
import 'package:trading/domain/entitis/user_entity.dart';
import 'package:trading/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(
      {required this.authService,
      required this.cacheUserService,
      required this.clearCache});

  final AuthService authService;
  final CacheUserService cacheUserService;
  final _changeUserStream = StreamController<UserEntity>();
  final ClearCache clearCache;

  @override
  void dispose() => _changeUserStream.close();

  @override
  Stream<UserEntity> get userChange async* {
    yield* _changeUserStream.stream;
  }

  @override
  Future<Respons<Failure, UserEntity>> logIn(
      String email, String password) async {
    try {
      final remoteUser =
          await authService.loginUser(email: email, password: password);
      await cacheUserService.write(remoteUser.toJson());
      final user = UserMapper.fromApi(remoteUser);
      _changeUserStream.add(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(LoginServerFailure.fromType(e.type));
    }
  }

  @override
  Future<Respons<Failure, bool>> logOut(UserEntity user) async {
    try {
      await authService.logOut(user.token);

      await cacheUserService.write(UserModel.emptyToJson);
      await clearCache.clearAppCache();
      _changeUserStream.add(UserEntity.empty);
      return const Right(true);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Respons<Failure, UserEntity>> autoLogin(bool val) async {
    final cacheUser = await cacheUserService.read();
    final user = UserMapper.fromApi(cacheUser);
    _changeUserStream.add(user);
    return Right(user);
  }

  @override
  Future<Respons<Failure, UserEntity>> registerUser(
      String email, String password) async {
    try {
      final remoteUser =
          await authService.registerUser(email: email, password: password);
      await cacheUserService.write(remoteUser.toJson());
      final user = UserMapper.fromApi(remoteUser);
      _changeUserStream.add(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(RegisterServerFailure.fromType(e.type));
    }
  }
}
