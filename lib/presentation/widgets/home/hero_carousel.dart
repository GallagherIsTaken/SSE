import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/project_provider.dart';
import 'feature_list_item.dart';

/// Hero carousel widget with overlay banner and features
class HeroCarousel extends ConsumerStatefulWidget {
  const HeroCarousel({super.key});

  @override
  ConsumerState<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends ConsumerState<HeroCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);
    final heroImages = projectState.heroImages;
    final features = projectState.features;

    if (heroImages.isEmpty) {
      // Placeholder when no images
      return _buildPlaceholder();
    }

    return Stack(
      children: [
        // Carousel
        CarouselSlider.builder(
          itemCount: heroImages.length,
          itemBuilder: (context, index, realIndex) {
            return _buildCarouselItem(heroImages[index]);
          },
          options: CarouselOptions(
            // Height adjusted to fit the hero image better
            height: MediaQuery.of(context).size.height * 0.20,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        // Indicator dots
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: _buildIndicators(heroImages.length),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(String imagePath) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.lightGray,
      ),
      child: Image.asset(
        imagePath,
        // Fill the carousel box so no empty space is left behind
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Placeholder if image not found
          return Container(
            color: AppColors.lightGray,
            child: const Center(
              child: Icon(
                Icons.home,
                size: 100,
                color: AppColors.darkGray,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 260,
      color: AppColors.lightGray,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 80,
              color: AppColors.darkGray,
            ),
            SizedBox(height: 16),
            Text(
              'Hero images placeholder\nAdd your images in assets/images/hero/',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.darkGray),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicators(int totalItems) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalItems,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index
                ? AppColors.white
                : AppColors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
