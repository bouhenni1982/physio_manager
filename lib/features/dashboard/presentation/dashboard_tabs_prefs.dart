import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardTabsState {
  final List<String> order;
  final Set<String> hidden;

  const DashboardTabsState({
    required this.order,
    required this.hidden,
  });

  DashboardTabsState copyWith({
    List<String>? order,
    Set<String>? hidden,
  }) {
    return DashboardTabsState(
      order: order ?? this.order,
      hidden: hidden ?? this.hidden,
    );
  }
}

class DashboardTabsNotifier extends StateNotifier<DashboardTabsState> {
  final String userId;

  DashboardTabsNotifier(this.userId)
      : super(const DashboardTabsState(order: <String>[], hidden: <String>{})) {
    _load();
  }

  String get _orderKey => 'dashboard_tabs_order_$userId';
  String get _hiddenKey => 'dashboard_tabs_hidden_$userId';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final order = prefs.getStringList(_orderKey) ?? <String>[];
    final hidden = prefs.getStringList(_hiddenKey) ?? <String>[];
    state = DashboardTabsState(order: order, hidden: hidden.toSet());
  }

  Future<void> setHidden(String id, bool hidden) async {
    final next = state.hidden.toSet();
    if (hidden) {
      next.add(id);
    } else {
      next.remove(id);
    }
    state = state.copyWith(hidden: next);
    await _save();
  }

  Future<void> setOrder(List<String> order) async {
    state = state.copyWith(order: order);
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_orderKey, state.order);
    await prefs.setStringList(_hiddenKey, state.hidden.toList());
  }
}

final dashboardTabsProvider = StateNotifierProvider.family<
  DashboardTabsNotifier,
  DashboardTabsState,
  String
>((ref, userId) => DashboardTabsNotifier(userId));
