import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityState { online, offline, syncing }

class ConnectivityStateNotifier extends StateNotifier<ConnectivityState> {
  ConnectivityStateNotifier() : super(ConnectivityState.syncing);

  void setState(ConnectivityState state) {
    this.state = state;
  }
}

final connectivityStatusProvider =
    StateNotifierProvider<ConnectivityStateNotifier, ConnectivityState>((ref) {
  return ConnectivityStateNotifier();
});
