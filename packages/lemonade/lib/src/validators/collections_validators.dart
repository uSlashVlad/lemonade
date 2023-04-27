import 'package:lemonade/src/errors.dart';
import 'package:lemonade/src/validators/other_validators.dart';
import 'package:lemonade/src/validators/validators.dart';

abstract class CollectionValidator extends ValueValidator {
  const CollectionValidator({
    required String collectionName,
    required String itemAnnotation,
  }) : super(typeName: '$collectionName<$itemAnnotation>');
}

class IterableValidator extends CollectionValidator {
  IterableValidator({
    this.item = const AnyValidator(),
    this.maxItems,
    this.minItems,
    this.uniqueItems = false,
  }) : super(collectionName: 'list', itemAnnotation: item.annotation);

  final Validator item;
  final int? maxItems;
  final int? minItems;
  final bool uniqueItems;

  @override
  ValidationError? getError(dynamic data) {
    if (data is! Iterable) return typeError(data);

    if (maxItems != null && data.length > maxItems!) {
      return ValidationError(
        expected: '$annotation length <= $maxItems',
        actual: data,
      );
    }
    if (minItems != null && data.length < minItems!) {
      return ValidationError(
        expected: '$annotation length >= $minItems',
        actual: data,
      );
    }

    if (uniqueItems) {
      final valueSet = <dynamic>{};
      for (final value in data) {
        if (!valueSet.add(value)) {
          return ValidationError(expected: '$annotation unique', actual: data);
        }
      }
    }

    var i = 0;
    for (final value in data) {
      final error = item.getError(value);
      if (error != null) {
        return error.addStep('$annotation[$i]');
      }
      i++;
    }

    return null;
  }
}

class MapValidator extends CollectionValidator {
  MapValidator({
    this.key = const AnyValidator(),
    this.value = const AnyValidator(),
    this.maxItems,
    this.minItems,
  }) : super(
          collectionName: 'map',
          itemAnnotation: '${key.annotation}, ${value.annotation}',
        );

  final Validator key;
  final Validator value;
  final int? maxItems;
  final int? minItems;

  @override
  ValidationError? getError(dynamic data) {
    if (data is! Map) return typeError(data);

    if (maxItems != null && data.length > maxItems!) {
      return ValidationError(
        expected: '$annotation length <= $maxItems',
        actual: data,
      );
    }
    if (minItems != null && data.length < minItems!) {
      return ValidationError(
        expected: '$annotation length >= $minItems',
        actual: data,
      );
    }

    for (final k in data.keys) {
      final keyError = key.getError(k);
      if (keyError != null) {
        return keyError.addStep('$annotation[$k].key');
      }

      final valueError = value.getError(data[k]);
      if (valueError != null) {
        return valueError.addStep('$annotation[$k].value');
      }
    }

    return null;
  }
}

class ObjectValidator extends ValueValidator {
  ObjectValidator({
    this.items = const {},
    this.ignoreExtra = true,
  }) : super(typeName: 'object');

  final Map<String, Validator> items;
  final bool ignoreExtra;

  @override
  ValidationError? getError(dynamic data) {
    if (data is! Map) return typeError(data);

    if (!ignoreExtra && items.length != data.length) {
      return ValidationError(
        expected: '$annotation without extra fields',
        actual: data,
      );
    }

    for (final entry in items.entries) {
      final fieldError = entry.value.getError(data[entry.key]);
      if (fieldError != null) {
        return fieldError.addStep('$annotation.${entry.key}');
      }
    }

    return null;
  }
}
