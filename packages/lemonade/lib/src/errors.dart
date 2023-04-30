/// Main error type for validation errors.
///
/// A [ValidationError] is thrown when a value does not match the expected
/// format or type.
///
/// The following properties are defined:
///
/// - `expected`: a string describing the expected format or type.
/// - `actual`: the actual value that was found.
/// - `trace`: a list of strings describing the steps that led to the validation
/// error.
///
/// The following methods are defined:\
///
/// The `toString` method is also overridden to provide a string representation
/// of the error, which includes the trace and the expected/actual values.
class ValidationError {
  /// Creates a new [ValidationError] instance with the given [expected],
  /// [actual], and [trace] values.
  ///
  /// The [expected] and [actual] values are required, while the [trace] value
  /// is optional and defaults to an empty list.
  ValidationError({
    required this.expected,
    required this.actual,
    this.trace = const [],
  });

  /// The expected format or type.
  final String expected;

  /// The actual value that was found.
  final dynamic actual;

  /// A list of strings describing the steps that led to the validation error.
  final List<String> trace;

  /// Adds a step to the trace and returns a new [ValidationError] instance.
  ///
  /// The `step` parameter describes the step that led to the validation error.
  /// In general should be a parent validator annotation.
  ValidationError addStep(String step) {
    return ValidationError(
      expected: expected,
      actual: actual,
      trace: [step, ...trace],
    );
  }

  /// Returns a string representation of the error, which includes the trace and
  /// the expected/actual values.
  @override
  String toString() {
    final leaf = 'expected($expected).got($actual)';
    return [...trace, leaf].join(' > ');
  }
}
