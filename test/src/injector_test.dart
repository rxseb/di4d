import 'package:di4d/src/injector.dart';
import 'package:test/test.dart';

import 'package:di4d/src/injection_exception.dart';

void main() {
  _setUp();
  group('Injector', () {
    test(
      'is a singleton',
      _testInjectorIsSingleton,
    );
    group('.inject()', () {
      test(
        'returns a value when dependency is registered',
        _testInjectWhenDependencyRegistered,
      );
      test(
        'throws an exception when dependency is not registered',
        _testInjectWhenDependencyNotRegistered,
      );
    });
    group('.registerFactory()', () {
      test(
        'registers a factory when a dependency of same type is not registered',
        _testRegisterFactoryWhenDependencyNotRegistered,
      );
      test(
        'throws an exception when a dependency of same type is registered',
        _testRegisterFactoryWhenDependencyRegistered,
      );
    });
    group('.registerLazyValue()', () {
      test(
        'registers a lazy value when a dependency of same type is not registered',
        _testRegisterLazyValueWhenDependencyNotRegistered,
      );
      test(
        'throws an exception when a dependency of same type is registered',
        _testRegisterLazyValueWhenDependencyRegistered,
      );
    });
    group('.registerValue()', () {
      test(
        'registers a value when a dependency of same type is not registered',
        _testRegisterValueWhenDependencyNotRegistered,
      );
      test(
        'throws an exception when a dependency of same type is registered',
        _testRegisterValueWhenDependencyRegistered,
      );
    });
    group('.unregister()', () {
      test(
        'unregisters a dependency when it is registered',
        _testUnregisterWhenDependencyRegistered,
      );
      test(
        'throws an exception when dependency is not registered',
        _testUnregisterWhenDependencyNotRegistered,
      );
    });
    group('.unregisterAll()', () {
      test(
        'unregisters all dependencies',
        _testUnregisterAll,
      );
    });
  });
}

void _testInjectorIsSingleton() {
  final injector = Injector();
  final otherInjector = Injector();

  expect(injector, equals(otherInjector));
}

void _testInjectWhenDependencyRegistered() {
  final injector = Injector();

  injector.registerValue(_DummyClass());
  final injected = injector.inject<_DummyClass>();

  expect(injected, isA<_DummyClass>());
}

void _testInjectWhenDependencyNotRegistered() {
  final injector = Injector();

  expect(
    () => injector.inject<_DummyClass>(),
    throwsA(isA<InjectionException>()),
  );
}

void _testRegisterFactoryWhenDependencyNotRegistered() {
  final injector = Injector();

  injector.registerFactory(() => _DummyClass());
  final value = injector.inject<_DummyClass>();
  final otherValue = injector.inject<_DummyClass>();

  expect(value, isNot(otherValue));
}

void _testRegisterFactoryWhenDependencyRegistered() {
  final injector = Injector();
  injector.registerValue(_DummyClass());

  expect(
    () => injector.registerFactory(() => _DummyClass()),
    throwsA(isA<InjectionException>()),
  );
}

void _testRegisterLazyValueWhenDependencyNotRegistered() {
  final injector = Injector();

  injector.registerLazyValue(() => _DummyClass());
  final value = injector.inject<_DummyClass>();
  final otherValue = injector.inject<_DummyClass>();

  expect(value, equals(otherValue));
}

void _testRegisterLazyValueWhenDependencyRegistered() {
  final injector = Injector();
  injector.registerValue(_DummyClass());

  expect(
    () => injector.registerLazyValue(() => _DummyClass()),
    throwsA(isA<InjectionException>()),
  );
}

void _testRegisterValueWhenDependencyNotRegistered() {
  final injector = Injector();
  final value = _DummyClass();

  injector.registerValue(value);

  expect(injector.inject<_DummyClass>(), equals(value));
}

void _testRegisterValueWhenDependencyRegistered() {
  final injector = Injector();
  injector.registerValue(_DummyClass());

  expect(
    () => injector.registerValue(_DummyClass()),
    throwsA(isA<InjectionException>()),
  );
}

void _testUnregisterWhenDependencyRegistered() {
  final injector = Injector();
  injector.registerValue(_DummyClass());
  injector.registerLazyValue(() => 1);

  injector.unregister<_DummyClass>();
  injector.unregister<int>();

  expect(
    () => injector.inject<_DummyClass>(),
    throwsA(isA<InjectionException>()),
  );
  expect(
    () => injector.inject<int>(),
    throwsA(isA<InjectionException>()),
  );
}

void _testUnregisterWhenDependencyNotRegistered() {
  final injector = Injector();

  expect(
    () => injector.unregister<_DummyClass>(),
    throwsA(isA<InjectionException>()),
  );
}

void _testUnregisterAll() {
  final injector = Injector();
  injector.registerValue(_DummyClass());
  injector.registerLazyValue(() => 1);
  injector.registerFactory(() => 'Hello');

  injector.unregisterAll();

  expect(
    () => injector.inject<_DummyClass>(),
    throwsA(isA<InjectionException>()),
  );
  expect(
    () => injector.inject<int>(),
    throwsA(isA<InjectionException>()),
  );
  expect(
    () => injector.inject<String>(),
    throwsA(isA<InjectionException>()),
  );
}

void _setUp() {
  setUp(() {
    Injector().unregisterAll();
  });
}

class _DummyClass {}
