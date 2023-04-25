import 'package:lemonade/src/validators/compound_validators.dart';
import 'package:lemonade/src/validators/collections_validators.dart';
import 'package:lemonade/src/validators/value_validators.dart';
import 'package:lemonade/src/validators/other_validators.dart';

export 'compound_validators.dart' show CompoundValidator;
export 'collections_validators.dart' show CollectionValidator;
export 'value_validators.dart' show ValueValidator;

abstract class Validator {
  const Validator({required this.expected});

  final String expected;

  bool validate(dynamic data);

  String getValidationError(dynamic data) {
    return '(expected $expected, got $data)';
  }

  const factory Validator.any() = AnyValidator;

  const factory Validator.nullValue() = NullValidator;

  const factory Validator.equals(Object? matcher) = EqualsValidator;

  const factory Validator.oneOf(Iterable<Object?> set) = OneOfValidator;

  factory Validator.number({
    num? min,
    num? max,
    bool? integer,
    bool nullable = false,
  }) =>
      NumberValidator(
        min: min,
        max: max,
        integer: false,
        nullable: nullable,
      );

  factory Validator.integer({
    int? min,
    int? max,
    bool nullable = false,
  }) =>
      NumberValidator(
        min: min,
        max: max,
        integer: true,
        nullable: nullable,
      );

  factory Validator.string({
    int? maxLength,
    int? minLength,
    Pattern? pattern,
    bool nullable,
  }) = StringValidator;

  factory Validator.list({
    Validator item,
    int? maxItems,
    int? minItems,
    bool uniqueItems,
    bool nullable,
  }) = IterableValidator;

  factory Validator.map({
    Validator key,
    Validator value,
    int? maxItems,
    int? minItems,
    bool nullable,
  }) = MapValidator;

  factory Validator.object({
    Map<String, Validator> items,
    bool ignoreExtra,
    bool nullable,
  }) = ObjectValidator;

  factory Validator.or(List<Validator> children) = OrValidator;

  factory Validator.and(List<Validator> children) = AndValidator;

  Validator operator |(Validator other) {
    return OrValidator([this, other]);
  }

  Validator operator &(Validator other) {
    return AndValidator([this, other]);
  }
}
