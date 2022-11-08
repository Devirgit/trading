part of 'category_form_bloc.dart';

class CategoryFormState extends Equatable {
  const CategoryFormState({
    this.uid,
    this.name = const InputString.pure(),
    this.currency = const InputString.pure(),
    this.iconId = 0,
    this.status = FormValidStatus.empty,
    this.errorMessage,
    this.successCategory,
  });

  final CategoryUID? uid;
  final InputString name;
  final InputString currency;
  final int iconId;
  final FormValidStatus status;
  final String? errorMessage;
  final CategoryEntity? successCategory;

  const CategoryFormState.success(CategoryEntity category)
      : this(successCategory: category, status: FormValidStatus.submitSuccess);

  const CategoryFormState.initChange(
      {required CategoryUID uid,
      required InputString name,
      required InputString currency,
      required int icon})
      : this(
            uid: uid,
            name: name,
            currency: currency,
            iconId: icon,
            status: FormValidStatus.init);

  CategoryFormState copyWith({
    InputString? name,
    InputString? currency,
    int? iconId,
    FormValidStatus? status,
    String? errorMessage,
    CategoryUID? uid,
  }) {
    return CategoryFormState(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      iconId: iconId ?? this.iconId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, name, currency, iconId];
}
