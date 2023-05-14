import 'package:lemonade/src/validators/other_validators.dart';
import 'package:lemonade/src/validators/value_validators.dart';
import 'package:test/test.dart';

void main() {
  group('Any validator', () {
    test('validate', () {
      const validator = AnyValidator();

      expect(validator.validate(1), true);
      expect(validator.validate('1'), true);
      expect(validator.validate(validator), true);
      expect(validator.validate(null), true);
    });
  });

  group('Null validator', () {
    test('validate', () {
      const validator = NullValidator();

      expect(validator.validate(1), false);
      expect(validator.validate('1'), false);
      expect(validator.validate(validator), false);
      expect(validator.validate(null), true);
    });
  });

  group('Equals validator', () {
    test('validate', () {
      const validator = EqualsValidator(1);

      expect(validator.validate(1), true);
      expect(validator.validate('1'), false);
      expect(validator.validate(2), false);
      expect(validator.validate(validator), false);
      expect(validator.validate(null), false);
    });
  });

  group('Inverting validator', () {
    test('validate', () {
      final validator = const NumberValidator(min: 100).not();

      expect(validator.validate(10), true);
      expect(validator.validate(99.99), true);
      expect(validator.validate(100), false);
      expect(validator.validate(999), false);
    });
  });

  group('Custom value validator', () {
    test('Validate always true', () {
      final validator = CustomValueValidator((data) => true);

      expect(validator.validate(1), true);
      expect(validator.validate('1'), true);
      expect(validator.validate(2), true);
      expect(validator.validate(validator), true);
      expect(validator.validate(null), true);
    });

    test('Validate always false', () {
      final validator = CustomValueValidator((data) => false);

      expect(validator.validate(1), false);
      expect(validator.validate('1'), false);
      expect(validator.validate(2), false);
      expect(validator.validate(validator), false);
      expect(validator.validate(null), false);
    });

    test('Normal validation', () {
      final validator = CustomValueValidator((data) {
        if (data is! int) return false;

        if (!data.isEven) return false;

        return true;
      });

      expect(validator.validate(1), false);
      expect(validator.validate('2'), false);
      expect(validator.validate(2), true);
      expect(validator.validate(3), false);
      expect(validator.validate(4), true);
    });
  });

  group('Mapper validator', () {
    test('String to number validate', () {
      final validator = MapperValidator(
        mapper: (data) {
          if (data is! String) return null;

          return int.tryParse(data);
        },
        next: const NumberValidator(min: 1, max: 10),
      );

      expect(validator.validate(1), false);
      expect(validator.validate('1'), true);
      expect(validator.validate('2.1'), false);
      expect(validator.validate('5'), true);
      expect(validator.validate('-1'), false);
      expect(validator.validate('100'), false);
      expect(validator.validate('Abc'), false);
      expect(validator.validate(null), false);
    });
  });
}
