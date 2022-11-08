import 'package:trading/common/icons.dart';
import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/domain/entitis/category_entity.dart';
import 'package:trading/domain/state/auth/auth_bloc.dart';
import 'package:trading/domain/state/category/category_bloc.dart';
import 'package:trading/presentation/forms/form.dart';
import 'package:trading/presentation/forms/form_add_category.dart';
import 'package:trading/presentation/pages/profile/components/more_menu_category.dart';
import 'package:trading/presentation/widgets/box_decor.dart';
import 'package:trading/presentation/widgets/button.dart';
import 'package:trading/presentation/widgets/info_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(UItext.profile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: UItext.back,
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: BoxDecor.header(
                  iconHeader: const Icon(
                    UIIcon.category,
                    size: 32.0,
                    color: UIColor.h1Color,
                  ),
                  header: const Text(
                    UItext.category,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: UIColor.h1Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  action: SizedBox(
                    height: 32.0,
                    width: 32.0,
                    child: FloatingActionButton(
                      heroTag: 'addCategory',
                      backgroundColor: UIColor.primaryColor,
                      onPressed: () {
                        Forms.show(context, ModalFormAddCategory(
                          onSuccess: (formContext, data) {
                            context.read<CategoryBloc>().add(
                                CreateCategoryEvent(
                                    data ?? const CategoryEntity(uid: -1)));
                            Forms.close(context);
                          },
                        ));
                      },
                      child: const Icon(
                        Icons.add,
                        size: 24,
                        color: UIColor.h1Color,
                      ),
                    ),
                  ),
                  child: const _CategoryColection()),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Button(
                caption: UItext.exit,
                width: 200,
                onClick: () {
                  context.read<AuthBloc>().add(AuthLogoutRequest());
                },
                color: UIColor.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryColection extends StatelessWidget {
  const _CategoryColection({Key? key}) : super(key: key);

  Widget successData(List<CategoryEntity> items) {
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _CategoryItems(
            items[index],
            index: index,
          );
        },
      ),
    );
  }

  Widget reloadData(BuildContext context) {
    return Expanded(
      child: Center(
        child: FloatingActionButton(
          onPressed: () {
            context.read<CategoryBloc>().add(const GetAllCategoryEvent());
          },
          backgroundColor: UIColor.primaryColor,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget cirlceProgress() {
    return const Expanded(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state.status == CategoryDataStatus.failure) {
          InfoDialogs.snackBar(context, state.errorMessage);
        }
      },
      child: BlocBuilder<CategoryBloc, CategoryState>(
        buildWhen: (previous, current) {
          return (current.status != CategoryDataStatus.delete) ||
              (current.status != CategoryDataStatus.changing);
        },
        builder: (context, state) {
          switch (state.status) {
            case CategoryDataStatus.failure:
            case CategoryDataStatus.success:
              return successData(state.categories);
            case CategoryDataStatus.failureload:
            case CategoryDataStatus.none:
              return reloadData(context);
            default:
              return cirlceProgress();
          }
        },
      ),
    );
  }
}

class _CategoryItems extends StatelessWidget {
  const _CategoryItems(this.category, {Key? key, required this.index})
      : super(key: key);

  final CategoryEntity category;
  final int index;

  void _editMenu(BuildContext context) {
    Forms.show(
        context,
        ModalFormAddCategory(
          category: category,
          onSuccess: (formContext, data) {
            context.read<CategoryBloc>().add(UpdateCategoryEvent(index,
                category: data ?? const CategoryEntity(uid: -1)));
            Forms.close(context);
          },
        ));
  }

  void _deleteMenu(BuildContext context) {
    context.read<CategoryBloc>().add(DeleteCategoryEvent(index));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                UIIcon.iconSet[category.icon],
                size: 32,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                          color: UIColor.h2Color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          UItext.units,
                          style: TextStyle(
                              color: UIColor.h3Color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          category.currency,
                          style: const TextStyle(
                              color: UIColor.h2Color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 35,
                child: MoreMenuCategory(
                  onSelected: (value) {
                    switch (value) {
                      case MenuCategory.edit:
                        _editMenu(context);
                        break;
                      case MenuCategory.delete:
                        _deleteMenu(context);
                        break;
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
