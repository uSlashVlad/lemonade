// ignore_for_file: prefer_const_constructors, avoid_print, avoid_dynamic_calls

import 'package:lemonade/lemonade.dart';

/// Custom data structure that can't be validated with default validators.
class BookModel {
  BookModel({
    required this.id,
    required this.title,
    required this.author,
  });

  final String id;
  final String title;
  final String author;
}

/// Custom validator created universal way.
class BookValidator extends ValueValidator {
  BookValidator() : super(typeName: 'book');

  // Creating validator for UUID that will be used in getError method.
  final idValidator = Validators.uuid();

  @override
  ValidationError? getError(dynamic data) {
    // Type check. Highly recommended for value validators.
    if (data is! BookModel) return typeError(data);

    // Validating book id using UUID validator.
    if (!idValidator.validate(data.id)) {
      return ValidationError(expected: idValidator.annotation, actual: data.id)
          .addStep('$annotation.id');
    }

    // Validate title.
    if (data.title.isEmpty) {
      return ValidationError(expected: 'non-empty title', actual: data.title)
          .addStep('$annotation.title');
    }

    // Validate author.
    if (data.author.isEmpty) {
      return ValidationError(expected: 'non-empty author', actual: data.author)
          .addStep('$annotation.author');
    }

    // No error = everything is ok.
    return null;
  }
}

void main() {
  final newBook = BookModel(
    id: 'c6174f13-529c-49a2-ab02-2099b865fa21',
    title: 'The Lord of the Rings',
    author: 'J.R.R. Tolkien',
  );

  // When you create class and specify all validation inside getError method,
  // you can validate with it like with any other lemonade validator.
  final universalValidator = BookValidator();
  print(
    'Validates book universal way = ${universalValidator.validate(newBook)}',
  );

  // But you can do it simpler, less universal way.
  final simplerValidator = Validator.customValue((data) {
    // Type check
    if (data is! BookModel) return false;

    // Check if id is valid UUID.
    if (!Validators.uuid().validate(data.id)) return false;

    // Check title.
    if (data.title.isEmpty) return false;

    // Check author.
    if (data.author.isEmpty) return false;

    return true;
  });
  print('Validates book simple way = ${simplerValidator.validate(newBook)}');
}
