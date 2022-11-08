import 'package:trading/core/usecase/usecase.dart';
import 'package:trading/domain/entitis/search_params.dart';

abstract class GetDataUC<R> extends UseCase<R, String?> {
  @override
  Future<Respons<Failure, R>> call(String? params);
}

abstract class SearchDataUC<R> extends UseCase<R, SearchParams> {
  @override
  Future<Respons<Failure, R>> call(SearchParams params);
}
