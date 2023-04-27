import 'package:lemonade/src/errors.dart';
import 'package:lemonade/src/validators/validators.dart';

abstract class CompoundValidator extends ValueValidator {
  CompoundValidator(this.children, {required String operator})
      : super(typeName: _covertChildren(children, operator));

  final List<Validator> children;

  static String _covertChildren(List<Validator> children, String operator) {
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
