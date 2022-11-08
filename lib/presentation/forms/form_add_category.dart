import 'package:trading/common/icons.dart';
import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/core/components/input_validator.dart';
import 'package:trading/domain/entitis/category_entity.dart';
import 'package:trading/domain/state/category/form/bloc/category_form_bloc.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/presentation/forms/form.dart';
import 'package:trading/presentation/widgets/button.dart';
import 'package:trading/presentation/widgets/info_dialogs.dart';
import 'package:trading/presentation/widgets/textfild_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModalFormAddCategory extends StatelessWidget {
  const ModalFormAddCategory({Key? key, this.category, this.onSuccess})
      : super(key: key);

  final CategoryEntity? category;
  final SuccessForm<CategoryEntity>? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        if (category != null) {
          return CategoryFormBloc(categoryRepository: Di.get())
            ..add(InitChangeEvent(category!));
        }
        return CategoryFormBloc(categoryRepository: Di.get());
      },
      child: _FormBody(
        category: category,
        onSuccess: onSuccess,
      ),
    );
  }
}

class _FormBody extends StatelessWidget {
  const _FormBody({Key? key, this.category, this.onSuccess}) : super(key: key);

  final CategoryEntity? category;
  final SuccessForm<CategoryEntity>? onSuccess;

  @override
  Widget build(BuildContext context) {
    final title =
        category != null ? UItext.editCategoryTitle : UItext.addCategoryTitle;
    final iconIndex = category?.icon;
    final button =
        category != null ? UItext.editCategoryBtn : UItext.addCategoryBtn;

    return BlocListener<CategoryFormBloc, CategoryFormState>(
      listener: (context, state) {
        switch (state.status) {
          case FormValidStatus.submitInProgress:
            InfoDialogs.beginProcess(context, UItext.savingData);
            break;
          case FormValidStatus.submitSuccess:
            InfoDialogs.endProcess(context);

            if (onSuccess != null) {
              onSuccess!(context, state.successCategory);
            }
            break;
          case FormValidStatus.submitFailure:
            InfoDialogs.endProcess(context);
            break;
          default:
        }
      },
      child: ModalForm(
        child: Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  letterSpacing: 1.25,
                  color: UIColor.formFontColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          _SelectIconCategory(iconIndex ?? 0, onSelect: (value) {
            context.read<CategoryFormBloc>().add(IconChangeEvent(value));
          }),
          const Center(
              child: Text(
            UItext.addCategoryIcon,
            style: TextStyle(color: UIColor.formFontColor),
          )),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _CategoryName(
                initName: category?.name,
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _CategoryCurrency(
                initCurrency: category?.currency,
              )),
          BlocBuilder<CategoryFormBloc, CategoryFormState>(
            buildWhen: (previous, current) {
              return (((previous.status == FormValidStatus.submitFailure) &&
                      current.status != FormValidStatus.submitFailure) ||
                  (current.status == FormValidStatus.submitFailure));
            },
            builder: (context, state) {
              if (state.status == FormValidStatus.submitFailure) {
                return Text(
                  state.errorMessage ?? '',
                  style: TextStyle(color: Colors.red[700]),
                );
              }
              return const SizedBox();
            },
          ),
          Button(
            caption: button,
            onClick: () {
              context.read<CategoryFormBloc>().add(SubmitChangeEvent(
                  category == null
                      ? SubmitFormCategory.create
                      : SubmitFormCategory.change));
            },
          ),
        ]),
      ),
    );
  }
}

class _CategoryName extends StatelessWidget {
  const _CategoryName({Key? key, this.initName}) : super(key: key);

  final String? initName;

  @override
  Widget build(BuildContext context) {
    String? nameError;

    return BlocBuilder<CategoryFormBloc, CategoryFormState>(
      buildWhen: (previous, current) {
        if ((current.status == FormValidStatus.error) &&
            current.name.isNotValid) {
          nameError = current.name.error;
        } else {
          nameError = null;
        }
        return ((current.name.isNotValid) &&
                (current.status == FormValidStatus.error)) ||
            ((current.name != previous.name));
      },
      builder: (context, state) {
        return TextfieldWithLabel(
          label: UItext.addCategoryName,
          fieldName: "addCategoryName",
          hintText: UItext.addCategoryName,
          initialValue: initName,
          error: nameError,
          onChange: (value) =>
              context.read<CategoryFormBloc>().add(NameChangeEvent(value)),
        );
      },
    );
  }
}

class _CategoryCurrency extends StatelessWidget {
  const _CategoryCurrency({Key? key, this.initCurrency}) : super(key: key);

  final String? initCurrency;

  @override
  Widget build(BuildContext context) {
    String? currencyError;
    return BlocBuilder<CategoryFormBloc, CategoryFormState>(
      buildWhen: (previous, current) {
        if ((current.status == FormValidStatus.error) &&
            current.currency.isNotValid) {
          currencyError = current.currency.error;
        } else {
          currencyError = null;
        }
        return ((current.currency.isNotValid) &&
                (current.status == FormValidStatus.error)) ||
            ((current.currency != previous.currency));
      },
      builder: (context, state) {
        return TextfieldWithLabel(
          label: UItext.addCategoryUnits,
          fieldName: "addCategoryUnits",
          hintText: UItext.addCategoryUnitsEx,
          initialValue: initCurrency,
          error: currencyError,
          maxLength: 4,
          onChange: (value) =>
              context.read<CategoryFormBloc>().add(CurrencyChangeEvent(value)),
        );
      },
    );
  }
}

class _SelectIconCategory extends StatefulWidget {
  const _SelectIconCategory(this.selectInitial, {this.onSelect, Key? key})
      : super(key: key);

  final int selectInitial;
  final ValueChanged<int>? onSelect;

  @override
  State<_SelectIconCategory> createState() => _SelectIconCategoryState();
}

class _SelectIconCategoryState extends State<_SelectIconCategory> {
  final double itemWidth = 64.0;
  final int itemCount = 5;
  int? selected;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    selected = widget.selectInitial;
    _controller =
        FixedExtentScrollController(initialItem: widget.selectInitial);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 120,
      height: itemWidth + 20,
      child: RotatedBox(
        quarterTurns: -1,
        child: ListWheelScrollView(
            itemExtent: itemWidth,
            diameterRatio: 1,
            controller: _controller,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (int index) {
              setState(() {
                selected = index;
                if (widget.onSelect != null) {
                  widget.onSelect!(selected ?? 0);
                }
              });
            },
            children: List.generate(UIIcon.iconSet.length, (int index) {
              return RotatedBox(
                quarterTurns: 1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: index == selected ? itemWidth : itemWidth - 10,
                    height: index == selected ? itemWidth : itemWidth - 10,
                    child: Icon(
                      UIIcon.iconSet[index],
                      color:
                          index == selected ? UIColor.h1Color : UIColor.h3Color,
                      size: itemWidth - 10,
                    )),
              );
            })),
      ),
    );
  }
}
