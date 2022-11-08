import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    this.email = '',
    required this.token,
  });

  final String email;
  final String token;

  static const empty = UserEntity(token: '');
  bool get isEmpty => this == UserEntity.empty;
  bool get isNotEmpty => this != UserEntity.empty;

  @override
  List<Object?> get props => [token];
}
