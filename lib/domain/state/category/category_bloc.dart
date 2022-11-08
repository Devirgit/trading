import 'package:trading/common/ui_text.dart';
import 'package:trading/core/components/respons.dart';
import 'package:trading/core/error/failure.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/category_entity.dart';
import 'package:trading/domain/repository/category_repository.dart';
import 'package:trading/domain/usecases/category/delete_category.dart';
import 'package:trading/domain/usecases/category/get_categories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(const CategoryState.initial()) {
    on<CategoryEvent>(_onEvent);
  }

  final CategoryRepository _categoryRepository;

  Future<void> _onEvent(
      CategoryEvent event, Emitter<CategoryState> emit) async {
    if (event is DeleteCategoryEvent) return _onDeleteCategory(event, emit);
    if (event is CreateCategoryEvent) return _onCreateCategory(event, emit);
    if (event is UpdateCategoryEvent) return _onUpdateCategory(event, emit);
    if (event is GetAllCategoryEvent) return _onGetAllCategory(event, emit);
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryDataStatus.delete));
    final deleteCategory = DeleteCategory(_categoryRepository);
    final response =
        await deleteCategory(state.categories[event.itemIndex].uid);
    response.result(
        (error) => emit(state.copyWith(
            status: CategoryDataStatus.failure,
            errorMessage: error.message)), (success) {
      final oldcategory = state.categories;
      oldcategory.removeAt(event.itemIndex);
      emit(CategoryState.loadSuccess(categories: oldcategory));
    });
  }

  Future<void> _onCreateCategory(
    CreateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryDataStatus.changing));
    if (event.category.uid < 1) {
      return emit(state.copyWith(
        status: CategoryDataStatus.failure,
        errorMessage: UItext.errorUndefinded,
      ));
    }

    if (state.categories.isEmpty) {
      return emit(CategoryState.loadSuccess(categories: [event.category]));
    }

    final oldCategories = state.categories;
    oldCategories.add(event.category);
    emit(CategoryState.loadSuccess(categories: oldCategories));
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryDataStatus.changing));
    final oldCategories = state.categories;
    oldCategories[event.index] = event.category;
    emit(CategoryState.loadSuccess(categories: oldCategories));
  }

  Future<void> _onGetAllCategory(
    GetAllCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryState.loadInProgress());
    final getCategory = GetCategories(_categoryRepository);
    final respons = getCategory();

    await emit.forEach(
      respons,
      onData: (Respons<Failure, List<CategoryEntity>> data) =>
          data.result((error) {
        if (state.categories.isNotEmpty) {
          return state.copyWith(
              errorMessage: error.message, status: CategoryDataStatus.failure);
        }
        return CategoryState.failureload(error.message);
      }, (categories) => CategoryState.loadSuccess(categories: categories)),
    );
  }
}
