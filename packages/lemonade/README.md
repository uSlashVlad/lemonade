# lemonade

[![Pub](https://img.shields.io/pub/v/lemonade.svg)](https://pub.dev/packages/bloc)
[![codecov](https://codecov.io/gh/uSlashVlad/lemonade/branch/main/graph/badge.svg?token=3N68H7WOFF)](https://codecov.io/gh/uSlashVlad/lemonade)

Simple yet powerful library for data validation:
- Fully compile-, type- and null-safe API
- Universal for any standard data structures
- Written in pure dart
- 0 dependencies

Main source of inspiration is JSON Schema and [ajv library](https://www.npmjs.com/package/ajv).

## What is validation?

Validation - is a way to ensure that the data being used by the application is correct and can be used safely.
It means that all properties of object are specified and look the way you would expect.

Let's take an example of JSON data validation:

```json5
// Correct JSON
{
  "name": "John",
  "age": 25,
  "email": "john@example.com"
}
```

```json5
// Incorrect JSON
{
  "name": "John",
  "age": "25", // String instead of number
  "email": "john@example.com"
}
```

If you write a validator for such object, you can 100% sure that data would look like 

## Usage

For example, you want to validate GeoJSON point object that looks like this:

```json
{
    "type": "Point",
    "coordinates": [125.6, 10.1]
}
```

Validator for this schema will look like that:

```dart
final pointsValidator = Validator.object(
  items: {
    // "type": "Point"
    'type': Validator.equals('Point'),
    // "coordinates": [125.6, 10.1]
    'coordinates': Validator.list(
      item: Validator.number(),
      // Length exactly 2
      minItems: 2,
      maxItems: 2,
    ),
  },
);
```

Then you can check if any data looks like with very basic method:

```dart
final decodedData = jsonDecode('{"type":"Point","coordinates":[125.6,10.1]}');

print(pointsValidator.validate(decodedData)); // true
```

If you want to check, what exactly is wrong, you can use `getError` method:

```dart
final wrongData = jsonDecode('{"type":"Point","coordinates":[125.6,"10.1"]}');

print(pointsValidator.getError(wrongData)); // object.coordinates > list<number>[1] > expected(number).got(10.1)
```

String representation of the errors says that:

- In field `"coordinates"`
  - At index `[1]`
    - Expected any number
    - Got `"10.1"`

It's easy to decode and trace an error in your data, isn't it?

## Common patterns

Most of the time you come across some common data types: UUID, IP addresses, hexadecimal strings, etc.
You can easily validate such data using this library!

Here is `Validators` class for this:

```dart
final stringToCheck = 'd87955f3-42a8-43db-aea2-78c0e29e5d23';

Validators.uuid().validate(stringToCheck);
```

It also can be easily used in complex and nested validators:

```dart
final structureToCheck = {
  'ip': '127.0.0.1',
  'mac': '0C:D3:86:34:34:66',
};

final validator = Validator.object(
  items: {
    'ip': Validators.ipv4(),
    'mac': Validators.mac(),
  },
);

validator.validate(structureToCheck);
```

## Custom validators

Sometimes you want to validate some custom data structures (your own classes for example).
lemonade gives you two ways of doing so:

1. Create universal, reusable validator class
2. Use `Validator.customValue` factory

### Universal validator class

lemonade exports some validator abstract classes that you can extend in order to implement custom validators:
`Validator`, `ValueValidator`, `CollectionValidator`, `CompoundValidator`.

Validation work similar way in all of them:
`getError` have to be overridden,
if it returns `null`, data is valid,
if it returns `ValidationError`, data is invalid.
`annotation` have to be specified, so you stringify validator and watch, what does it validate.

`ValidationError` has 2 required fields: `expected` and `actual` (like in dart tests).
In `actual`, you should specify value that was checked.
In `expected`, you should specify the criteria of valid data.

For example, you want to check that number is even.
Firstly you have to check if data is number, then you have to check evenness.
Implementation would look like this:

```dart
class EvennessValidator extends Validator {
  EvennessValidator() : super(annotation: 'even number');

  @override
  ValidationError? getError(dynamic data) {
    if (data is! int) {
      // We expected number, got something else
      return ValidationError(expected: 'number', actual: data);
    }

    if (!data.isEven) {
      // We expected even number, got odd
      return ValidationError(expected: 'even number', actual: data);
    }

    // If everything is ok, return null.
    return null;
  }
}
```

Then you can use it like this:

```dart
// Create a new instance of validator
final validator = EvennessValidator();
// Use default methods of it
validator.validate(14);
```

This approach has major pros:

- Validators look and work the same as the default ones
- Validation errors are more descriptive and customizable
- Validators can be easily reused

But also several cons:

- More customization and overall code required
- It isn't so easy to use for one-time only validators

### Validator.customValue

If you just want to make things done,
you don't need to understand what exactly is invalid
and this validator will be used exactly one time,
than it would be easier to use simple `Validator.customValue` factory.

For validator that checks if number is even code would look like this:

```dart
// Create a new instance of validator
final validator = Validator.customValue((data) {
  if (data is! int) return false;

  if (!data.isEven) return false;

  return true;
});
// Use default methods of it
validator.validate(14);
```

And that's all! So easy!

So this approach has such pros:

- Less code to write
- No customization, tuning, descriptions
- Can use the same callback as for `where` method in `Iterable`

But also there is cons:

- Can't be easily reused
- Results in less consistent code

[//]: # (TODO: Add info about mappers)

## Features and roadmap

I started this project in my own urgent need to write huge amount of JSON validators.
Then I tried to make it more universal, so it can be used in other use cases.

- [x] Validators for the most basic types
- [x] Built-in validators for most common data types
- [x] Built-in validators for custom data structures
- [ ] Full backwards compatibility with JSON Schema
- [ ] Automatic HTTP response validation on client-side
- [ ] Automatic HTTP request validation on server-side
