class ValidationError {
  ValidationError({
    required this.expected,
    required this.actual,
    this.trace = const [],
  });

  final String expected;
  final dynamic actual;
  final List<String> trace;

  ValidationError addStep(String step) {
    return ValidationError(
      expected: expected,
      actual: actual,
      trace: [step, ...trace],
    );
  }

  @override
  String toString() {
    final leaf = 'expected($expected, $actual)';
    if (trace.isEmpty) return leaf;
    return '${trace.join('.')}.$leaf';
  }
}
