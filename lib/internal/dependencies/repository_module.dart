import 'package:trading/data/repository/app_state_repository_impl.dart';
import 'package:trading/data/repository/category_repository_impl.dart';
import 'package:trading/data/repository/deal_repository_impl.dart';
import 'package:trading/data/repository/price_repository_impl.dart';
import 'package:trading/data/repository/report_repository_impl.dart';
import 'package:trading/data/repository/stock_repository_impl.dart';
import 'package:trading/data/repository/user_repository_imp.dart';
import 'package:trading/domain/repository/app_state_repository.dart';
import 'package:trading/domain/repository/category_repository.dart';
import 'package:trading/domain/repository/deal_repository.dart';
import 'package:trading/domain/repository/price_repository.dart';
import 'package:trading/domain/repository/report_repository.dart';
import 'package:trading/domain/repository/stock_repository.dart';
import 'package:trading/domain/repository/user_repository.dart';
import 'package:trading/internal/dependencies/api_module.dart';

class RepositoryModule {
  RepositoryModule._();

  static final inst = RepositoryModule._();

  UserRepository auth() => UserRepositoryImpl(
      authService: ApiModule.authService,
      cacheUserService: ApiModule.cacheUserService,
      clearCache: ApiModule.clearCache());

  CategoryRepository category(String token) => CategoryRepositoryImpl(
      cacheCategory: ApiModule.cacheCategoryService,
      categoryService: ApiModule.categoryService(token));

  PriceRepository price(String token) =>
      PriceRepositoryImpl(ApiModule.priceService(token));

  ReportRepository report(String token) => ReportRepositoryImpl(
      reportService: ApiModule.reportService(token),
      reportCache: ApiModule.reportCache());

  StockRepository stock(String token) => StockRepositoryImpl(
      stockService: ApiModule.stockService(token),
      stockCache: ApiModule.stockCache());

  DealRepository deal(String token) =>
      DealRepositoryImpl(dealService: ApiModule.dealService(token));

  AppStateRepository appStateRepository() =>
      AppStateRepositoryImpl(stateCache: ApiModule.stateCache());

}
