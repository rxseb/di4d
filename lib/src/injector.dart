import 'package:di4d/src/injection_exception.dart';

/// An injector to register dependencies and inject them.
class Injector {
  static Injector? _instance;
  final _container = <Type, dynamic>{};

  Injector._internal();

  /// Returns a singleton instance.
  ///
  /// Calling this constructor multiple time will always return the same
  /// instance.
  factory Injector() => _instance ??= Injector._internal();

  /// Clears all registered dependencies.
  void clear() => _container.clear();

  void registerInstance<T>(T instance) {
    if (_container.containsKey(T)) {
      throw InjectionException('A dependency of type $T is already registered');
    }

    _container[T] = instance;
  }

  T inject<T>() {
    if (!_container.containsKey(T)) {
      throw InjectionException('No dependency registered for type $T');
    }
    return _container[T];
  }
}
