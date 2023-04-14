import 'package:lemonade/src/validators/validators.dart';

abstract class CompoundValidator extends Validator {
  CompoundValidator(this.children, {required String operator})
      : super(expected: _covertChildren(children, operator));

  final List<Validator> children;

  static String _covertChildren(List<Validator> children, String operator) {
    return children.map((e) => '($e)').join(' $operator ');
  }
}

class OrValidator extends CompoundValidator {
  OrValidator(List<Validator> children) : super(children, operator: 'or');

  @override
  bool validate(data) {
    for (final validator in children) {
      if (validator.validate(data)) return true;
    }
    return false;
  }
}

class AndValidator extends CompoundValidator {
  AndValidator(List<Validator> children) : super(children, operator: 'and');

  @override
  bool validate(data) {
    for (final validator in children) {
      if (!validator.validate(data)) return false;
    }
    return true;
  }
}
