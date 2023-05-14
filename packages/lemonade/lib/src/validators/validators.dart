import 'package:lemonade/src/errors.dart';
import 'package:lemonade/src/validators/collections_validators.dart';
import 'package:lemonade/src/validators/compound_validators.dart';
import 'package:lemonade/src/validators/other_validators.dart';
import 'package:lemonade/src/validators/value_validators.dart';

export 'collections_validators.dart' show CollectionValidator;
export 'compound_validators.dart' show CompoundValidator;
export 'value_validators.dart' show ValueValidator;

/// Base class for all validators.
/// Also provides constructors for all basics validators.
///
/// You can identify a validator by its [annotation].
abstract class Validator {
  /// Main constructor for [Validator].
  /// Needed to provide [annotation] by subclasses.
  const Validator({required this.annotation});

  /// Matches anything.
  /// Doesn't mind nulls.
  const factory Validator.any() = AnyValidator;

  /// Matches only null values.
  /// Almost equals to `Validator.equals(null)`.
  const factory Validator.nullValue() = NullValidator;

  /// Matches only values that equals to [matcher].
  /// With usage of [Validator.or] can be used to match enum values.
  const factory Validator.equals(Object? matcher) = EqualsValidator;

  /// Matches only values that passed specified [check].
  ///
  /// Should be generally used for custom classes.
  /// Also can be useful in cases when you want validate some very specific
  /// property of default data type.
  /// In second case, it would be very cool to
  /// [fill issue on GitHub](https://github.com/uSlashVlad/lemonade/issues/new/choose),
  /// explaining your use case.
  ///
  /// [check] must return true if data matches what you expect, otherwise false.
  const factory Validator.customValue(bool Function(dynamic data) check) =
      CustomValueValidator;

  /// Converts data using [mapper] and then passes it to [next] validator.
  ///
  /// Can be useful when it is necessary to convert data inside collections or
  /// other complex data structures.
  /// Can also be effectively used with [Validator.customValue] to map custom
  /// classes.
  factory Validator.mapping({
    required Object? Function(dynamic data) mapper,
    required Validator next,
  }) = MapperValidator;

  /// Matches only numbers (both double and integers).
  ///
  /// [min] - minimal number value.
  /// Can be both integer and double.
  /// Anything that less than it, will not pass validation.
  ///
  /// [max] - maximum number value.
  /// Can be both integer and double.
  /// Anything that more than it, will not pass validation.
  ///
  /// If you want to match to only specific number by passing same [min] and
  /// [max] values, then you should use [Validator.equals].
  ///
  /// If you want to match only integer values, you should use
  /// [Validator.integer].
  factory Validator.number({
    num? min,
    num? max,
  }) =>
      NumberValidator(
        min: min,
        max: max,
      );

  /// Matches only integer numbers.
  ///
  /// [min] - minimal number value.
  /// Anything that less than it, will not pass validation.
  ///
  /// [max] - maximum number value.
  /// Anything that more than it, will not pass validation.
  ///
  /// If you want to match to only specific number by passing same [min] and
  /// [max] values, then you should use [Validator.equals].
  ///
  /// If you want to match both integer and double values, you should use
  /// [Validator.number].
  factory Validator.integer({
    int? min,
    int? max,
  }) =>
      NumberValidator(
        min: min,
        max: max,
        integer: true,
      );

  /// Matches only strings.
  ///
  /// [minLength] - minimal string length.
  /// Anything that shorter than it, will not pass validation.
  ///
  /// [maxLength] - maximum string length.
  /// Anything that longer than it, will not pass validation.
  ///
  /// So if you want to match only specific length, you should specify same
  /// [minLength] and [maxLength].
  /// [Validator.equals] won't do the trick for strings.
  ///
  /// [pattern] - string or regex pattern.
  /// If input string has not matched the pattern, will not pass validation.
  /// So if [String] is passed, it will pass if there is at least one occurrence
  /// of [pattern].
  /// If [RegExp] is passed, it will pass if there is at least one regexp match
  /// in input string.
  factory Validator.string({
    int? maxLength,
    int? minLength,
    Pattern? pattern,
  }) = StringValidator;

