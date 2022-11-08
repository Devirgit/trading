import 'package:trading/core/components/respons.dart';
import 'package:trading/core/error/crud_server_failure.dart';
import 'package:trading/core/error/exception.dart';
import 'package:trading/core/error/failure.dart';

class TryingData<R> {
  Future<Respons<Failure, R>> get(
    Future<R> Function() get,
  ) async {
    try {
      final result = await get();
      return Right(result);
    } on ServerException catch (e) {
      return Left(CRUDServerFailure.fromType(e.type));
    }
  }
}
