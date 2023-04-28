# lemonade

Simple yet powerful library for data validation:
- Fully compile-, type- and null-safe API
- Universal for any standard data structures
- Written in pure dart
- 0 dependencies

Mainly inspired by semantics of JSON Schema and [ajv](https://www.npmjs.com/package/ajv).

<!--
## Get started 🚀

First, add `lemonade` into `pubspec.yaml` file of your project:

```yaml
dependencies:
  lemonade: ^0.1.0
```

... or with simple command:

```bash
dart pub add lemonade
# or for flutter project:
flutter pub add lemonade
```

Then import it into your dart file:

```dart
import 'package:lemonade/lemonade.dart';
```

And you are ready to go!
-->

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

## Features and roadmap

I started this project in my own urgent need to write huge amount of JSON validators.
Then I tried to make it more universal so it can be used in other use cases.

- [x] Validators for the most basic types
- [ ] Built-in validators for most common data types
- [ ] Built-in validators for custom data structures
- [ ] Full backwards compatibility with JSON Schema
- [ ] Automatic HTTP response validation on client-side
- [ ] Automatic HTTP request validation on server-side
