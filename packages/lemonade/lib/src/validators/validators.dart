import 'package:lemonade/src/errors.dart';
import 'package:lemonade/src/validators/compound_validators.dart';
import 'package:lemonade/src/validators/collections_validators.dart';
import 'package:lemonade/src/validators/value_validators.dart';
import 'package:lemonade/src/validators/other_validators.dart';

export 'compound_validators.dart' show CompoundValidator;
export 'collections_validators.dart' show CollectionValidator;
export 'value_validators.dart' show ValueValidator;

abstract class Validator {
  const Validator({required this.annotation});
  
  final String annotation;

  bool validate(dynamic data) {
    return getError(data) == null;
  }

  ValidationError? getError(dynamic data);

  const factory Validator.any() = AnyValidator;

  const factory Validator.nullValue() = NullValidator;

  const factory Validator.equals(Object? matcher) = EqualsValidator;

  factory Validator.number({
    num? min,
    num? max,
    bool? integer,
  }) =>
      NumberValidator(
        min: min,
        max: max,
        integer: false,
      );

  factory Validator.integer({
    int? min,
    int? max,
  }) =>
      NumberValidator(
        min: min,
        max: max,
        integer: true,
      );

  factory Validator.string({
    int? maxLength,
    int? minLength,
    Pattern? pattern,
  }) = StringValidator;

  factory Validator.list({
    Validator item,
    int? maxItems,
    int? minItems,
    bool uniqueItems,
  }) = IterableValidator;

  factory Validator.map({
    Validator key,
    Validator value,
    int? maxItems,
    int? minItems,
  }) = MapValidator;

  factory Validator.object({
    Map<String, Validator> items,
    bool ignoreExtra,
  }) = ObjectValidator;

  factory Validator.or(List<Validator> children) = OrValidator;

  factory Validator.and(List<Validator> children) = AndValidator;

  Validator nullable() => OrValidator([this, const NullValidator()]);

  Validator operator |(Validator other) {
    return OrValidator([this, other]);
  }

  Validator operator &(Validator other) {
    return AndValidator([this, other]);
  }
}
