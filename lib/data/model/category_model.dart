import 'package:trading/core/types/types.dart';
import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  const CategoryModel(
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

  CategoryModel.fromJson(Map<String, dynamic> map)
      : uid = map['id'] as int,
        name = map['name'] as String,
        currency = map['currency'] as String,
        icon = map['icon_id'] as int,
        indexPosition = map['item_position'] as int;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'currency': currency,
      'icon_id': icon,
      'item_position': indexPosition
    };
  }

  CategoryModel copyWith({
    required CategoryUID uid,
    String? name,
    String? currency,
    int? icon,
    int? indexPosition,
  }) {
    return CategoryModel(
        uid: uid,
        name: name ?? this.name,
        currency: currency ?? this.currency,
        icon: icon ?? this.icon,
        indexPosition: indexPosition ?? this.indexPosition);
  }

  bool get isEmpty => uid < 0;

  @override
  List<Object?> get props => [uid, name];
}
