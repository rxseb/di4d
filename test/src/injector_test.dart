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
    group('.clear()', () {
      test(
        'clears all registered dependencies',
        _testClear,
      );
    });
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
  });
}

void _testInjectorIsSingleton() {
  final injector = Injector();
  final otherInjector = Injector();

  expect(injector, equals(otherInjector));
}

void _testClear() {
  final injector = Injector();
  injector.registerValue(_DummyClass());
  injector.registerLazyValue(() => 1);

  injector.clear();

  expect(
    () => injector.inject<_DummyClass>(),
    throwsA(isA<InjectionException>()),
  );
  expect(
    () => injector.inject<int>(),
    throwsA(isA<InjectionException>()),
  );
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

  injector.unregister<_DummyClass>();

  expect(
    () => injector.inject<_DummyClass>(),
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

void _setUp() {
  setUp(() {
    Injector().clear();
  });
}

class _DummyClass {}
