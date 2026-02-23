import 'dart:io';

bool isNetworkError(Object error) {
  if (error is SocketException) return true;
  final message = error.toString().toLowerCase();
  if (message.contains('failed host lookup')) return true;
  if (message.contains('socketexception')) return true;
  if (message.contains('errno = 7')) return true;
  if (message.contains('no address associated with hostname')) return true;
  return false;
}
