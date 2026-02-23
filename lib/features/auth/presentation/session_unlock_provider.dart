import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SessionUnlockState { locked, unlocked }

class SessionUnlockNotifier extends StateNotifier<SessionUnlockState> {
  SessionUnlockNotifier() : super(SessionUnlockState.locked);

  void unlock() => state = SessionUnlockState.unlocked;

  void lock() => state = SessionUnlockState.locked;
}

final sessionUnlockProvider =
    StateNotifierProvider<SessionUnlockNotifier, SessionUnlockState>(
  (ref) => SessionUnlockNotifier(),
);
