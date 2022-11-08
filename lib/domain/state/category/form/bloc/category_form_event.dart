part of 'category_form_bloc.dart';

enum SubmitFormCategory { change, create }

abstract class CategoryFormEvent extends Equatable {
  const CategoryFormEvent();

  @override
  List<Object> get props => [];
}

class InitChangeEvent extends CategoryFormEvent {
  const InitChangeEvent(this.category);

  final CategoryEntity category;
  @override
  List<Object> get props => [category];
}

class NameChangeEvent extends CategoryFormEvent {
  const NameChangeEvent(this.name);

  final String name;
  @override
  List<Object> get props => [name];
}

class CurrencyChangeEvent extends CategoryFormEvent {
  const CurrencyChangeEvent(this.currency);

  final String currency;
  @override
  List<Object> get props => [currency];
}

class IconChangeEvent extends CategoryFormEvent {
  const IconChangeEvent(this.iconId);

  final int iconId;
  @override
  List<Object> get props => [iconId];
}

class SubmitChangeEvent extends CategoryFormEvent {
  const SubmitChangeEvent(this.typeForm);

  final SubmitFormCategory typeForm;
}
