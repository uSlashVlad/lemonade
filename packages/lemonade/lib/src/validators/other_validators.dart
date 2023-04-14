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
