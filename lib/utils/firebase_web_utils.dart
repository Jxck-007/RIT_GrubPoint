import 'dart:async';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

/// Handles a JavaScript Promise and converts it to a Dart Future
Future<T> handleThenable<T>(Object jsPromise) {
  final completer = Completer<T>();
  promiseToFuture<T>(jsPromise).then(
    (value) => completer.complete(value),
    onError: (error) => completer.completeError(error),
  );
  return completer.future;
}

/// Converts a Dart object to a JavaScript object
@JS('JSON.parse')
external dynamic parseJson(String json);

@JS('JSON.stringify')
external String stringify(dynamic obj);

/// Converts a Dart Map to a JavaScript object
dynamic jsify(Object dartObject) => parseJson(stringify(dartObject));

/// Converts a JavaScript object to a Dart object
dynamic dartify(Object jsObject) {
  // First convert to JSON string, then parse back to Dart
  return parseJson(stringify(jsObject));
} 