import 'package:lemonade/src/validators/other_validators.dart';
import 'package:lemonade/src/validators/validators.dart';

abstract class CollectionValidator extends ValueValidator {
  CollectionValidator({
    required String collectionName,
    required String itemAnnotation,
    required Map<String, dynamic> properties,
    required bool nullable,
  }) : super(
          typeName: '$collectionName of <$itemAnnotation>',
          properties: properties,
          nullable: nullable,
        );
}

class IterableValidator extends CollectionValidator {
  IterableValidator({
    this.item = const AnyValidator(),
    this.maxItems,
    this.minItems,
    this.uniqueItems = false,
    bool nullable = false,
  }) : super(
          collectionName: 'list',
          itemAnnotation: item.expected,
          properties: {
            'maxItems': maxItems,
            'minItems': minItems,
            'uniqueItems': uniqueItems,
          },
          nullable: nullable,
        );

  final Validator item;
  final int? maxItems;
  final int? minItems;
  final bool uniqueItems;

  @override
  bool validate(data) {
    if (data is! Iterable?) return false;

    if (isViolatesNull(data)) return false;
    if (data == null) return true;

    if (maxItems != null && data.length > maxItems!) return false;
    if (minItems != null && data.length < minItems!) return false;

    if (uniqueItems) {
      final valueSet = <dynamic>{};
      for (final value in data) {
        if (!valueSet.add(value)) return false;

        if (!item.validate(value)) return false;
      }
    } else {
      for (final value in data) {
        if (!item.validate(value)) return false;
      }
    }

    return true;
  }
}

class MapValidator extends CollectionValidator {
  MapValidator({
    this.key = const AnyValidator(),
    this.value = const AnyValidator(),
    this.maxItems,
    this.minItems,
    bool nullable = false,
  }) : super(
          collectionName: 'map',
          itemAnnotation: '${key.expected}, ${value.expected}',
          properties: {
            'maxItems': maxItems,
            'minItems': minItems,
          },
          nullable: nullable,
        );

  final Validator key;
  final Validator value;
  final int? maxItems;
  final int? minItems;

  @override
  bool validate(data) {
    if (data is! Map?) return false;

    if (isViolatesNull(data)) return false;
    if (data == null) return true;

    if (maxItems != null && data.length > maxItems!) return false;
    if (minItems != null && data.length < minItems!) return false;

    for (final k in data.keys) {
      if (!key.validate(k)) return false;
      if (!value.validate(data[k])) return false;
    }

    return true;
  }
}

class ObjectValidator extends ValueValidator {
  ObjectValidator({
    required this.items,
    this.maxItems,
    this.minItems,
    this.ignoreExtra = true,
    bool nullable = false,
  }) : super(
          typeName: 'object',
          properties: {
            'items': items,
            'maxItems': maxItems,
            'minItems': minItems,
          },
          nullable: nullable,
        );

  final Map<String, Validator> items;
  final int? maxItems;
  final int? minItems;
  final bool ignoreExtra;

  @override
  bool validate(data) {
    if (data is! Map?) return false;

    if (isViolatesNull(data)) return false;
    if (data == null) return true;

    if (maxItems != null && data.length > maxItems!) return false;
    if (minItems != null && data.length < minItems!) return false;

    for (final key in data.keys) {
      if (key is! String) return false;

      if (!ignoreExtra && !items.containsKey(key)) return false;

      if (!(items[key]?.validate(data) ?? true)) return false;
    }

    return true;
  }
}
