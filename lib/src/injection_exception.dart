/// An exception for issues related to dependency injection.
class InjectionException implements Exception {
  /// A message giving more details about the issue.
  final String message;

  InjectionException(this.message);

  @override
  String toString() => 'InjectionException: $message';
}
