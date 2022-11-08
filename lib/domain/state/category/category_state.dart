part of 'category_bloc.dart';

enum CategoryDataStatus {
  none,
  success,
  failure,
  failureload,
  loading,
  delete,
  changing
}

class CategoryState extends Equatable {
  const CategoryState._(
      {this.status = CategoryDataStatus.none,
      this.categories = const <CategoryEntity>[],
      this.errorMessage});

  const CategoryState.initial() : this._();

  const CategoryState.loadInProgress()
      : this._(status: CategoryDataStatus.loading);

  const CategoryState.failureload(String message)
      : this._(status: CategoryDataStatus.failureload, errorMessage: message);

  const CategoryState.loadSuccess({required List<CategoryEntity> categories})
      : this._(categories: categories, status: CategoryDataStatus.success);

  CategoryState copyWith({
    List<CategoryEntity>? categories,
    CategoryDataStatus? status,
    String? errorMessage,
  }) {
    return CategoryState._(
      categories: categories ?? this.categories,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  final List<CategoryEntity> categories;
  final CategoryDataStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [categories, status];
}
