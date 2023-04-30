import 'package:lemonade/src/errors.dart';
import 'package:lemonade/src/validators/validators.dart';

/// A validator that combines multiple [Validator]s using a logical operator
/// such as "and" or "or".
///
/// This class is abstract and should be extended by concrete implementations
/// that define the specific operator used to combine the child validators.
abstract class CompoundValidator extends ValueValidator {
  /// Creates a new [CompoundValidator] with the given [children] validators and
  /// logical [operator].
  ///
  /// The [operator] parameter is required and should be a string representing
  /// the logical operator used to combine the child validators.
  CompoundValidator(this.children, {required String operator})
      : super(typeName: _convertChildren(children, operator));

  /// The child validators that are combined by this [CompoundValidator].
  final List<Validator> children;

  /// Internal helper method that converts the list of [children] into a single
  /// string that represents the child validators joined by the given
  /// [operator].
  static String _convertChildren(List<Validator> children, String operator) {
    return children.map((e) => e.annotation).join(' $operator ');
  }
}


class OrValidator extends CompoundValidator {
  OrValidator(super.children) : super(operator: 'or');

  @override
  ValidationError? getError(dynamic data) {
    for (final validator in children) {
      if (validator.validate(data)) return null;
    }
    return typeError(data);
  }
}

class AndValidator extends CompoundValidator {
  AndValidator(super.children) : super(operator: 'and');

  @override
  ValidationError? getError(dynamic data) {
    for (final validator in children) {
      if (!validator.validate(data)) return typeError(data);
    }
    return null;
  }
}
