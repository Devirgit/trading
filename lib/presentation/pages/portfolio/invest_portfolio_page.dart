import 'package:trading/common/ui_text.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/category_entity.dart';
import 'package:trading/domain/state/app_state/app_state.dart';
import 'package:trading/domain/state/category/category_bloc.dart';
import 'package:trading/domain/state/stock/stocks_bloc.dart';
import 'package:trading/domain/usecases/stock/get_stock_category.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/presentation/pages/empty_category.dart';
import 'package:trading/presentation/pages/portfolio/components/stock_card.dart';
import 'package:trading/presentation/widgets/info_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvestPortfolio extends StatelessWidget {
  const InvestPortfolio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CategoryBloc, CategoryState>(
        listenWhen: (previous, current) =>
            current.status == CategoryDataStatus.failure &&
            previous.status != CategoryDataStatus.failure,
        listener: (context, state) {
          if (state.errorMessage != null) {
            InfoDialogs.snackBar(context, state.errorMessage);
          }
        },
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              const SliverAppBar(
                expandedHeight: 50,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(UItext.apptitle),
                ),
                floating: true,
                pinned: false,
              ),
              Builder(builder: (context) {
                final categories =
                    context.watch<CategoryBloc>().state.categories;

                if (categories.isEmpty) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: EmptyCategory(),
                            ),
                        childCount: 1),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: categories.length,
                    (BuildContext context, int index) {
                      return SliverListItem(categories[index]);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverListItem extends StatefulWidget {
  const SliverListItem(this.category, {Key? key}) : super(key: key);

  final CategoryEntity category;

  @override
  State<SliverListItem> createState() => _SliverListItemState();
}

class _SliverListItemState extends State<SliverListItem> {
  late StocksBloc _bloc;

  Stream<RequestBuyStock> _subscribeAppState(CategoryUID uid) {
    final appState = Di.get<AppState>();
    return appState
        .on<RequestBuyStock>()
        .where((event) => (event.categoryUID == uid));
  }

  @override
  void initState() {
    super.initState();

    _bloc = StocksBloc(
        getStock: GetStockCategory(Di.get()),
        buySymbol: _subscribeAppState(widget.category.uid))
      ..add(StocksLoad(widget.category.uid));
  }

  @override
  void dispose() {
    _bloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StockCard(
          widget.category,
        ),
      ),
    );
  }
}
