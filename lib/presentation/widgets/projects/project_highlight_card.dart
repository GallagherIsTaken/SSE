import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/project_model.dart';

/// Highlight card for a single project on the Projects page.
/// This is a more detailed, marketing-style card than the home list cards.
class ProjectHighlightCard extends StatelessWidget {
  final ProjectModel project;

  /// When set, tapping the card (outside the action buttons) opens the project detail.
  final VoidCallback? onTap;

  const ProjectHighlightCard({
    super.key,
    required this.project,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildImage(),
        _buildOrangeDivider(),
        _buildContent(context),
        const SizedBox(height: 12),
        _buildActions(context),
      ],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.primaryDarkGreen,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              child: content,
            )
          : content,
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImageWidget(),
            // Simple page indicator mimic (static for now)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 0
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    // Check if it's a network URL or asset path
    final isNetworkImage = project.imageUrl.startsWith('http://') ||
        project.imageUrl.startsWith('https://');

    if (isNetworkImage) {
      return Image.network(
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
              child: Icon(
                Icons.home,
                size: 72,
                color: AppColors.darkGray,
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        project.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.lightGray,
            child: const Center(
              child: Icon(
                Icons.home,
                size: 72,
                color: AppColors.darkGray,
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildOrangeDivider() {
    return Container(
      height: 4,
      color: AppColors.orange,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top meta line
          Text(
            'Rumah Tahap 1  •  Sisa 4 unit',
            style: AppTextStyles.small(
                color: AppColors.textWhite.withOpacity(0.9)),
          ),
          const SizedBox(height: 8),
          // Price line
          Text(
            'Rp406,1 Jt - Rp1,1 M',
            style: AppTextStyles.projectName(),
          ),
          const SizedBox(height: 4),
          Text(
            'Angsuran mulai dari Rp3,29 Juta/bln',
            style: AppTextStyles.bodyText(
              color: AppColors.orange,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          // Project name + developer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.white,
                child: Icon(
                  Icons.location_city,
                  size: 18,
                  color: AppColors.primaryDarkGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: AppTextStyles.bodyText(
                        color: AppColors.textWhite,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'by PT Sumber Sentuhan Emas',
                      style: AppTextStyles.small(
                        color: AppColors.textWhite.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kec. Tamalate, Kota Makassar',
                      style: AppTextStyles.small(
                        color: AppColors.textWhite.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Specs row
          Text(
            '4 KT   •   LT 100 m²   •   LB 105-138 m²   •   HGB',
            style: AppTextStyles.small(
              color: AppColors.textWhite.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Diperbarui 1 bulan lalu',
            style: AppTextStyles.small(
              color: AppColors.textWhite.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    const btnPadding = EdgeInsets.symmetric(vertical: 12);
    const btnShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
    // Fixed minimum size to ensure both buttons are the same height
    const btnMinSize = Size(0, 48);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Open brochure
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textWhite,
                side: const BorderSide(color: AppColors.textWhite),
                padding: btnPadding,
                minimumSize: btnMinSize,
                shape: btnShape,
              ),
              icon: const Icon(Icons.description_outlined, size: 18),
              label: const Text('Brosur'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Chat with marketing
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.textWhite,
                padding: btnPadding,
                minimumSize: btnMinSize,
                shape: btnShape,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: const Text(
                  'Chat Dengan Marketing Kami',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
