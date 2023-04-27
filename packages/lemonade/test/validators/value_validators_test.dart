import 'package:lemonade/src/validators/value_validators.dart';
import 'package:test/test.dart';

void main() {
  group('"Number" validator', () {
    group('Double', () {
      test('Type check', () {
        const validator = NumberValidator();

        expect(validator.validate(1), true);
        expect(validator.validate(1.1), true);
        expect(validator.validate('1'), false);
        expect(validator.validate(validator), false);
      });

      test('Null check', () {
        const nonNullableValidator = NumberValidator();

        expect(nonNullableValidator.validate(1.5), true);
        expect(nonNullableValidator.validate(null), false);

        final nullableValidator = const NumberValidator().nullable();

        expect(nullableValidator.validate(1.5), true);
        expect(nullableValidator.validate(null), true);
      });

      test('Min constrains', () {
        const validator = NumberValidator(min: 100);

        expect(validator.validate(10), false);
        expect(validator.validate(99.99), false);
        expect(validator.validate(100), true);
        expect(validator.validate(999), true);
      });

      test('Max constrains', () {
        const validator = NumberValidator(
          max: 100,
        );

        expect(validator.validate(10), true);
        expect(validator.validate(99.99), true);
        expect(validator.validate(100), true);
        expect(validator.validate(999), false);
      });

      test('Both constrains', () {
        const validator = NumberValidator(
          min: 50,
          max: 100,
        );

        expect(validator.validate(-10), false);
        expect(validator.validate(10), false);
        expect(validator.validate(99.99), true);
        expect(validator.validate(100), true);
        expect(validator.validate(999), false);
      });
    });

    group('Integer', () {
      test('Type check', () {
        const validator = NumberValidator(integer: true);

        expect(validator.validate(1), true);
        expect(validator.validate(10), true);
        expect(validator.validate(-5), true);
        expect(validator.validate(1.1), false);
        expect(validator.validate(1.0), false);
        expect(validator.validate('1'), false);
        expect(validator.validate(validator), false);
      });
    });
  });

  group('"String" validator', () {
    test('Type check', () {
      const validator = StringValidator();

      expect(validator.validate('1'), true);
      expect(validator.validate('Hello World'), true);
      expect(validator.validate(1), false);
      expect(validator.validate(true), false);
      expect(validator.validate(validator), false);
    });

    test('Null check', () {
      const nonNullableValidator = StringValidator();

      expect(nonNullableValidator.validate('1'), true);
      expect(nonNullableValidator.validate(null), false);

      final nullableValidator = const StringValidator().nullable();

      expect(nullableValidator.validate('1'), true);
      expect(nullableValidator.validate(null), true);
    });

    test('Min constrains', () {
      const validator = StringValidator(minLength: 3);

      expect(validator.validate('A'), false);
      expect(validator.validate('AAA'), true);
      expect(validator.validate('AAAAA'), true);
    });

    test('Max constrains', () {
      const validator = StringValidator(maxLength: 3);

      expect(validator.validate('A'), true);
      expect(validator.validate('AAA'), true);
      expect(validator.validate('AAAAA'), false);
    });

    test('Both constrains', () {
      const validator = StringValidator(minLength: 3, maxLength: 6);

      expect(validator.validate('A'), false);
      expect(validator.validate('AAA'), true);
      expect(validator.validate('AAAAA'), true);
      expect(validator.validate('AAAAAAA'), false);
    });

    test('String patterns', () {
      const validator = StringValidator(pattern: '123');

      expect(validator.validate('123'), true);
      expect(validator.validate('123123'), true);
      expect(validator.validate('12'), false);
      expect(validator.validate('321'), false);
      expect(validator.validate(''), false);
    });

    test('Regex patterns', () {
      final validator = StringValidator(pattern: RegExp('0x[0-9a-f]{6}'));

      expect(validator.validate('0xa0b1c3'), true);
      expect(validator.validate('0xfedcba'), true);
      expect(validator.validate('0 x 1 2 3 4 5 6'), false);
      expect(validator.validate('123123'), false);
      expect(validator.validate(''), false);
    });
  });
}
