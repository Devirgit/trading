abstract class InputValidator<Error, Params> {
  const InputValidator._(this.value, [this.pure = true]);
  const InputValidator.pure(Params value) : this._(value);
  const InputValidator.dirty(Params value) : this._(value, false);
  final Params value;
  final bool pure;

  Error? get error => validator(value);
  bool get isValid => validator(value) == null;
  bool get isNotValid => !isValid;
  Error validator(Params value);

  @override
  int get hashCode => value.hashCode ^ pure.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is InputValidator<Error, Params> &&
        other.value == value &&
        other.pure == pure;
  }
}
