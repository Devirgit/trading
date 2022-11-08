import 'package:trading/common/icons.dart';
import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/report_entity.dart';
import 'package:trading/domain/state/category/category_bloc.dart';
import 'package:trading/domain/state/report/consolidate/report_bloc.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/presentation/misc/display_transformation.dart';
import 'package:trading/presentation/pages/report/components/box_report_decoration.dart';
import 'package:trading/presentation/widgets/info_dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TradeReport extends StatelessWidget {
  const TradeReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryBloc>().state.categories;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: UItext.back,
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text(UItext.report),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state.status == CategoryDataStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return BlocProvider(
              create: (context) => ReportBloc(
                report: Di.get(),
              ),
              child: Builder(builder: (context) {
                if (categories.isEmpty) {
                  return const _EmptyCategory();
                }
                return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final category = categories[index];
                      context.read<ReportBloc>().add(LoadReport(category.uid));

                      return BlocListener<ReportBloc, ReportState>(
                        listener: (context, state) {
                          if (state.status == LoadDataStatus.failure) {
                            InfoDialogs.snackBar(context, state.errorMessage,
                                key: ValueKey('error-${state.changetItemUID}'));
                          }
                        },
                        child: BlocBuilder<ReportBloc, ReportState>(
                          buildWhen: (previous, current) {
                            return (current.reports[category.uid] != null &&
                                    current.status == LoadDataStatus.success) ||
                                (current.changetItemUID == category.uid) &&
                                    (current.status == LoadDataStatus.loading ||
                                        current.status ==
                                            LoadDataStatus.failure);
                          },
                          builder: (context, state) {
                            final CommonReportEntity? report =
                                state.reports[category.uid];

                            return BoxReportDecoration(
                                startPeriod: report?.startPeriod,
                                endPeriod: report?.endPeriod,
                                titleHeader: category.name,
                                currency: category.currency,
                                icon: Icon(
                                  UIIcon.iconSet[category.icon],
                                  size: 32,
                                  color: UIColor.h1Color,
                                ),
                                onChanged: (start, end) {
                                  context.read<ReportBloc>().add(ChangePerriod(
                                      category.uid,
                                      start: start,
                                      end: end));
                                },
                                child: Column(
                                  children: [
                                    const Divider(),
                                    _BodyReport(
                                      report: report?.report,
                                      status: state.status,
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            context.go(
                                                '/report/${category.uid}?'
                                                'start=${report?.startPeriod}&'
                                                'end=${report?.endPeriod}');
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: const [
                                              Text(UItext.moreToSymbol),
                                              Icon(
                                                Icons.arrow_right,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ));
                          },
                        ),
                      );
                    });
              }),
            );
          }
        },
      ),
    );
  }
}

class _BodyReport extends StatelessWidget {
  const _BodyReport({this.report, required this.status, Key? key})
      : super(key: key);

  final ReportEntity? report;
  final LoadDataStatus status;

  Color _getColors(double? value) {
    if ((value == null) || (value == 0)) return UIColor.fontColor;

    return value > 0
        ? UIColor.positivPositionColor
        : UIColor.negativePositionColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _ReportItem(
          header: UItext.reportFields['all_profit'] ?? '',
          value: status == LoadDataStatus.loading
              ? const _LoadDataItem()
              : report?.allProfit ?? '-',
          colorValue: _getColors(report?.allProfit)),
      _ReportItem(
        header: UItext.reportFields['investing'] ?? '',
        value: status == LoadDataStatus.loading
            ? const _LoadDataItem()
            : report?.investing ?? '-',
      ),
      _ReportItem(
        header: UItext.reportFields['avg_invest'] ?? '',
        value: status == LoadDataStatus.loading
            ? const _LoadDataItem()
            : report?.avgInvest ?? '-',
      ),
      _ReportItem(
          header: UItext.reportFields['max_profit'] ?? '',
          value: status == LoadDataStatus.loading
              ? const _LoadDataItem()
              : report?.maxProfit ?? '-',
          colorValue: _getColors(report?.maxProfit)),
      _ReportItem(
          header: UItext.reportFields['min_profit'] ?? '',
          value: status == LoadDataStatus.loading
              ? const _LoadDataItem()
              : report?.minProfit ?? '-',
          colorValue: _getColors(report?.minProfit)),
      _ReportItem(
          header: UItext.reportFields['sum_positive_pnl'] ?? '',
          value: status == LoadDataStatus.loading
              ? const _LoadDataItem()
              : report?.sumPositivePnl ?? '-',
          colorValue: _getColors(report?.sumPositivePnl)),
      _ReportItem(
          header: UItext.reportFields['sum_negative_pnl'] ?? '',
          value: status == LoadDataStatus.loading
              ? const _LoadDataItem()
              : report?.sumNegativePnl ?? '-',
          colorValue: _getColors(report?.sumNegativePnl)),
      _ReportItem(
          header: UItext.reportFields['avg_positive_pnl'] ?? '',
          value: status == LoadDataStatus.loading
              ? const _LoadDataItem()
              : report?.avgPositivePnl ?? '-',
          colorValue: _getColors(report?.avgPositivePnl)),
      _ReportItem(
          header: UItext.reportFields['avg_negative_pnl'] ?? '',
          value: status == LoadDataStatus.loading
              ? const _LoadDataItem()
              : report?.avgNegativePnl ?? '-',
          colorValue: _getColors(report?.avgNegativePnl)),
    ]);
  }
}

class _LoadDataItem extends StatelessWidget {
  const _LoadDataItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 10,
      height: 10,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: UIColor.primaryColor,
      ),
    );
  }
}

class _ReportItem extends StatelessWidget {
  const _ReportItem(
      {required this.header,
      required this.value,
      this.colorValue = UIColor.fontColor,
      Key? key})
      : super(key: key);

  final String header;
  final dynamic value;
  final Color? colorValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            header,
            style: const TextStyle(color: UIColor.historyFontColor),
          ),
          value is Widget
              ? value
              : Text(
                  value is String
                      ? value
                      : ViewFormat.formatCostDisplay(
                          value as double,
                        ),
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: colorValue),
                ),
        ],
      ),
    );
  }
}

class _EmptyCategory extends StatelessWidget {
  const _EmptyCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxReportDecoration(
      empty: true,
      titleHeader: UItext.emptyCategoryTitle,
      icon: const Icon(Icons.hourglass_empty),
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
                child: Text(
              UItext.emptyCategory,
              textAlign: TextAlign.center,
            )),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              backgroundColor: UIColor.primaryColor,
              onPressed: () => context.go('/profile'),
              child: const Icon(Icons.perm_identity_outlined),
            )
          ],
        ),
      ),
      onChanged: (start, end) {},
    );
  }
}
