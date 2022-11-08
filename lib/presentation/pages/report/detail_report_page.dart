import 'package:trading/common/icons.dart';
import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/detail_report_entity.dart';
import 'package:trading/domain/state/category/category_bloc.dart';
import 'package:trading/domain/state/report/detail/detail_report_bloc.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/presentation/pages/report/components/box_report_decoration.dart';
import 'package:trading/presentation/pages/report/components/list_tile_report.dart';
import 'package:trading/presentation/widgets/infinite_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DetailReport extends StatelessWidget {
  const DetailReport(this.categoryUid,
      {Key? key, this.endPeriod, this.startPeriod})
      : super(key: key);

  final int categoryUid;
  final DateTime? startPeriod;
  final DateTime? endPeriod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(UItext.reportToSymbol),
        ),
        body: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state.status == CategoryDataStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final date = DateTime.now();
              return _BodyReport(
                categoryUid,
                initEndPeriod: endPeriod ?? date,
                initStartPeriod: startPeriod ??
                    DateTime(date.year, date.month - 1, date.day),
              );
            }
          },
        ));
  }
}

class _BodyReport extends StatelessWidget {
  const _BodyReport(this.categoryUid,
      {required this.initEndPeriod, required this.initStartPeriod, Key? key})
      : super(key: key);

  final DateTime initStartPeriod;
  final DateTime initEndPeriod;

  final int categoryUid;

  @override
  Widget build(BuildContext context) {
    final category = context
        .watch<CategoryBloc>()
        .state
        .categories
        .firstWhere((element) => element.uid == categoryUid);

    return BlocProvider(
      create: (context) => DetailReportBloc(
        report: Di.get(),
      )..add(DetailReportLoadEvent(
          categoryUID: category.uid,
          startPeriod: initStartPeriod,
          endPeriod: initEndPeriod)),
      child: BlocBuilder<DetailReportBloc, DetailReportState>(
        buildWhen: (previous, current) => current != previous,
        builder: (context, state) {
          return BoxReportDecoration(
            icon: Icon(
              UIIcon.iconSet[category.icon],
              size: 32,
              color: UIColor.h1Color,
            ),
            titleHeader: category.name,
            currency: category.currency,
            startPeriod: state.startPeriod ?? initStartPeriod,
            endPeriod: state.endPeriod ?? initEndPeriod,
            onChanged: (start, end) => context.read<DetailReportBloc>().add(
                DetailReportLoadEvent(
                    startPeriod: start,
                    endPeriod: end,
                    categoryUID: category.uid)),
            child: Expanded(
              child: Column(
                children: [
                  const Divider(),
                  const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      UItext.pnlDials,
                      style: TextStyle(
                        color: UIColor.h3Color,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: _ReportList(
                          categoryUID: category.uid,
                          endPeriod: initEndPeriod,
                          startPeriod: initStartPeriod)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReportList extends StatefulWidget {
  const _ReportList(
      {Key? key,
      required this.categoryUID,
      required this.endPeriod,
      required this.startPeriod})
      : super(key: key);

  final DateTime startPeriod;
  final DateTime endPeriod;
  final int categoryUID;

  @override
  State<_ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<_ReportList> {
  late final ValueNotifier<ChangeListState<DetailReportEntity>> _changeState;

  @override
  void initState() {
    super.initState();
    _changeState = ValueNotifier(
        const ChangeListState(items: [], status: LoadDataStatus.empty));
  }

  @override
  void dispose() {
    _changeState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailReportBloc, DetailReportState>(
      listener: (context, state) {
        _changeState.value = ChangeListState(
            items: state.reports,
            status: state.status,
            error: state.errorMessage);
      },
      child: Builder(
        builder: (context) {
          final bloc = context.read<DetailReportBloc>();
          return InfiniteList<DetailReportEntity>(
            onEndScroll: () => bloc.add(const DetailReportMoreEvent()),
            onRefresh: () => bloc.add(DetailReportLoadEvent(
                startPeriod: bloc.state.startPeriod ?? widget.startPeriod,
                endPeriod: bloc.state.endPeriod ?? widget.endPeriod,
                categoryUID: widget.categoryUID)),
            itemBuilder: (context, index, items) =>
                _ReportListItem(items[index]),
            changeState: _changeState,
            separate: const SizedBox(
              width: 1,
            ),
          );
        },
      ),
    );
  }
}

class _ReportListItem extends StatelessWidget {
  const _ReportListItem(this.item, {Key? key}) : super(key: key);
  final DetailReportEntity item;

  @override
  Widget build(BuildContext context) {
    final icon = Di.get<String>(name: 'iconURL') + item.iconUri;

    return ListTileReport(
      icon: Image.network(
        icon,
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          "assets/default/stock.png",
          width: 24,
          height: 24,
        ),
      ),
      onTap: () => context.go('/history/?uid=${item.uid}'),
      title: item.symbol,
      subTitle: item.symbolID,
      cost: item.pnl,
      subTrail: item.deals.toString(),
    );
  }
}
