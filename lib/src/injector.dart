import 'package:di4d/src/injection_exception.dart';

typedef DependencyBuilder<T> = T Function();

/// An injector to register dependencies and inject them.
class Injector {
  static Injector? _instance;
  final _dependencies = <Type, dynamic>{};

  Injector._internal();

  /// Returns a singleton instance.
  ///
  /// Calling this constructor multiple time will always return the same
  /// instance.
  factory Injector() => _instance ??= Injector._internal();

  /// Clears all registered dependencies.
  void clear() {
    _dependencies.clear();
  }

  /// Returns a value of type [T].
  ///
  /// Throws a [InjectionException] if no dependency of type [T] is registered.
  T inject<T>() {
    _throwIfNotRegistered(T);
    if (_dependencies[T] is DependencyBuilder) {
      _dependencies[T] = _dependencies[T]();
    }
    return _dependencies[T];
  }

  /// Registers a lazy value of type [T] in the injector.
  ///
  /// A lazy value is a value which is built only the first time it is
  /// injected. Further injections will reuse the already built value.
  ///
  /// Throws a [InjectionException] if a dependency of type [T] is already
  /// registered.
  void registerLazyValue<T>(DependencyBuilder<T> builder) {
    _throwIfRegistered(T);
    _dependencies[T] = builder;
  }

  /// Registers a value of type [T] in the injector.
  ///
  /// Throws a [InjectionException] if a dependency of type [T] is already
  /// registered.
  void registerValue<T>(T value) {
    _throwIfRegistered(T);
    _dependencies[T] = value;
  }

  /// Unregisters the dependency of type [T].
  ///
  /// Throws a [InjectionException] if no dependency of type [T] is registered.
  void unregister<T>() {
    _throwIfNotRegistered(T);
    _dependencies.remove(T);
  }

  void _throwIfNotRegistered(Type type) {
    if (!_dependencies.containsKey(type)) {
      throw InjectionException('No dependency registered for type $type');
    }
  }

  void _throwIfRegistered(Type type) {
    if (_dependencies.containsKey(type)) {
      throw InjectionException(
        'A dependency of type $type is already registered',
      );
    }
  }
}
