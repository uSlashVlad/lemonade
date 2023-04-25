import 'package:lemonade/src/validators/collections_validators.dart';
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
      final nonNullableValidator = IterableValidator(nullable: false);

      expect(nonNullableValidator.validate([1, 2, 3]), true);
      expect(nonNullableValidator.validate(null), false);

      final nullableValidator = IterableValidator(nullable: true);

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
      final nonNullableValidator = MapValidator(nullable: false);

      expect(nonNullableValidator.validate({1: 2, 2: 3}), true);
      expect(nonNullableValidator.validate(null), false);

      final nullableValidator = MapValidator(nullable: true);

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
        value: NumberValidator(integer: false, max: 3, nullable: true),
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
  });
}
