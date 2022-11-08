import 'package:trading/domain/entitis/user_entity.dart';
import 'package:trading/domain/state/app_state/app_state.dart';
import 'package:trading/domain/state/category/category_bloc.dart';
import 'package:trading/domain/usecases/deal/get_deals.dart';
import 'package:trading/domain/usecases/interface/data_list_operation.dart';
import 'package:trading/domain/usecases/interface/sell_buy_operation.dart';
import 'package:trading/domain/usecases/price/get_all_price.dart';
import 'package:trading/domain/usecases/price/search_price.dart';
import 'package:trading/domain/usecases/report/get_consolidate_report.dart';
import 'package:trading/domain/usecases/report/get_detail_report.dart';
import 'package:trading/domain/usecases/stock/buy_stock.dart';
import 'package:trading/domain/usecases/stock/get_one_stock.dart';
import 'package:trading/domain/usecases/stock/get_stock_category.dart';
import 'package:trading/domain/usecases/stock/get_stock_history.dart';
import 'package:trading/domain/usecases/stock/search_stock_history.dart';
import 'package:trading/domain/usecases/stock/sell_stock.dart';
import 'package:trading/internal/dependencies/repository_module.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:flutter/material.dart';

abstract class Dependency {
  static void authorizationChange(BuildContext context, UserEntity user) {
    if (user.isNotEmpty) {
      _initAuthDependensis(user);
    } else {
      _clearAuthDependensi();
    }
  }

  static init() {
    Di.reg(() => RepositoryModule.inst.auth());
    Di.reg(() => RepositoryModule.inst.appStateRepository());
    Di.reg(
      () => AppState(repository: Di.get()),
    );
  }

  static void _initAuthDependensis(UserEntity user) {
    Di.reg(() => RepositoryModule.inst.category(user.token), asBuilder: true);
    Di.reg(() => RepositoryModule.inst.price(user.token), asBuilder: true);
    Di.reg(() => RepositoryModule.inst.report(user.token), asBuilder: true);
    Di.reg(() => RepositoryModule.inst.stock(user.token), asBuilder: true);
    Di.reg(() => RepositoryModule.inst.deal(user.token), asBuilder: true);

    Di.reg<String>(() => RepositoryModule.inst.imageCashe, name: 'iconURL');

    Di.reg(() => CategoryBloc(categoryRepository: Di.get())
      ..add(const GetAllCategoryEvent()));

    Di.reg<GetDataUC>(() => GetAllPrice(Di.get()),
        name: 'GetAllPrice', asBuilder: true);
    Di.reg<SearchDataUC>(() => SearchPrice(Di.get()),
        name: 'SearchPrice', asBuilder: true);

    Di.reg(() => GetConsolidateReport(Di.get()), asBuilder: true);
    Di.reg(() => GetDetailReport(Di.get()), asBuilder: true);

    Di.reg<GetDataUC>(() => GetStockHistory(Di.get()),
        name: 'GetStockHistory', asBuilder: true);

    Di.reg<SearchDataUC>(() => SearchStockHistory(Di.get()),
        name: 'SearchStockHistory', asBuilder: true);
    Di.reg(() => GetOneStock(Di.get()), asBuilder: true);

    Di.reg(() => GetDeals(Di.get()), name: 'GetDealsList', asBuilder: true);

    Di.reg<SellBuyUC>(() => BuyStock(Di.get()),
        name: 'BuyStock', asBuilder: true);
    Di.reg<SellBuyUC>(() => SellStock(Di.get()),
        name: 'SellStock', asBuilder: true);

    Di.reg(() => GetStockCategory(Di.get()), asBuilder: true);
  }

  static void _clearAuthDependensi() {
    // if (_categoryBloc != null) {
    Di.reset<CategoryBloc>();
    //  _categoryBloc!.close();
    //  }
  }
}
