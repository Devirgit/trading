import 'package:trading/core/components/respons.dart';
import 'package:trading/core/error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Respons<Failure, Type>> call(Params params);
}

abstract class UseCaseStream<Type, Params> {
  Stream<Respons<Failure, Type>> call(Params params);
}
