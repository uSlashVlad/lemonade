import 'package:lemonade/src/errors.dart';
import 'package:lemonade/src/validators/validators.dart';

class AnyValidator extends Validator {
  const AnyValidator() : super(annotation: 'any');

  @override
  ValidationError? getError(dynamic data) {
    return null;
  }
}

class NullValidator extends Validator {
  const NullValidator() : super(annotation: 'null');

  @override
  ValidationError? getError(dynamic data) {
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
  ValidationError? getError(dynamic data) {
    if (data != matcher) {
      return ValidationError(expected: matcher.toString(), actual: data);
    }

    return null;
  }
}

class CustomValueValidator extends Validator {
  const CustomValueValidator(this.check) : super(annotation: 'custom value');

  final bool Function(dynamic data) check;

  @override
  ValidationError? getError(dynamic data) {
    if (!check(data)) {
      return ValidationError(expected: annotation, actual: data);
    }

    return null;
  }
}

class MapperValidator extends Validator {
  MapperValidator({required this.mapper, required this.next})
      : super(annotation: next.annotation);

  final Object? Function(dynamic data) mapper;
  final Validator next;

  @override
  ValidationError? getError(dynamic data) => next.getError(mapper(data));
}
