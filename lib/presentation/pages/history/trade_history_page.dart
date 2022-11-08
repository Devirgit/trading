import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/deal_entity.dart';
import 'package:trading/domain/state/app_state/app_state.dart';
import 'package:trading/domain/state/deals/deals_bloc.dart';
import 'package:trading/domain/state/history/history_bloc.dart';
import 'package:trading/presentation/pages/history/components/common_data_history.dart';
import 'package:trading/presentation/pages/history/components/history_items.dart';
import 'package:trading/presentation/widgets/choic_button_bar.dart';
import 'package:trading/presentation/widgets/infinite_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:go_router/go_router.dart';

class TradeHistory extends StatelessWidget {
  const TradeHistory({Key? key, this.stockUID = 0}) : super(key: key);

  final int stockUID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: UItext.back,
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text(UItext.history),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: UItext.search,
            onPressed: () {
              context.go('/history/search');
            },
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                DealsBloc(getAllData: Di.get(name: 'GetDealsList')),
          ),
          BlocProvider(
            create: (context) => StockHistoryBloc(getStock: Di.get())
              ..add(LoadStockHistory(stockUID)),
          )
        ],
        child: Column(
          children: [
            _HeaderHistory(stockUID),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        UItext.dateDo,
                        style: TextStyle(
                          color: UIColor.h3Color,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(UItext.endAction,
                            style: TextStyle(
                                color: UIColor.h3Color, fontSize: 12.0)),
                      )),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(UItext.detals,
                          style: TextStyle(
                              color: UIColor.h3Color, fontSize: 12.0)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            //history grid
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: _DealsListHistory(
                stockUID: stockUID,
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _HeaderHistory extends StatelessWidget {
  const _HeaderHistory(this.stockUID, {Key? key}) : super(key: key);

  final int stockUID;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StockHistoryBloc, StockHistoryState>(
      listenWhen: (previous, current) =>
          (current.status == LoadDataStatus.success) && (current.stock != null),
      listener: (context, state) {
        context.read<DealsBloc>().add(LoadDealsEvent(state.stock!.uid));
      },
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<StockHistoryBloc, StockHistoryState>(
                builder: (context, state) {
                  return CommonDataHistory(
                    stock: state.stock,
                    onChange: (value) {
                      context
                          .read<StockHistoryBloc>()
                          .add(ChangeStockHistory(value));
                      context
                          .read<DealsBloc>()
                          .add(ReloadDealsEvent(value.uid));
                      Di.get<AppState>().add(ChangeStock(
                          categoryUID: value.categoryUID, stock: value));
                    },
                  );
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              ChoicButtonBar(
                onSelect: (index) {
                  context
                      .read<DealsBloc>()
                      .add(FilterDealsEvent(stockUID, index));
                },
                actionButton: const [
                  ChoicButton(
                    caption: 'ALL',
                  ),
                  ChoicButton(
                    caption: 'BUY',
                  ),
                  ChoicButton(
                    caption: 'SALE',
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class _DealsListHistory extends StatefulWidget {
  const _DealsListHistory({Key? key, required this.stockUID}) : super(key: key);

  final int stockUID;

  @override
  State<_DealsListHistory> createState() => _DealsListHistoryState();
}

class _DealsListHistoryState extends State<_DealsListHistory> {
  late final ValueNotifier<ChangeListState<DealEntity>> _changeState;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _changeState = ValueNotifier(
        const ChangeListState(items: [], status: LoadDataStatus.empty));
  }

  @override
  void dispose() {
    _controller.dispose();
    _changeState.dispose();
    super.dispose();
  }

  DealType _filter(int index) {
    return index == 1 ? DealType.buy : DealType.sell;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DealsBloc, DealsState>(
      listenWhen: (previous, current) {
        if (previous.filterIndex != current.filterIndex) {
          if (_controller.hasClients) {
            _controller.jumpTo(0);
          }
        }
        return previous != current;
      },
      listener: (context, state) {
        List<DealEntity>? list;
        if (state.filterIndex != 0) {
          list = state.items
              .where((item) => item.type == _filter(state.filterIndex))
              .toList();
        }
        _changeState.value = ChangeListState(
            items: list ?? state.items,
            status: state.status,
            error: state.errorMessage);
      },
      child: Builder(
        builder: (context) {
          final bloc = context.read<DealsBloc>();
          return InfiniteList<DealEntity>(
              controller: _controller,
              onEndScroll: () => bloc.add(LoadDealsEvent(widget.stockUID)),
              onRefresh: () => bloc.add(LoadDealsEvent(widget.stockUID)),
              separate: const SizedBox(
                height: 5,
              ),
              itemBuilder: (context, index, items) =>
                  HistoryItems(items[index]),
              changeState: _changeState);
        },
      ),
    );
  }
}
