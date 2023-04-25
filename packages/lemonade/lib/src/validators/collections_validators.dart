import 'package:lemonade/src/validators/other_validators.dart';
import 'package:lemonade/src/validators/validators.dart';

abstract class CollectionValidator extends ValueValidator {
  CollectionValidator({
    required String collectionName,
    required String itemAnnotation,
    required Map<String, dynamic> properties,
  }) : super(
          typeName: '$collectionName of <$itemAnnotation>',
          properties: properties,
        );
}

class IterableValidator extends CollectionValidator {
  IterableValidator({
    this.item = const AnyValidator(),
    this.maxItems,
    this.minItems,
    this.uniqueItems = false,
  }) : super(
          collectionName: 'list',
          itemAnnotation: item.expected,
          properties: {
            'maxItems': maxItems,
            'minItems': minItems,
            'uniqueItems': uniqueItems,
          },
        );

  final Validator item;
  final int? maxItems;
  final int? minItems;
  final bool uniqueItems;

  @override
  bool validate(data) {
    if (data is! Iterable) return false;

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
  }) : super(
          collectionName: 'map',
          itemAnnotation: '${key.expected}, ${value.expected}',
          properties: {
            'maxItems': maxItems,
            'minItems': minItems,
          },
        );

  final Validator key;
  final Validator value;
  final int? maxItems;
  final int? minItems;

  @override
  bool validate(data) {
    if (data is! Map) return false;

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
    this.items = const {},
    this.ignoreExtra = true,
  }) : super(
          typeName: 'object',
          properties: {
            // TODO(uSlashVlad): Add normal annotation for object
            'items': items,
          },
        );

  final Map<String, Validator> items;
  final bool ignoreExtra;

  @override
  bool validate(data) {
    if (data is! Map) return false;

    if (!ignoreExtra && items.length != data.length) return false;

    for (final entry in items.entries) {
      if (!entry.value.validate(data[entry.key])) return false;
    }

    return true;
  }
}
