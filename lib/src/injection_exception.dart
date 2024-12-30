class InjectionException implements Exception {
  final String message;

  InjectionException(this.message);

  @override
  String toString() => 'InjectionException: $message';
}
