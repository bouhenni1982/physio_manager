import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network_error.dart';

class ErrorReporter extends StateNotifier<String?> {
  ErrorReporter() : super(null);

  void report(Object error) {
    if (isNetworkError(error)) return;
    state = error.toString();
  }

  void clear() {
    state = null;
  }
}

final errorReporterProvider = StateNotifierProvider<ErrorReporter, String?>((ref) {
  return ErrorReporter();
});