  /// Matches only [Iterable].
  /// Does not do any assumptions about [Iterable] subclasses.
  /// So it works for [List], [Set], [Queue], [LinkedList] and other classes.
  ///
  /// [item] - validator for each item in input list.
  /// [Validator.any] by default.
  ///
  /// [minItems] - minimum number of items.
  /// Any list that shorter than it, will not pass validation.
  ///
  /// [maxItems] - maximum number of items.
  /// Any list that longer than it, will not pass validation.
  ///
  /// So if you want to match only specific number of items, you should specify
  /// same [minItems] and [maxItems].
  ///
  /// [uniqueItems] - uniqueness of list items.
  /// If true, then each item must be unique.
  factory Validator.list({
    Validator item,
    int? maxItems,
    int? minItems,
    bool uniqueItems,
  }) = IterableValidator;

  /// Matches only [Map].
  /// Works for maps that are returned from [jsonDecode] function.
  ///
  /// [key] - validator for each key in map.
  /// [Validator.any] by default.
  ///
  /// [value] - validator for each value in map.
  /// [Validator.any] by default.
  ///
  /// Firstly tries to match [key], then [value].
  /// Iterates through map by calling [Map.entries].
  ///
  /// [minItems] - minimum number of items.
  /// Any map that shorter than it, will not pass validation.
  ///
  /// [maxItems] - maximum number of items.
  /// Any map that longer than it, will not pass validation.
  ///
  /// So if you want to match only specific number of items, you should specify
  /// same [minItems] and [maxItems].
  factory Validator.map({
    Validator key,
    Validator value,
    int? maxItems,
    int? minItems,
  }) = MapValidator;

  /// Matches only [Map].
  /// Works for maps that are returned from [jsonDecode] function.
  ///
  /// [items] - fields from input map that have to be checked.
  /// It does not check any fields that are not present in [items].
  ///
  /// [ignoreExtra] - if false, will not pass if there is any excess fields in
  /// input map.
  /// true by default.
  factory Validator.object({
    Map<String, Validator> items,
    bool ignoreExtra,
  }) = ObjectValidator;

  /// Matches if any of [children] passes validation.
  /// Similar to "||" operator in boolean expressions.
  ///
  /// Validates in the same order in which they are specified.
  factory Validator.or(List<Validator> children) = OrValidator;

  /// Matches if all of [children] passes validation.
  /// Similar to "&&" operator in boolean expressions.
  ///
  /// Validates in the same order in which they are specified.
  factory Validator.and(List<Validator> children) = AndValidator;

  /// String representation for validator.
  /// Just a type name in the most cases.
  final String annotation;

  /// Validates input data against this validator.
  /// It returns true if validation passes, false otherwise.
  ///
  /// If you want to know, what exactly goes wrong when validation fails, use
  /// [Validator.getError].
  ///
  /// It works with fail-fast principle.
  /// It means that it stops validation on first occurred error.
  /// But in general, it should not make any assumptions about validators order
  /// as much as validators does not make any assumptions about your data.
  bool validate(dynamic data) {
    return getError(data) == null;
  }

  /// Validates input data against this validator.
  /// If validation fails, returns [ValidationError] that describes what
  /// actually does not pass.
  ///
  /// If you want just check if validation passes, use [Validator.validate].
  /// But if you want to debug validator or what is wrong with your data, it
  /// might be the most useful way.
  ///
  /// It works with fail-fast principle.
  /// It means that it stops validation on first occurred error.
  /// But in general, it should not make any assumptions about validators order
  /// as much as validators does not make any assumptions about your data.
  ValidationError? getError(dynamic data);

  /// Matches if either validator or [Validator.nullValue] passes validation.
  ///
  /// In general should be used on any non-nullable validator.
  /// But can be used even on [Validator.nullValue] (which is absolutely
  /// useless).
  Validator nullable() => OrValidator([this, const NullValidator()]);

  /// Matches if either this or [other] passes validation.
  /// Similar to "||" operator in boolean expressions.
  ///
  /// Returns [Validator.or] on 2 validators.
  /// Firstly validates this, then [other].
  Validator operator |(Validator other) {
    return OrValidator([this, other]);
  }

  /// Matches if both this and [other] passes validation.
  /// Similar to "&&" operator in boolean expressions.
  ///
  /// Returns [Validator.and] on 2 validators.
  /// Firstly validates this, then [other].
  Validator operator &(Validator other) {
    return AndValidator([this, other]);
  }
}
