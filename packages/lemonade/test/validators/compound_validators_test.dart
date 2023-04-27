import 'package:lemonade/src/validators/compound_validators.dart';
import 'package:lemonade/src/validators/other_validators.dart';
import 'package:lemonade/src/validators/value_validators.dart';
import 'package:test/test.dart';

void main() {
  group('"Or" validator', () {
    test('validate on simple', () {
      final validator = OrValidator([
        const EqualsValidator(123),
        const NullValidator(),
      ]);

      expect(validator.validate(123), true);
      expect(validator.validate(null), true);
      expect(validator.validate('123'), false);
      expect(validator.validate(validator), false);
    });

    test('validate on recursive', () {
      final validator = OrValidator([
        const EqualsValidator(123),
        OrValidator([
          const StringValidator(minLength: 1, maxLength: 5),
          const StringValidator(pattern: '111'),
        ]),
      ]);

      expect(validator.validate(123), true);
      expect(validator.validate('123'), true);
      expect(validator.validate('111333111'), true);
      expect(validator.validate(''), false);
      expect(validator.validate(null), false);
      expect(validator.validate(validator), false);
    });
  });

  group('"And" validator', () {
    test('validate on simple', () {
      final validator = AndValidator([
        const NumberValidator(min: 0, max: 100, integer: true),
        const NumberValidator(min: 50, max: 200, integer: true),
      ]);

      expect(validator.validate(-50), false);
      expect(validator.validate(0), false);
      expect(validator.validate(50), true);
      expect(validator.validate(100), true);
      expect(validator.validate(150), false);
      expect(validator.validate(200), false);
    });

    test('validate on recursive', () {
      final validator = AndValidator([
        const StringValidator(minLength: 1, maxLength: 10),
        AndValidator([
          const StringValidator(pattern: '1'),
          StringValidator(pattern: RegExp('^A')),
        ]),
      ]);

      expect(validator.validate(''), false);
      expect(validator.validate('1'), false);
      expect(validator.validate('A1'), true);
      expect(validator.validate('A111111111'), true);
      expect(validator.validate('A1111111111'), false);
      expect(validator.validate('11111'), false);
    });
  });
}
