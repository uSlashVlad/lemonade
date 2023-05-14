import 'package:lemonade/src/validators/value_validators.dart';
import 'package:test/test.dart';

void main() {
  group('Number validator', () {
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

  group('String validator', () {
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

  group('DateTime validator', () {
    final templateDates = [
      DateTime(1971, 04, 09),
      DateTime(1973, 06, 17),
      DateTime(1979, 03, 09),
      DateTime(1992, 11, 13),
      DateTime(1995, 05, 06),
      DateTime(2000, 10, 25),
      DateTime(2003, 10, 01),
      DateTime(2008, 07, 24),
      DateTime(2018, 10, 03),
      DateTime(2022, 10, 26),
    ];

    test('Type check', () {
      const validator = DateTimeValidator();

      expect(validator.validate(DateTime.now()), true);
      expect(
        validator.validate(DateTime.fromMillisecondsSinceEpoch(1684090002000)),
        true,
      );
      expect(validator.validate('1684090002'), false);
      expect(validator.validate('2023-05-14T18:46:42+00:00'), false);
      expect(validator.validate(1684090002), false);
      expect(validator.validate(true), false);
      expect(validator.validate(validator), false);
    });

    test('Before time', () {
      final validator = DateTimeValidator(before: DateTime(2002, 12, 09));

      expect(validator.validate(templateDates[0]), true);
      expect(validator.validate(templateDates[1]), true);
      expect(validator.validate(templateDates[2]), true);
      expect(validator.validate(templateDates[3]), true);
      expect(validator.validate(templateDates[4]), true);
      expect(validator.validate(templateDates[5]), true);
      expect(validator.validate(templateDates[6]), false);
      expect(validator.validate(templateDates[7]), false);
      expect(validator.validate(templateDates[8]), false);
      expect(validator.validate(templateDates[9]), false);
    });

    test('After time', () {
      final validator = DateTimeValidator(after: DateTime(1996, 02, 29));

      expect(validator.validate(templateDates[0]), false);
      expect(validator.validate(templateDates[1]), false);
      expect(validator.validate(templateDates[2]), false);
      expect(validator.validate(templateDates[3]), false);
      expect(validator.validate(templateDates[4]), false);
      expect(validator.validate(templateDates[5]), true);
      expect(validator.validate(templateDates[6]), true);
      expect(validator.validate(templateDates[7]), true);
      expect(validator.validate(templateDates[8]), true);
      expect(validator.validate(templateDates[9]), true);
    });

    test('Both time constrains', () {
      final validator = DateTimeValidator(
        before: DateTime(2002, 12, 09),
        after: DateTime(1996, 02, 29),
      );

      expect(validator.validate(templateDates[0]), false);
      expect(validator.validate(templateDates[1]), false);
      expect(validator.validate(templateDates[2]), false);
      expect(validator.validate(templateDates[3]), false);
      expect(validator.validate(templateDates[4]), false);
      expect(validator.validate(templateDates[5]), true);
      expect(validator.validate(templateDates[6]), false);
      expect(validator.validate(templateDates[7]), false);
      expect(validator.validate(templateDates[8]), false);
      expect(validator.validate(templateDates[9]), false);
    });

    test('UTC time', () {
      const validator = DateTimeValidator(utc: true);

      expect(validator.validate(DateTime.now()), false);
      expect(validator.validate(DateTime.now().toUtc()), true);
      expect(
        validator.validate(DateTime.fromMillisecondsSinceEpoch(1684090002000)),
        false,
      );
      expect(
        validator.validate(
          DateTime.fromMillisecondsSinceEpoch(
            1684090002000,
            isUtc: true,
          ),
        ),
        true,
      );
    });

    test('Non UTC time', () {
      const validator = DateTimeValidator(utc: true);

      expect(validator.validate(DateTime.now()), true);
      expect(validator.validate(DateTime.now().toUtc()), false);
      expect(
        validator.validate(DateTime.fromMillisecondsSinceEpoch(1684090002000)),
        true,
      );
      expect(
        validator.validate(
          DateTime.fromMillisecondsSinceEpoch(
            1684090002000,
            isUtc: true,
          ),
        ),
        false,
      );
    });

    // TODO(uSlashVlad): Add tests for "in..." properties.
  });
}
