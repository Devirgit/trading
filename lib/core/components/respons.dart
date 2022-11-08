abstract class Respons<L, R> {
  B result<B>(B Function(L l) ifLeft, B Function(R r) ifRight);
  const Respons();
}

class Left<L, R> extends Respons<L, R> {
  final L _l;
  const Left(this._l);
  L get value => _l;
  @override
  B result<B>(B Function(L l) ifLeft, B Function(R r) ifRight) => ifLeft(_l);
  @override
  bool operator ==(other) => other is Left && other._l == _l;
  @override
  int get hashCode => _l.hashCode;
}

class Right<L, R> extends Respons<L, R> {
  final R _r;
  const Right(this._r);
  R get value => _r;
  @override
  B result<B>(B Function(L l) ifLeft, B Function(R r) ifRight) => ifRight(_r);
  @override
  bool operator ==(other) => other is Right && other._r == _r;
  @override
  int get hashCode => _r.hashCode;
}

typedef ResultFunction<T> = Future<T> Function();

typedef ErrorFunction<E, R> = Future<Respons<E, R>> Function(
    Exception exception);
