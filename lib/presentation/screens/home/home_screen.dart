import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/project_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/home/hero_carousel.dart';
import '../../widgets/sections/finding_home_section.dart';
import '../../widgets/sections/projects_section.dart';
import '../projects/projects_screen.dart';
import '../contact/contact_tab_content.dart';
import '../about/about_tab_content.dart';

/// Home screen matching the design
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(projectProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationProvider);

    return Scaffold(
      body: SafeArea(
        // Background behind the rounded header must match the header color (#013235)
        child: Container(
          color: AppColors.primaryDarkGreen,
          child: Column(
            children: [
              // Header - only show for Home tab (index 0)
              if (currentIndex == 0) const AppHeader(),
              // Content
              Expanded(
                // Switch body based on selected bottom-nav index
                child: Container(
                  color: AppColors.white,
                  child: _buildBodyForIndex(currentIndex),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  /// Returns the appropriate body widget for the selected tab.
  Widget _buildBodyForIndex(int index) {
    switch (index) {
      case 0:
        // Home tab content
        return SingleChildScrollView(
          child: Column(
            children: [
              // Gap between header and hero carousel stays #022322
              Container(
                height: 16,
                color: AppColors.secondaryDarkGreen,
              ),
              // Hero Carousel
              const HeroCarousel(),
              // Finding Home Section
              const FindingHomeSection(),
              // Projects Section
              const ProjectsSection(),
              const SizedBox(height: 20),
            ],
          ),
        );
      case 1:
        // Projects tab content
        return const ProjectsTabContent();
      case 2:
        // Contact tab content
        return const ContactTabContent();
      case 3:
        // About Us tab content
        return const AboutTabContent();
      default:
        return const Center(child: Text('Coming soon'));
    }
  }
}
