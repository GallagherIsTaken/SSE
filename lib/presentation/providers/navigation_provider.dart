import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing/// StateNotifier for navigation (Riverpod)
final navigationProvider =
    StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  String? selectedProjectId;

  void setCurrentIndex(int index) {
    state = index;
  }

  /// Navigate to projects tab with specific project selected
  void navigateToProject(String projectId) {
    selectedProjectId = projectId;
    state = 1; // Projects tab index
  }

  /// Clear selected project
  void clearSelectedProject() {
    selectedProjectId = null;
  }
}
