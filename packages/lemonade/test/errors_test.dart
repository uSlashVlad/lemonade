import 'package:lemonade/src/errors.dart';
import 'package:test/test.dart';

void main() {
  group('Constructor', () {
    test('Simple constructor', () {
      final error = ValidationError(expected: 'string', actual: 1);

      expect(error.expected, 'string');
      expect(error.actual, 1);
    });

    test('Constructor with trace', () {
      final error = ValidationError(
        expected: 'string',
        actual: 1,
        trace: ['list[0]'],
      );

      expect(error.expected, 'string');
      expect(error.actual, 1);
      expect(error.trace, ['list[0]']);
    });
  });

  test('Add step', () {
    var error = ValidationError(expected: 'string', actual: 1);
    expect(error.trace, isEmpty);

    error = error.addStep('list[0]');
    expect(error.trace, ['list[0]']);

    error = error.addStep('object.data');
    expect(error.trace, ['object.data', 'list[0]']);
  });

  group('To String', () {
    test('Simple to String', () {
      final error = ValidationError(expected: 'string', actual: 1);

      expect(error.toString(), 'expected(string).got(1)');
    });

    test('To String with trace', () {
      final error = ValidationError(
        expected: 'string',
        actual: 1,
        trace: ['object.data', 'list[0]'],
      );

      expect(
        error.toString(),
        'object.data > list[0] > expected(string).got(1)',
      );
    });
  });
}
