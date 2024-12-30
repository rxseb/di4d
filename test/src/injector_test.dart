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
    group('.registerInstance()', () {
      test(
        'register an instance',
        _testRegisterInstanceWhenDependencyDoesNotExist,
      );
      test(
        'throws an exception when a dependency for of same type is already registered',
        _testRegisterInstanceWhenDependencyAlreadyExists,
      );
    });
    group('.inject()', () {
      test(
        'returns an instance when dependency is registered',
        _testInjectWhenDependencyRegistered,
      );
      test(
        'throws an exception when dependency is not registered',
        _testInjectWhenDependencyNotRegistered,
      );
    });
    group('.clear()', () {
      test(
        'clears all registered dependencies',
        _testClear,
      );
    });
  });
}

void _testInjectorIsSingleton() {
  final injector = Injector();
  final anotherInjector = Injector();

  expect(injector, equals(anotherInjector));
}

void _testRegisterInstanceWhenDependencyDoesNotExist() {
  final injector = Injector();
  final instance = _DummyClass();

  injector.registerInstance(instance);

  expect(injector.inject<_DummyClass>(), equals(instance));
}

void _testRegisterInstanceWhenDependencyAlreadyExists() {
  final injector = Injector();
  injector.registerInstance(_DummyClass());

  expect(
    () => injector.registerInstance(_DummyClass()),
    throwsA(isA<InjectionException>()),
  );
}

void _testInjectWhenDependencyRegistered() {
  final injector = Injector();

  injector.registerInstance(_DummyClass());
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

void _testClear() {
  final injector = Injector();
  injector.registerInstance(_DummyClass());

  injector.clear();

  expect(
    () => injector.inject<_DummyClass>(),
    throwsA(isA<InjectionException>()),
  );
}

void _setUp() {
  setUp(() {
    Injector().clear();
  });
}

class _DummyClass {}
