import 'package:trading/data/api/interface/auth_service_interface.dart';
import 'package:trading/data/api/interface/deal_service_interface.dart';
import 'package:trading/data/api/interface/price_service_interface.dart';
import 'package:trading/data/api/interface/report_service_interface.dart';
import 'package:trading/data/api/interface/stock_service_interface.dart';
import 'package:trading/data/api/beget/beget_auth_service.dart';
import 'package:trading/data/api/beget/beget_category_service.dart';
import 'package:trading/data/api/interface/category_service_interface.dart';
import 'package:trading/data/api/beget/beget_deal_service.dart';
import 'package:trading/data/api/beget/beget_price_service.dart';
import 'package:trading/data/api/beget/beget_report_service.dart';
import 'package:trading/data/api/beget/beget_stock_service.dart';
import 'package:trading/data/cache/hive/hive_category_cache.dart';
import 'package:trading/data/cache/hive/hive_clear_cache.dart';
import 'package:trading/data/cache/hive/hive_report_cache.dart';
import 'package:trading/data/cache/hive/hive_state_cache.dart';
import 'package:trading/data/cache/hive/hive_stock_cache.dart';
import 'package:trading/data/cache/interface/report_cache_interface.dart';
import 'package:trading/data/cache/interface/category_cache_interface.dart';
import 'package:trading/data/cache/interface/state_cache_interface.dart';
import 'package:trading/data/cache/interface/stock_cache_interface.dart';
import 'package:trading/data/cache/interface/user_cache_interface.dart';
import 'package:trading/data/cache/interface/clear_cache_interface.dart';
import 'package:trading/data/cache/secure_cache_user.dart';

class ApiModule {
  static CacheUserService cacheUserService = SecureCacheUserService();

  static AuthService authService = BegetAuthService();

  static CategoryService categoryService(String token) =>
      BegetCategoryService(token);

  static PriceService priceService(String token) => BegetPriceService(token);

  static ReportService reportService(String token) => BegetReportService(token);

  static StockService stockService(String token) => BegetStockService(token);

  static DealService dealService(String token) => BegetDealService(token);

  static StockCache stockCache() => HiveStockCache();

  static StateCache stateCache() => HiveStateCache();

  static ReportCache reportCache() => HiveReportCache();

  static ClearCache clearCache() => HiveClearCache();

  static CategoryCache cacheCategoryService = HiveCategoryCache();
}
