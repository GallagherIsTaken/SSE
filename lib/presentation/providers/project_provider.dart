import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/feature_model.dart';

/// Holds project-related state
class ProjectState {
  final List<ProjectModel> projects;
  final List<FeatureModel> features;
  final List<String> heroImages;
  final bool isLoading;

  const ProjectState({
    this.projects = const [],
    this.features = const [],
    this.heroImages = const [],
    this.isLoading = false,
  });

  ProjectState copyWith({
    List<ProjectModel>? projects,
    List<FeatureModel>? features,
    List<String>? heroImages,
    bool? isLoading,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      features: features ?? this.features,
      heroImages: heroImages ?? this.heroImages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Repository provider (easy to swap with real backend later)
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository();
});

/// StateNotifier for project data (Riverpod)
final projectProvider =
    StateNotifierProvider<ProjectNotifier, ProjectState>((ref) {
  final repository = ref.read(projectRepositoryProvider);
  return ProjectNotifier(repository);
});

class ProjectNotifier extends StateNotifier<ProjectState> {
  ProjectNotifier(this._repository) : super(const ProjectState());

  final ProjectRepository _repository;

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);

    try {
      // Fetch data from repository (Firebase or fallback)
      final projects = await _repository.getProjects();
      final features = await _repository.getFeatures();
      final heroImages = await _repository.getHeroImages();

      state = state.copyWith(
        projects: projects,
        features: features,
        heroImages: heroImages,
        isLoading: false,
      );
    } catch (e) {
      print('Error loading data: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  List<ProjectModel> getFeaturedProjects() {
    return state.projects.where((project) => project.isFeatured).toList();
  }
}
