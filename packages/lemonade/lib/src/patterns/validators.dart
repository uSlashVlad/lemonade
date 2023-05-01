// ignore_for_file: lines_longer_than_80_chars

import 'package:lemonade/src/validators/validators.dart';

/// Utility class containing most common patterns that can be validated.
///
/// Each method returns a new instance of validator.
///
/// Most of the validators was taken from [golang's validator package](https://pkg.go.dev/github.com/go-playground/validator).
abstract class Validators {
  /// This validates that a string value contains ASCII alpha characters only.
  ///
  /// Correct example: "`HelloWorld`"
  static Validator alpha() => _validatorForRegex(r'^[a-z]+$');

  /// This validates that a string value contains ASCII alphanumeric characters
  /// only.
  ///
  /// Correct example: "`Example123`"
  static Validator alphanumeric() => _validatorForRegex(r'^[a-z0-9]+$');

  // TODO(uSlashVlad): Add "Alpha Unicode" validator.

  // TODO(uSlashVlad): Add "Alphanumeric Unicode" validator.

  /// This validates that a string value contains a basic numeric value. basic
  /// excludes exponents etc... for integers or float it returns true.
  static Validator numeric() =>
      _validatorForRegex(r'^[-+]?[0-9]+(?:\.[0-9]+)?$');

  /// This validates that a string value contains a valid hexadecimal.
  ///
  /// Correct example: "`c702f6f5`"
  static Validator hexadecimal() => _validatorForRegex(r'^[0-9a-f]*$');

  /// This validates that a string value contains a valid hex color including
  /// hashtag (#).
  ///
  /// Correct example: "`#eb0c0c`"
  static Validator hexcolor() =>
      _validatorForRegex(r'^#(?:[0-9a-f]{3}|[0-9a-f]{6})$');

  // TODO(uSlashVlad): Add "RGB String" validator.

  // TODO(uSlashVlad): Add "RGBA String" validator.

  // TODO(uSlashVlad): Add "HSL String" validator.

  // TODO(uSlashVlad): Add "HSLA String" validator.

  /// This validates that a string value contains a valid email.
  /// This may not conform to all possibilities of any rfc standard, but neither
  /// does any email provider accept all possibilities.
  static Validator email() => _validatorForRegex(
        r"^(?:(?:(?:(?:[a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\x{00A0}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFEF}])+(?:\.([a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\x{00A0}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFEF}])+)*)|(?:(?:\x22)(?:(?:(?:(?:\x20|\x09)*(?:\x0d\x0a))?(?:\x20|\x09)+)?(?:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\x{00A0}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFEF}])|(?:(?:[\x01-\x09\x0b\x0c\x0d-\x7f]|[\x{00A0}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFEF}]))))*(?:(?:(?:\x20|\x09)*(?:\x0d\x0a))?(\x20|\x09)+)?(?:\x22))))@(?:(?:(?:[a-zA-Z]|\d|[\x{00A0}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFEF}])|(?:(?:[a-zA-Z]|\d|[\x{00A0}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFEF}])(?:[a-zA-Z]|\d|-|\.|~|[\x{00A0}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFEF}])*(?:[a-zA-Z]|\d|[\x{00A0}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFEF}])))\.)+(?:(?:[a-zA-Z]|[\x{00A0}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFEF}])|(?:(?:[a-zA-Z]|[\x{00A0}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFEF}])(?:[a-zA-Z]|\d|-|\.|~|[\x{00A0}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFEF}])*(?:[a-zA-Z]|[\x{00A0}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFEF}])))\.?$",
      );

  // TODO(uSlashVlad): Add "File path" validator.

  // TODO(uSlashVlad): Add "URL String" validator.

  // TODO(uSlashVlad): Add "URI String" validator.

  /// This validates that a string value contains a valid base64 value.
  static Validator base64() => _validatorForRegex(
        r'^(?:[A-Za-z0-9+\\/]{4})*(?:[A-Za-z0-9+\\/]{2}==|[A-Za-z0-9+\\/]{3}=|[A-Za-z0-9+\\/]{4})$',
        caseSensitive: true,
      );

