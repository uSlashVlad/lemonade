## 0.3.0

- Added `mapping`, `customValue` and `datetime` validators
- Added `not` method for inverting any validator

## 0.2.0

- Added most common patterns to use with `Validators` class
- Added more documentation comments

Currently supported this common patterns taken mostly from golang
[validator package](https://pkg.go.dev/github.com/go-playground/validator):
`alpha`, `alphanumeric`, `numeric`, `hexadecimal`, `hexcolor`, `email`,
`base64`, `base64url`, `btcAddress`, `btcAddressBech32`, `ethAddress`, `uuid`,
`uuid3`, `uuid4`, `uuid5`, `ascii`, `multibyte`, `latitudeStr`, `longitudeStr`,
`ssn`, `ip`, `ipv4`, `ipv6`, `mac`, `hostname`, `hostnameRFC1123`.

## 0.1.1

- Added some dartdoc comments
- Fixed example file path
- Exported `ValidationError` class

## 0.1.0

**Initial version**

- Value validators: strings, numbers
- Collection validators: lists, maps
- Object validator
- Nullable type check
- "or", "and" validators. With shorthand operators "|" and "&"
- Additional basic validators: "any", "equals"
