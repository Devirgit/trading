import 'package:trading/core/types/types.dart';
import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity(
      {required this.uid,
      this.name = '',
      this.currency = '',
      this.icon = 0,
      this.indexPosition = -1});

  final CategoryUID uid;
  final String name;
  final String currency;
  final int icon;
  final int indexPosition;

  bool get isEmpty => uid < 0;
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [uid, name];
}
