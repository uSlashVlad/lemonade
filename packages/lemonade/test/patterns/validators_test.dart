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
      final validator = Validators.email();
      expect(validator.validate('test@example.com'), true);
      expect(validator.validate('test+filter@example.com'), true);
      expect(validator.validate('test-123@example.com'), true);
      expect(validator.validate('test.123@example.com'), true);
      expect(validator.validate('test@example.co.uk'), true);
      expect(validator.validate('test@example.io'), true);
    });

    test('email() returns false for invalid input', () {
      final validator = Validators.email();
      expect(validator.validate('invalid_email'), false);
      expect(validator.validate('test@example'), false);
      expect(validator.validate('test.@example.com'), false);
      expect(validator.validate('test@example..com'), false);
      expect(validator.validate('test@.example.com'), false);
      expect(validator.validate('.test@example.com'), false);
      expect(validator.validate('test@example.c'), false);
      expect(validator.validate('test@example.'), false);
    });
  });

  group('Validators.base64()', () {
    test('base64() returns true for valid input', () {
      final validator = Validators.base64();
      expect(validator.validate('dGVzdA=='), true);
      expect(validator.validate('dGVzdA+/'), true);
      expect(validator.validate('/9j/4AAQSkZJRgABAgEBLAEsAAD/'), true);
      expect(validator.validate('c29tZSBkYXRhIHdpdGggACBhbmQg77u/'), true);
    });

    test('base64() returns false for invalid input', () {
      final validator = Validators.base64();
      expect(validator.validate('dGVzdA='), false);
      expect(validator.validate('dGVzdA+=='), false);
      expect(validator.validate('dGVzdA+/=='), false);
      expect(validator.validate('dGVzdA+'), false);
      expect(validator.validate('dGVzdA'), false);
      expect(validator.validate('test data'), false);
      expect(validator.validate(r'!@#$'), false);
    });
  });

  group('Validators.base64Url()', () {
    test('returns true for valid input', () {
      final validator = Validators.base64Url();
      expect(validator.validate('aGVsbG8='), true);
      expect(validator.validate('aGVsbG8gd29ybGQ='), true);
    });

    test('returns false for invalid input', () {
      final validator = Validators.base64Url();
      expect(validator.validate('aGVsbG8!*'), false);
      expect(validator.validate('aGVsbG8gd29ybGQ?'), false);
      expect(validator.validate('aGVsbG8gd29ybGQ!'), false);
    });
  });

  group('Validators.btcAddress()', () {
    test('returns true for valid input', () {
      final validator = Validators.btcAddress();
      expect(validator.validate('1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2'), true);
      expect(validator.validate('3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy'), true);
      expect(validator.validate('1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i'), true);
    });

    test('returns false for invalid input', () {
      final validator = Validators.btcAddress();
      expect(validator.validate('Hello World'), false);
      expect(validator.validate('1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN!'), false);
      expect(validator.validate('3J98t1WpEZ73CNmQviecrnyiWrnqRhWNL@'), false);
      expect(validator.validate('1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62#'), false);
    });
  });

  group('Validators.btcAddressBech32()', () {
    test('returns true for valid input', () {
      final validator = Validators.btcAddressBech32();
      expect(
        validator.validate('bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4'),
        true,
      );
      expect(validator.validate('bc1zw508d6qejxtdg4y5r3zarvaryvaxxpcs'), true);
    });

    test('returns false for invalid input', () {
      final validator = Validators.btcAddressBech32();
      expect(validator.validate('Hello World'), false);
      expect(validator.validate('1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2'), false);
      expect(validator.validate('3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy'), false);
    });
  });

  group('Validators.ethAddress()', () {
    test('returns true for valid input', () {
      final validator = Validators.ethAddress();
      expect(
        validator.validate('0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed'),
        true,
      );
      expect(
        validator.validate('0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359'),
        true,
      );
    });

    test('returns false for invalid input', () {
      final validator = Validators.ethAddress();
      expect(validator.validate('Hello World'), false);
      expect(
        validator.validate('0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAedx'),
        false,
      );
      expect(
        validator.validate('5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed'),
        false,
      );
    });
  });

  group('Validators.uuid()', () {
    test('returns true for valid input', () {
      final validator = Validators.uuid();
      expect(validator.validate('67fcbcdf-78a3-4c63-8a3e-7abf7c6a12f9'), true);
      expect(validator.validate('f8e2bfc6-6d2e-4a3e-9f85-75d2f0bb2c04'), true);
    });

    test('returns false for invalid input', () {
      final validator = Validators.uuid();
      expect(validator.validate('67fcbcdf-78a3-4c63-8a3e-7abf7c6a12fg'), false);
      expect(validator.validate('67FCBCDF-78A3-4C63-8A3E-7ABF7C6A12F9'), false);
      expect(validator.validate('67fcbcdf-78a3-4c63-8a3e-7abf7c6a12f'), false);
    });
  });
}
