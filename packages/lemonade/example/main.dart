// ignore_for_file: prefer_const_constructors, avoid_print, avoid_dynamic_calls

import 'dart:convert';

import 'package:lemonade/lemonade.dart';

/// Validator that follows the schema from here
/// https://rickandmortyapi.com/documentation/#get-all-characters
final validator = Validator.object(
  items: {
    'info': Validator.object(
      items: {
        'count': Validator.integer(min: 0),
        'pages': Validator.integer(min: 0),
        'next': Validator.string(),
        'prev': Validator.string().nullable(),
      },
    ),
    'results': Validator.list(
      item: Validator.object(
        items: {
          'id': Validator.integer(min: 1),
          'name': Validator.string(minLength: 1),
          'status': Validator.equals('Alive') |
              Validator.equals('Dead') |
              Validator.equals('Unknown'),
          'species': Validator.string(minLength: 1),
          'type': Validator.string(),
          'gender': Validator.equals('Female') |
              Validator.equals('Male') |
              Validator.equals('Genderless') |
              Validator.equals('unknown'),
          'origin': locationValidator,
          'location': locationValidator,
          'image': Validator.string(),
          'episode': Validator.list(
            item: Validator.string(),
            minItems: 1,
          ),
          'url': Validator.string(),
          'created': Validator.string(),
        },
      ),
    ),
  },
);

/// Validator that follows the schema from here:
/// https://rickandmortyapi.com/documentation/#location-schema
final locationValidator = Validator.object(
  items: {
    'name': Validator.string(minLength: 1),
    'url': Validator.string(),
  },
);

/// Example data that should be validated
const exampleJson = '''
{
  "info": {
    "count": 826,
    "pages": 42,
    "next": "https://rickandmortyapi.com/api/character/?page=2",
    "prev": null
  },
  "results": [
    {
      "id": 1,
      "name": "Rick Sanchez",
      "status": "Alive",
      "species": "Human",
      "type": "",
      "gender": "Male",
      "origin": {
        "name": "Earth",
        "url": "https://rickandmortyapi.com/api/location/1"
      },
      "location": {
        "name": "Earth",
        "url": "https://rickandmortyapi.com/api/location/20"
      },
      "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
      "episode": [
        "https://rickandmortyapi.com/api/episode/1",
        "https://rickandmortyapi.com/api/episode/2"
      ],
      "url": "https://rickandmortyapi.com/api/character/1",
      "created": "2017-11-04T18:48:46.250Z"
    }
  ]
}
''';

void main() {
  final parsedJson = jsonDecode(exampleJson);

  // Everything should be fine here
  final isValid = validator.validate(parsedJson);
  if (isValid) {
    print('Everything is fine');
  } else {
    print('Validation error!');
  }

  print('------------------');

  // Lets break this perfect schema
  parsedJson['results'][0]['type'] = 999;

  // Now here is an error
  final errors = validator.getError(parsedJson);
  print('Errors: $errors');
}
