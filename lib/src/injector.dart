import 'package:di4d/src/injection_exception.dart';

typedef DependencyBuilder<T> = T Function();

/// An injector to register dependencies and inject them.
///
/// Dependencies are registered using [registerValue], [registerLazyValue] or
/// [registerFactory] methods. Then [inject] returns them.
///
/// A specific dependency can be unregistered with [unregister]. All
/// dependencies are unregistered at once using [unregisterAll].
///
/// This class is a singleton. The constructor always returns the same instance.
class Injector {
  static Injector? _instance;
  final _dependencies = <Type, dynamic>{};

  Injector._internal();

  /// Returns a singleton instance.
  ///
  /// Calling this constructor multiple time will always return the same
  /// instance.
  factory Injector() => _instance ??= Injector._internal();

  /// Returns a value of type [T].
  ///
  /// Throws a [InjectionException] if no dependency of type [T] is registered.
  T inject<T>() {
    _throwIfNotRegistered(T);
    if (_dependencies[T] is _Factory<T>) {
      return _dependencies[T].builder();
    }
    if (_dependencies[T] is _LazyValue<T>) {
      _dependencies[T] = _dependencies[T].builder();
    }
    return _dependencies[T];
  }

  /// Registers a factory of type [T].
  ///
  /// Any call to [inject] will always return a new value built by [factory].
  ///
  /// Throws a [InjectionException] if a dependency of type [T] is already
  /// registered.
  void registerFactory<T>(DependencyBuilder<T> factory) {
    _throwIfRegistered(T);
    _dependencies[T] = _Factory(factory);
  }

  /// Registers a lazy value of type [T].
  ///
  /// A lazy value is a value which is built by [builder] only at the first call
  /// to [inject]. Further calls to [inject] will always return the already
  /// built value.
  ///
  /// Throws a [InjectionException] if a dependency of type [T] is already
  /// registered.
  void registerLazyValue<T>(DependencyBuilder<T> builder) {
    _throwIfRegistered(T);
    _dependencies[T] = _LazyValue(builder);
  }

  /// Registers a value of type [T].
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

  /// Unregisters all dependencies.
  void unregisterAll() => _dependencies.clear();

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

class _Factory<T> {
  final DependencyBuilder<T> builder;

  _Factory(this.builder);
}

class _LazyValue<T> {
  final DependencyBuilder<T> builder;

  _LazyValue(this.builder);
}
