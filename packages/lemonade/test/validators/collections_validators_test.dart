import 'package:lemonade/src/validators/collections_validators.dart';
import 'package:lemonade/src/validators/compound_validators.dart';
import 'package:lemonade/src/validators/other_validators.dart';
import 'package:lemonade/src/validators/value_validators.dart';
import 'package:test/test.dart';

void main() {
  group('"Iterable" validator', () {
    test('Type check', () {
      final validator = IterableValidator();

      expect(validator.validate([1, 2, 3]), true);
      expect(validator.validate([]), true);
      expect(validator.validate({1, 2, 3}), true);
      expect(validator.validate([1, 2, 3].map((e) => e)), true);
      expect(validator.validate({1: 2}), false);
      expect(validator.validate(<int, int>{}), false);
      expect(validator.validate(123), false);
      expect(validator.validate('123'), false);
    });

    test('Null check', () {
      final nonNullableValidator = IterableValidator();

      expect(nonNullableValidator.validate([1, 2, 3]), true);
      expect(nonNullableValidator.validate(null), false);

      final nullableValidator = IterableValidator().nullable();

      expect(nullableValidator.validate([1, 2, 3]), true);
      expect(nullableValidator.validate(null), true);
    });

    test('Item validator', () {
      final validator = IterableValidator(
        item: StringValidator(minLength: 1, maxLength: 3),
      );

      expect(validator.validate([]), true);
      expect(validator.validate(['']), false);
      expect(validator.validate(['1', '12', '123']), true);
      expect(validator.validate(['1', '12', '1234']), false);
      expect(validator.validate([1, 12, 123]), false);
      expect(validator.validate(['1', '12', 123]), false);
    });

    test('Min constrains', () {
      final validator = IterableValidator(minItems: 2);

      expect(validator.validate([]), false);
      expect(validator.validate([1]), false);
      expect(validator.validate([1, 2]), true);
      expect(validator.validate([1, 2, 3]), true);
      expect(validator.validate(List.generate(100, (i) => i)), true);
    });

    test('Max constrains', () {
      final validator = IterableValidator(maxItems: 2);

      expect(validator.validate([]), true);
      expect(validator.validate([1]), true);
      expect(validator.validate([1, 2]), true);
      expect(validator.validate([1, 2, 3]), false);
      expect(validator.validate(List.generate(100, (i) => i)), false);
    });

    test('Both constrains', () {
      final validator = IterableValidator(minItems: 1, maxItems: 3);

      expect(validator.validate([]), false);
      expect(validator.validate([1]), true);
      expect(validator.validate([1, 2]), true);
      expect(validator.validate([1, 2, 3]), true);
      expect(validator.validate([1, 2, 3, 4]), false);
      expect(validator.validate(List.generate(100, (i) => i)), false);
    });

    test('Uniqueness', () {
      final validator = IterableValidator(uniqueItems: true);

      expect(validator.validate({1, 2, 3}), true);
      expect(validator.validate([1, 2, 3]), true);
      // ignore: equal_elements_in_set
      expect(validator.validate({1, 2, 3, 3, 4}), true);
      expect(validator.validate([1, 2, 3, 3, 4]), false);
      expect(validator.validate([1, 2, 3].map((_) => 1)), false);
    });
  });

  group('"Map" validator', () {
    test('Type check', () {
      final validator = MapValidator();

      expect(validator.validate({1: 2, 2: 3}), true);
      expect(validator.validate({}), true);
      expect(validator.validate([1, 2, 3].asMap()), true);
      expect(validator.validate([1, 2, 3]), false);
      expect(validator.validate([1, 2, 3].map((e) => e)), false);
      expect(validator.validate(123), false);
      expect(validator.validate('123'), false);
    });

    test('Null check', () {
      final nonNullableValidator = MapValidator();

      expect(nonNullableValidator.validate({1: 2, 2: 3}), true);
      expect(nonNullableValidator.validate(null), false);

      final nullableValidator = MapValidator().nullable();

      expect(nullableValidator.validate({1: 2, 2: 3}), true);
      expect(nullableValidator.validate(null), true);
    });

    test('Key validator', () {
      final validator = MapValidator(
        key: NumberValidator(integer: false, max: 3),
      );

      expect(validator.validate({1: 20, 2: 30}), true);
      expect(validator.validate({1: null, 2: null, 3: null}), true);
      expect(validator.validate({}), true);
      expect(validator.validate({'1': 20, '2': 30}), false);
      expect(validator.validate({1: 2, 20: 3}), false);
    });

    test('Value validator', () {
      final validator = MapValidator(
        value: NumberValidator(integer: false, max: 3),
      );

      expect(validator.validate({1: 2, 2: 3}), true);
      expect(validator.validate({1: 20, 2: 30}), false);
      expect(validator.validate({1: null, 2: null, 3: null}), false);
      expect(validator.validate({}), true);
      expect(validator.validate({'1': 2, '2': 3}), true);
      expect(validator.validate({1: 20, 20: 3}), false);
    });

    test('Key and value validators', () {
      final validator = MapValidator(
        key: StringValidator(minLength: 1, maxLength: 3),
        value: NumberValidator(integer: false, max: 3).nullable(),
      );

      expect(validator.validate({'1': 2, '2': 3}), true);
      expect(validator.validate({1: 2, 2: 3}), false);
      expect(validator.validate({'1': null, '23': 1, '123': null}), true);
      expect(validator.validate({}), true);
      expect(validator.validate({'1': 2, '2': 3}), true);
      expect(validator.validate({'1': 20, '20': 3}), false);
      expect(validator.validate({1: '2', 2: '3'}), false);
      expect(validator.validate({'1234': 2, '2': 3}), false);
      expect(validator.validate({'1': 20, '2': 3}), false);
    });

    test('Min constrains', () {
      final validator = MapValidator(minItems: 2);

      expect(validator.validate({}), false);
      expect(validator.validate({1: 2}), false);
      expect(validator.validate({1: 2, 2: 3}), true);
      expect(validator.validate({1: 2, 2: 3, 3: 4}), true);
      expect(validator.validate(List.generate(100, (i) => i).asMap()), true);
    });

    test('Max constrains', () {
      final validator = MapValidator(maxItems: 2);

      expect(validator.validate({}), true);
      expect(validator.validate({1: 2}), true);
      expect(validator.validate({1: 2, 2: 3}), true);
      expect(validator.validate({1: 2, 2: 3, 3: 4}), false);
      expect(validator.validate(List.generate(100, (i) => i).asMap()), false);
    });

    test('Both constrains', () {
      final validator = MapValidator(minItems: 1, maxItems: 3);

      expect(validator.validate({}), false);
      expect(validator.validate({1: 2}), true);
      expect(validator.validate({1: 2, 2: 3}), true);
      expect(validator.validate({1: 2, 2: 3, 3: 4}), true);
      expect(validator.validate({1: 2, 2: 3, 3: 4, 4: 5}), false);
      expect(validator.validate(List.generate(100, (i) => i).asMap()), false);
    });
  });

  group('"Object" validator', () {
    test('Type check', () {
      final validator = ObjectValidator();

      expect(validator.validate({1: 2, 2: 3}), true);
      expect(validator.validate({}), true);
      expect(validator.validate([1, 2, 3].asMap()), true);
      expect(validator.validate([1, 2, 3]), false);
      expect(validator.validate([1, 2, 3].map((e) => e)), false);
      expect(validator.validate(123), false);
      expect(validator.validate('123'), false);
    });

    test('Null check', () {
      final nonNullableValidator = ObjectValidator();

      expect(nonNullableValidator.validate({1: 2, 2: 3}), true);
      expect(nonNullableValidator.validate(null), false);

      final nullableValidator = ObjectValidator().nullable();

      expect(nullableValidator.validate({1: 2, 2: 3}), true);
      expect(nullableValidator.validate(null), true);
    });

    test('Items validator (basic)', () {
      final validator = ObjectValidator(
        items: {
          'x': NumberValidator(integer: true),
          'y': NumberValidator(integer: true),
        },
      );

      expect(validator.validate({'x': 1, 'y': 2}), true);
      expect(validator.validate({'x': 1}), false);
      expect(validator.validate({'x': 1, 'y': 2, 'z': 3}), true);
      expect(validator.validate({'x': '1', 'y': '2'}), false);
      expect(validator.validate({'i': 1, 'a': 2}), false);
      expect(validator.validate({'a': 1}), false);
      expect(validator.validate({}), false);
    });

    test('Items validator (complex)', () {
      final countValidator = NumberValidator(
        min: 0,
        integer: true,
      );
      final urlValidator = StringValidator(
        pattern: 'https://rickandmortyapi.com/api/character/?page',
      );
      final validator = ObjectValidator(
        items: {
          'info': ObjectValidator(items: {
            'count': countValidator,
            'pages': countValidator,
            'next': urlValidator,
            'prev': OrValidator([
              urlValidator,
              const NullValidator(),
            ]),
          }),
        },
      );

      expect(
        validator.validate({
          'info': {
            'count': 826,
            'pages': 42,
            'next': 'https://rickandmortyapi.com/api/character/?page=2',
            'prev': null
          }
        }),
        true,
      );
    });

    test('Ignoring extra', () {
      final validator = ObjectValidator(
        items: {
          'a': NumberValidator(integer: false),
          'b': NumberValidator(integer: false),
        },
        ignoreExtra: false,
      );

      expect(validator.validate({'a': 1, 'b': 2}), true);
      expect(validator.validate({'a': 1}), false);
      expect(validator.validate({'a': 1, 'b': 2, 'c': 3}), false);
    });

    test('Ignoring extra on empty', () {
      final validator = ObjectValidator(ignoreExtra: false);

      expect(validator.validate({}), true);
      expect(validator.validate({1: 2}), false);
    });
  });
}
