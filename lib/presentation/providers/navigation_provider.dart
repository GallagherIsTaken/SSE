import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing bottom navigation state (Riverpod)
final navigationProvider =
    StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setCurrentIndex(int index) {
    if (state != index) {
      state = index;
    }
  }
}
