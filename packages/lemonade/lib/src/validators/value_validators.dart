import 'package:lemonade/src/validators/validators.dart';

abstract class ValueValidator extends Validator {
  ValueValidator({
    required String typeName,
    required Map<String, dynamic> properties,
    required this.nullable,
  }) : super(
          expected: '$typeName ${_convertProperties(properties)}'
              ', ${nullable ? 'nullable' : 'non-nullable'}',
        );

  final bool nullable;

  bool isViolatesNull(dynamic data) {
    return !nullable && data == null;
  }

  static String _convertProperties(Map<String, dynamic> properties) {
    final strings = <String>[];

    for (final key in properties.keys) {
      final value = properties[key];
      if (value != null) {
        strings.add('$key=$value');
      }
    }

    if (strings.isEmpty) {
      return 'simple';
    }
    return 'with ${strings.join(', ')}';
  }
}

class NumberValidator extends ValueValidator {
  NumberValidator({
    this.min,
    this.max,
    required this.integer,
    bool nullable = false,
  }) : super(
          typeName: integer ? 'integer' : 'number',
          properties: {'min': min, 'max': max},
          nullable: nullable,
        );

  // TODO(uSlashVlad): Add "multipleOf" property
  final num? min;
  final num? max;
  final bool integer;

  @override
  bool validate(data) {
    if (data is! num?) return false;

    if (isViolatesNull(data)) return false;
    if (data == null) return true;

    if (integer && data is! int) {
      return false;
    }

    if (min != null && data < min!) return false;
    if (max != null && data > max!) return false;

    return true;
  }
}

class StringValidator extends ValueValidator {
  StringValidator({
    this.maxLength,
    this.minLength,
    this.pattern,
    bool nullable = false,
  }) : super(
          typeName: 'string',
          properties: {
            'maxLength': maxLength,
            'minLength': minLength,
            'pattern': pattern
          },
          nullable: nullable,
        );

  final int? maxLength;
  final int? minLength;
  final Pattern? pattern;

  @override
  bool validate(data) {
    if (data is! String?) return false;

    if (isViolatesNull(data)) return false;
    if (data == null) return true;

    if (maxLength != null && data.length > maxLength!) return false;
    if (minLength != null && data.length > minLength!) return false;

    if (pattern != null && pattern!.allMatches(data).isEmpty) return false;

    return true;
  }
}
