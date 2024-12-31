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

  /// Returns a value of type [T].
  ///
  /// Throws a [InjectionException] if no dependency of type [T] is registered.
  T inject<T>() {
    _throwIfNotRegistered(T);
    return _container[T];
  }

  /// Registers a value of type [T] in the injector.
  ///
  /// Throws a [InjectionException] if a dependency of type [T] is already
  /// registered.
  void registerValue<T>(T value) {
    _throwIfRegistered(T);
    _container[T] = value;
  }

  /// Unregisters the dependency of type [T].
  ///
  /// Throws a [InjectionException] if no dependency of type [T] is registered.
  void unregister<T>() {
    _throwIfNotRegistered(T);
    _container.remove(T);
  }

  void _throwIfNotRegistered(Type type) {
    if (!_container.containsKey(type)) {
      throw InjectionException('No dependency registered for type $type');
    }
  }

  void _throwIfRegistered(Type type) {
    if (_container.containsKey(type)) {
      throw InjectionException(
        'A dependency of type $type is already registered',
      );
    }
  }
}
