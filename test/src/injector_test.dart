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
    group('.registerValue()', () {
      test(
        'registers a value',
        _testRegisterValueWhenDependencyDoesNotExist,
      );
      test(
        'throws an exception when a dependency of same type is already registered',
        _testRegisterValueWhenDependencyAlreadyExists,
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
  final anotherInjector = Injector();

  expect(injector, equals(anotherInjector));
}

void _testClear() {
  final injector = Injector();
  injector.registerValue(_DummyClass());

  injector.clear();

  expect(
    () => injector.inject<_DummyClass>(),
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

void _testRegisterValueWhenDependencyDoesNotExist() {
  final injector = Injector();
  final value = _DummyClass();

  injector.registerValue(value);

  expect(injector.inject<_DummyClass>(), equals(value));
}

void _testRegisterValueWhenDependencyAlreadyExists() {
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
