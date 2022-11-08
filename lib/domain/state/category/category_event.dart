part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class DeleteCategoryEvent extends CategoryEvent {
  const DeleteCategoryEvent(this.itemIndex);
  final int itemIndex;

  @override
  List<Object> get props => [itemIndex];
}

class CreateCategoryEvent extends CategoryEvent {
  const CreateCategoryEvent(this.category);
  final CategoryEntity category;

  @override
  List<Object> get props => [category];
}

class UpdateCategoryEvent extends CategoryEvent {
  const UpdateCategoryEvent(this.index, {required this.category});

  final int index;
  final CategoryEntity category;

  @override
  List<Object> get props => [index, category];
}

class GetAllCategoryEvent extends CategoryEvent {
  const GetAllCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetOneCategoryEvent extends CategoryEvent {
  const GetOneCategoryEvent(this.uid);
  final CategoryUID uid;

  @override
  List<Object> get props => [uid];
}

class NameChanged extends CategoryEvent {
  const NameChanged(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}

class CurrencyChanged extends CategoryEvent {
  const CurrencyChanged(this.currency);
  final String currency;

  @override
  List<Object> get props => [currency];
}

class IconChanged extends CategoryEvent {
  const IconChanged(this.iconId);
  final int iconId;

  @override
  List<Object> get props => [iconId];
}
