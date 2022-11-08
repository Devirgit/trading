import 'package:trading/common/ui_text.dart';
import 'package:trading/core/components/input_validator.dart';
import 'package:trading/core/components/validator/input_string.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/category_entity.dart';
import 'package:trading/domain/repository/category_repository.dart';
import 'package:trading/domain/usecases/category/create_new_category.dart';
import 'package:trading/domain/usecases/category/update_category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_extension/stream_extension.dart';

part 'category_form_event.dart';
part 'category_form_state.dart';

const _duration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class CategoryFormBloc extends Bloc<CategoryFormEvent, CategoryFormState> {
  CategoryFormBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(const CategoryFormState()) {
    on<NameChangeEvent>(_onNameChange, transformer: debounce(_duration));
    on<InitChangeEvent>(_onInitChange);
    on<CurrencyChangeEvent>(_onCurrencyChange,
        transformer: debounce(_duration));
    on<IconChangeEvent>(_onIconChange, transformer: debounce(_duration));
    on<SubmitChangeEvent>(_onSubmit);
  }

  final CategoryRepository _categoryRepository;

  Future<void> _onInitChange(
    InitChangeEvent event,
    Emitter<CategoryFormState> emit,
  ) async {
    final name = InputString.dirty(event.category.name);
    final currency = InputString.dirty(event.category.currency);
    final icon = event.category.icon;
    emit(CategoryFormState.initChange(
        uid: event.category.uid, currency: currency, name: name, icon: icon));
  }

  Future<void> _onNameChange(
    NameChangeEvent event,
    Emitter<CategoryFormState> emit,
  ) async {
    final name = InputString.dirty(event.name);
    emit(state.copyWith(
      name: name,
      status: FormValidate.status([name, state.currency]),
    ));
  }

  Future<void> _onCurrencyChange(
    CurrencyChangeEvent event,
    Emitter<CategoryFormState> emit,
  ) async {
    final currency = InputString.dirty(event.currency);
    emit(state.copyWith(
      currency: currency,
      status: FormValidate.status([currency, state.name]),
    ));
  }

  Future<void> _onIconChange(
    IconChangeEvent event,
    Emitter<CategoryFormState> emit,
  ) async {
    emit(state.copyWith(
        iconId: event.iconId,
        status: FormValidate.status([state.currency, state.name])));
  }

  Future<Respons<Failure, CategoryEntity>> _requesUseCase(
      SubmitFormCategory formType) async {
    if (formType == SubmitFormCategory.change) {
      final useCase = UpdateCategory(_categoryRepository);
      return await useCase(CategoryEntity(
          uid: state.uid!,
          name: state.name.value,
          currency: state.currency.value,
          icon: state.iconId));
    }
    final useCase = CreateNewCategory(_categoryRepository);
    return await useCase(
        NewCategory(state.name.value, state.currency.value, state.iconId));
  }

  Future<void> _onSubmit(
    SubmitChangeEvent event,
    Emitter<CategoryFormState> emit,
  ) async {
    if (state.status == FormValidStatus.init) {
      emit(state.copyWith(
          status: FormValidStatus.submitFailure,
          errorMessage: UItext.noChange));
    }
    if (state.status == FormValidStatus.valid) {
      emit(state.copyWith(status: FormValidStatus.submitInProgress));

      final request = await _requesUseCase(event.typeForm);
      request.result(
          (error) => emit(state.copyWith(
              status: FormValidStatus.submitFailure,
              errorMessage: error.message)),
          (category) => emit(CategoryFormState.success(category)));
    } else {
      if (state.status == FormValidStatus.invalid) {
        emit(state.copyWith(status: FormValidStatus.error));
      }
    }
  }
}
