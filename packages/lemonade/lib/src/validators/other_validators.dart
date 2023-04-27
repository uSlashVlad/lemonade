import 'package:lemonade/src/errors.dart';
import 'package:lemonade/src/validators/validators.dart';

class AnyValidator extends Validator {
  const AnyValidator() : super(annotation: 'any');

  @override
  ValidationError? getError(data) {
    return null;
  }
}

class NullValidator extends Validator {
  const NullValidator() : super(annotation: 'null');

  @override
  ValidationError? getError(data) {
    if (data != null) {
      return ValidationError(expected: 'null', actual: data);
    }

    return null;
  }
}

class EqualsValidator extends Validator {
  const EqualsValidator(this.matcher) : super(annotation: '=$matcher');

  final Object? matcher;

  @override
  ValidationError? getError(data) {
    if (data != matcher) {
      return ValidationError(expected: matcher.toString(), actual: data);
    }

    return null;
  }
}
