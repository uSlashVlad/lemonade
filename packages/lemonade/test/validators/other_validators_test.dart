import 'package:lemonade/src/validators/other_validators.dart';
import 'package:test/test.dart';

void main() {
  group('"Any" validator', () {
    test('validate', () {
      final validator = AnyValidator();

      expect(validator.validate(1), true);
      expect(validator.validate('1'), true);
      expect(validator.validate(validator), true);
      expect(validator.validate(null), true);
    });
  });

  group('"Null" validator', () {
    test('validate', () {
      final validator = NullValidator();

      expect(validator.validate(1), false);
      expect(validator.validate('1'), false);
      expect(validator.validate(validator), false);
      expect(validator.validate(null), true);
    });
  });

  group('"Equals" validator', () {
    test('validate', () {
      final numValidator = EqualsValidator(1);

      expect(numValidator.validate(1), true);
      expect(numValidator.validate('1'), false);
      expect(numValidator.validate(2), false);
      expect(numValidator.validate(numValidator), false);
      expect(numValidator.validate(null), false);
    });
  });

  group('"One of" validator', () {
    test('validate', () {
      final numValidator = OneOfValidator({1, 2, 4, 8});

      expect(numValidator.validate(1), true);
      expect(numValidator.validate(2), true);
      expect(numValidator.validate(3), false);
      expect(numValidator.validate('1'), false);
      expect(numValidator.validate(null), false);
    });
  });
}