  /// This validates that a string value contains a valid base64 URL safe value
  /// according the the RFC4648 spec.
  static Validator base64Url() => _validatorForRegex(
        r'^(?:[a-z0-9-_]{4})*(?:[a-z0-9-_]{2}==|[a-z0-9-_]{3}=|[a-z0-9-_]{4})$',
      );

  /// This validates that a string value contains a valid bitcoin address.
  /// The format of the string is checked to ensure it matches one of the th`ree
  /// formats P2PKH, P2SH.
  static Validator btcAddress() => _validatorForRegex(
        r'^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$',
        caseSensitive: true,
      );

  /// This validates that a string value contains a valid bitcoin Bech32
  /// address as defined by [bip-0173](https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki).
  static Validator btcAddressBech32() =>
      _validatorForRegex(r'^bc1[02-9ac-hj-np-z]{7,76}$');

  /// This validates that a string value contains a valid ethereum address.
  /// The format of the string is checked to ensure it matches the standard
  /// Ethereum address format.
  static Validator ethAddress() => _validatorForRegex(
        r'^0x[0-9a-fA-F]{40}$',
        caseSensitive: true,
      );

  /// This validates that a string value contains a valid UUID.
  /// Uppercase UUID values will not pass
  static Validator uuid() => _validatorForRegex(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
        caseSensitive: true,
      );

  /// This validates that a string value contains a valid version 3 UUID.
  static Validator uuid3() => _validatorForRegex(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-3[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}$',
        caseSensitive: true,
      );

  /// This validates that a string value contains a valid version 4 UUID.
  static Validator uuid4() => _validatorForRegex(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        caseSensitive: true,
      );

  /// This validates that a string value contains a valid version 5 UUID.
  static Validator uuid5() => _validatorForRegex(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-5[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        caseSensitive: true,
      );

  /// This validates that a string value contains only ASCII characters.
  static Validator ascii() => _validatorForRegex(r'^[\x00-\x7F]*$');

  /// This validates that a string value contains one or more multibyte
  /// characters.
  static Validator multibyte() => _validatorForRegex(r'[^\x00-\x7F]');

  /// This validates that a string value contains a valid latitude.
  static Validator latitudeStr() =>
      _validatorForRegex(r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$');

  /// This validates that a string value contains a valid longitude.
  static Validator longitudeStr() => _validatorForRegex(
      r'^[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$');

  /// This validates that a string value contains a valid U.S. Social Security
  /// Number.
  static Validator ssn() => _validatorForRegex(
        r'^[0-9]{3}[ -]?(0[1-9]|[1-9][0-9])[ -]?([1-9][0-9]{3}|[0-9][1-9][0-9]{2}|[0-9]{2}[1-9][0-9]|[0-9]{3}[1-9])$',
      );

  /// This validates that a string value contains a valid IP Address.
  /// Checks for both IPv4 and IPv6.
  static Validator ip() => ipv4() | ipv6();

  /// This validates that a string value contains a valid v4 IP Address.
  static Validator ipv4() =>
      _validatorForRegex(r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$');

  /// This validates that a string value contains a valid v6 IP Address.
  static Validator ipv6() => _validatorForRegex(
        r'^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$',
        caseSensitive: true,
      );

  /// This validates that a string value contains a valid MAC Address.
  static Validator mac() =>
      _validatorForRegex(r'^[a-f0-9]{2}(:[a-f0-9]{2}){5}$');

  /// This validates that a string value is a valid Hostname according to
  /// [RFC 952](https://tools.ietf.org/html/rfc952).
  static Validator hostnameRFC952() =>
      _validatorForRegex(r'^[a-z][a-z0-9\-\.]+[a-z0-9]$');

  /// This validates that a string value is a valid Hostname according to
  /// [RFC 1123](https://tools.ietf.org/html/rfc1123).
  static Validator hostnameRFC1123() =>
      _validatorForRegex(r'^[a-z0-9][a-z0-9\-\.]+[a-z0-9]$');

  static Validator _validatorForRegex(
    String regex, {
    bool caseSensitive = false,
  }) =>
      Validator.string(
        pattern: RegExp(regex, caseSensitive: caseSensitive),
      );
}
