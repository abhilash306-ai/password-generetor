import 'package:flutter/foundation.dart';

/// Experiment 10b: Flutter Debugging Tools, Error Handling & Performance Instrumentation
class DebugHelper {
  /// Structured debug logging using Flutter's debugPrint
  static void log(String tag, String message) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String().substring(11, 19);
      debugPrint('[$timestamp][$tag] $message');
    }
  }

  /// Measures execution duration of critical algorithms
  static T measureTime<T>(String operationName, T Function() operation) {
    final stopwatch = Stopwatch()..start();
    try {
      final result = operation();
      stopwatch.stop();
      log('PERF', '$operationName took ${stopwatch.elapsedMicroseconds} μs');
      return result;
    } catch (e, stack) {
      stopwatch.stop();
      log('ERROR', '$operationName failed after ${stopwatch.elapsedMilliseconds} ms: $e');
      if (kDebugMode) {
        debugPrint(stack.toString());
      }
      rethrow;
    }
  }

  /// Global Error Logger for UI error boundaries
  static void initializeGlobalErrorHandlers() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      log('FLUTTER_ERROR', details.exceptionAsString());
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      log('ASYNC_ERROR', error.toString());
      return true;
    };
  }
}
