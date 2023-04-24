import 'package:lemonade/src/validators/validators.dart';

class AnyValidator extends Validator {
  const AnyValidator() : super(expected: 'anything');

  @override
  bool validate(_) => true;
}

class NullValidator extends Validator {
  const NullValidator() : super(expected: 'null');

  @override
  bool validate(data) => data == null;
}

class EqualsValidator extends Validator {
  const EqualsValidator(this.matcher) : super(expected: 'equals $matcher');

  final Object? matcher;

  @override
  bool validate(data) => data == matcher;
}

class OneOfValidator extends Validator {
  const OneOfValidator(this.set) : super(expected: 'one of $set');

  final Iterable<Object?> set;

  @override
  bool validate(data) => set.contains(data);
}
