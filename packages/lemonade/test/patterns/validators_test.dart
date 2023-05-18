import 'package:lemonade/src/patterns/validators.dart';
import 'package:test/test.dart';

void main() {
  group('Validators.alpha()', () {
    test('alpha() returns true for valid input', () {
      final validator = Validators.alpha();
      expect(validator.validate('HelloWorld'), true);
      expect(validator.validate('abcdefghijklmnopqrstuvwxyz'), true);
    });

    test('alpha() returns false for invalid input', () {
      final validator = Validators.alpha();
      expect(validator.validate('Hello World'), false);
      expect(validator.validate('Hello123'), false);
    });
  });

  group('Validators.alphanumeric()', () {
    test('alphanumeric() returns true for valid input', () {
      final validator = Validators.alphanumeric();
      expect(validator.validate('Example123'), true);
      expect(validator.validate('abcdefghijklmnopqrstuvwxyz0123456789'), true);
    });

    test('alphanumeric() returns false for invalid input', () {
      final validator = Validators.alphanumeric();
      expect(validator.validate('Example 123'), false);
      expect(validator.validate('Example!'), false);
    });
  });

  group('Validators.numeric()', () {
    test('numeric() returns true for valid input', () {
      final validator = Validators.numeric();
      expect(validator.validate('123'), true);
      expect(validator.validate('-123'), true);
      expect(validator.validate('3.14'), true);
      expect(validator.validate('-3.14'), true);
    });

    test('numeric() returns false for invalid input', () {
      final validator = Validators.numeric();
      expect(validator.validate('123a'), false);
      expect(validator.validate('12.3.4'), false);
    });
  });

  group('Validators.hexadecimal()', () {
    test('hexadecimal() returns true for valid input', () {
      final validator = Validators.hexadecimal();
      expect(validator.validate('c702f6f5'), true);
      expect(validator.validate('abcdef0123456789'), true);
    });

    test('hexadecimal() returns false for invalid input', () {
      final validator = Validators.hexadecimal();
      expect(validator.validate('c702g6f5'), false);
      expect(validator.validate('hellothere'), false);
    });
  });

  group('Validators.hexcolor()', () {
    test('hexcolor() returns true for valid input', () {
      final validator = Validators.hexcolor();
      expect(validator.validate('#eb0c0c'), true);
      expect(validator.validate('#EEE'), true);
      expect(validator.validate('#abc123'), true);
    });

    test('hexcolor() returns false for invalid input', () {
      final validator = Validators.hexcolor();
      expect(validator.validate('#eb0c0'), false);
      expect(validator.validate('eb0c0c'), false);
      expect(validator.validate('#hellothere'), false);
    });
  });

  group('Validators.email()', () {
    test('email() returns true for valid input', () {
      expect(Validators.email().validate('test@example.com'), true);
      expect(Validators.email().validate('test+filter@example.com'), true);
      expect(Validators.email().validate('test-123@example.com'), true);
      expect(Validators.email().validate('test.123@example.com'), true);
      expect(Validators.email().validate('test@example.co.uk'), true);
      expect(Validators.email().validate('test@example.io'), true);
    });

    test('email() returns false for invalid input', () {
      expect(Validators.email().validate('invalid_email'), false);
      expect(Validators.email().validate('test@example'), false);
      expect(Validators.email().validate('test.@example.com'), false);
      expect(Validators.email().validate('test@example..com'), false);
      expect(Validators.email().validate('test@.example.com'), false);
      expect(Validators.email().validate('.test@example.com'), false);
      expect(Validators.email().validate('test@example.c'), false);
      expect(Validators.email().validate('test@example.'), false);
    });
  });

  group('Validators.base64()', () {
    test('base64() returns true for valid input', () {
      expect(Validators.base64().validate('dGVzdA=='), true);
      expect(Validators.base64().validate('dGVzdA+/'), true);
      expect(Validators.base64().validate('/9j/4AAQSkZJRgABAgEBLAEsAAD/'), true);
      expect(Validators.base64().validate('c29tZSBkYXRhIHdpdGggACBhbmQg77u/'), true);
    });

    test('base64() returns false for invalid input', () {
      expect(Validators.base64().validate('dGVzdA='), false);
      expect(Validators.base64().validate('dGVzdA+=='), false);
      expect(Validators.base64().validate('dGVzdA+/=='), false);
      expect(Validators.base64().validate('dGVzdA+'), false);
      expect(Validators.base64().validate('dGVzdA'), false);
      expect(Validators.base64().validate('test data'), false);
      expect(Validators.base64().validate(r'!@#$'), false);
    });
  });

}
