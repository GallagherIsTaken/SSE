import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/project_model.dart';
import '../common/featured_tag.dart';

/// Project card widget matching the design
class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onSeeMoreTap;

  const ProjectCard({
    super.key,
    required this.project,
    this.onSeeMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Project Image
            _buildProjectImage(),
            // Featured Tag
            if (project.isFeatured)
              const Positioned(
                top: 0,
                left: 0,
                child: FeaturedTag(),
              ),
            // Overlay with project details
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.5,
              child: _buildOverlay(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectImage() {
    // Check if it's a network URL or asset path
    final isNetworkImage = project.imageUrl.startsWith('http://') ||
        project.imageUrl.startsWith('https://');

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: isNetworkImage
          ? Image.network(
              project.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.lightGray,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.orange,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.lightGray,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          size: 60,
                          color: AppColors.darkGray,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Project Image\nPlaceholder',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.darkGray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Image.asset(
              project.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.lightGray,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          size: 60,
                          color: AppColors.darkGray,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Project Image\nPlaceholder',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.darkGray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDarkGreen.withOpacity(0.95),
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            AppColors.primaryDarkGreen,
            AppColors.primaryDarkGreen.withOpacity(0.9),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Status label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: AppColors.orange,
                width: 1,
              ),
            ),
            child: Text(
              project.status,
              style: AppTextStyles.label(
                fontSize: 10,
                color: AppColors.white,
              ),
            ),
          ),
          // Project name
          Text(
            project.name,
            style: AppTextStyles.projectName(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Description
          Expanded(
            child: Text(
              project.description,
              style: AppTextStyles.description(),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // See More button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSeeMoreTap ?? () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                AppStrings.seeMore,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
