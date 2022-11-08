import 'package:trading/common/ui_text.dart';
import 'package:trading/domain/state/category/category_bloc.dart';
import 'package:trading/presentation/pages/history/trade_history_page.dart';
import 'package:trading/presentation/pages/not_found.dart';
import 'package:trading/presentation/pages/portfolio/invest_portfolio_page.dart';
import 'package:trading/presentation/pages/profile/user_profile_page.dart';
import 'package:trading/presentation/pages/report/detail_report_page.dart';
import 'package:trading/presentation/pages/report/trade_report_page.dart';
import 'package:trading/presentation/pages/search/search_price_pages.dart';
import 'package:trading/presentation/pages/search/search_stock_pages.dart';
import 'package:trading/presentation/route/route_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading/internal/injection/di.dart';

abstract class RoutePageConfig {
//service pages
  static const notFoundPage = PageConfig(
    key: ValueKey('not_found_page'),
    title: UItext.apptitle,
    child: NotFoundPage(),
  );

//navigation bar pages
  static PageConfig rootPage(BuildContext contex,
      [Map<String, String>? params]) {
    return PageConfig(
      key: const ValueKey('portfolio_page'),
      title: UItext.apptitle,
      child: BlocProvider.value(
        value: Di.get<CategoryBloc>(),
        child: const InvestPortfolio(),
      ),
    );
  }

  static PageConfig historyPage({int? symbolID}) => PageConfig(
        key: ValueKey('history_page_$symbolID'),
        title: "${UItext.apptitle} - history",
        child: TradeHistory(
          stockUID: symbolID ?? 0,
        ),
      );

  static PageConfig reportPage() => PageConfig(
        key: const ValueKey('report_page'),
        title: "${UItext.apptitle} - report",
        child: BlocProvider.value(
          value: Di.get<CategoryBloc>(),
          child: const TradeReport(),
        ),
      );

  static PageConfig profilePage() => PageConfig(
      key: const ValueKey('profile_page'),
      title: "${UItext.apptitle} - profile",
      child: BlocProvider.value(
        value: Di.get<CategoryBloc>(),
        child: const UserProfile(key: ValueKey('profile_page')),
      ));

//other pages
  static PageConfig addSymbolPage(int categoryUID) {
    return categoryUID == -1
        ? notFoundPage
        : PageConfig(
            key: ValueKey('add_new_symbol_$categoryUID'),
            title: "${UItext.apptitle} - add symbol",
            type: NaviPageType.slideTransition,
            child: SearchPricePages(categoryUID: categoryUID),
          );
  }

  static const historySymbolSearchPage = PageConfig(
    key: ValueKey('history_search_symbol'),
    title: "${UItext.apptitle} - search symbol",
    type: NaviPageType.slideTransition,
    child: SearchStockPages(key: ValueKey('history_search_symbol')),
  );

  static PageConfig detailReportPage(
    int? categoryUID, [
    DateTime? startPeriod,
    DateTime? endPeriod,
  ]) =>
      categoryUID == null
          ? notFoundPage
          : PageConfig(
              key: const ValueKey('detail_history'),
              title: "${UItext.apptitle} - detail report",
              type: NaviPageType.slideTransition,
              child: BlocProvider.value(
                value: Di.get<CategoryBloc>(),
                child: DetailReport(
                  categoryUID,
                  startPeriod: startPeriod,
                  endPeriod: endPeriod,
                ),
              ),
            );
}

class PageConfig extends NaviPage {
  const PageConfig(
      {required super.child,
      super.key,
      super.title,
      super.fullScreenDialog,
      super.type = NaviPageType.slideRightTransition});
}
