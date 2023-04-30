import 'package:lemonade/src/errors.dart';
import 'package:lemonade/src/validators/validators.dart';

/// An abstract class representing a validator for strict types.
abstract class ValueValidator extends Validator {
  /// Creates a new [ValueValidator] instance with the given [typeName] as
  /// validator annotation.
  const ValueValidator({required String typeName})
      : super(annotation: typeName);

  /// Creates a [ValidationError] object with the expected and actual types.
  ///
  /// This function is used in subclasses when the input data does not match the
  /// expected type. It creates a [ValidationError] object with the expected and
  /// actual types, which can be used to provide detailed error messages to the
  /// user.
  ///
  /// Returns the created [ValidationError] object.
  ValidationError? typeError(dynamic data) {
    return ValidationError(expected: annotation, actual: data);
  }
}

class NumberValidator extends ValueValidator {
  const NumberValidator({
    this.min,
    this.max,
    this.integer = false,
  }) : super(typeName: integer ? 'integer' : 'number');

  // TODO(uSlashVlad): Add "multipleOf" property
  final num? min;
  final num? max;
  final bool integer;

  @override
  ValidationError? getError(data) {
    if (data is! num) return typeError(data);

    if (integer && data is! int) return typeError(data);

    if (min != null && data < min!) {
      return ValidationError(expected: '$annotation >= $min', actual: data);
    }
    if (max != null && data > max!) {
      return ValidationError(expected: '$annotation <= $max', actual: data);
    }

    return null;
  }
}

class StringValidator extends ValueValidator {
  const StringValidator({
    this.maxLength,
    this.minLength,
    this.pattern,
  }) : super(typeName: 'string');

  final int? maxLength;
  final int? minLength;
  final Pattern? pattern;

  @override
  ValidationError? getError(dynamic data) {
    if (data is! String) return typeError(data);

    if (minLength != null && data.length < minLength!) {
      return ValidationError(
        expected: '$annotation length >= $minLength',
        actual: data,
      );
    }
    if (maxLength != null && data.length > maxLength!) {
      return ValidationError(
        expected: '$annotation length <= $maxLength',
        actual: data,
      );
    }

    if (pattern != null && pattern!.allMatches(data).isEmpty) {
      final strPattern =
          pattern is RegExp ? (pattern! as RegExp).pattern : pattern.toString();
      return ValidationError(
        expected: '$annotation matches $strPattern',
        actual: data,
      );
    }

    return null;
  }
}
