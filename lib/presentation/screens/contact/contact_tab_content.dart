import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

/// Contact tab body: Marketing list, office info, map.
class ContactTabContent extends StatelessWidget {
  const ContactTabContent({super.key});

  static const List<({String name, String message})> _marketing = [
    (name: 'Wawan', message: 'Kamar mandi ada tiga kak'),
    (name: 'Regita', message: 'You : Untuk kamar mandi nya ada berapa ya?'),
    (name: 'Andika', message: 'Untuk Cendrawasih Residence masih ada 4 unit kak'),
    (name: 'Elsya', message: 'You : Kenapa?'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 8),
            Text(
              'Marketing Kami',
              style: AppTextStyles.sectionHeading(color: AppColors.textDarkGreen),
            ),
            const SizedBox(height: 16),
            ..._marketing.map((m) => _buildMarketingCard(m.name, m.message)),
            const SizedBox(height: 24),
            _buildOrangeDivider(),
            const SizedBox(height: 16),
            _buildOfficeHours(),
            const SizedBox(height: 8),
            _buildPhone(),
            const SizedBox(height: 8),
            _buildInstagram(),
            const SizedBox(height: 16),
            _buildMapPlaceholder(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppStrings.contact,
          style: AppTextStyles.largeHeading(color: AppColors.textDarkGreen),
        ),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.orange,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildMarketingCard(String name, String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryDarkGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyText(
                    color: AppColors.textWhite,
                    fontSize: 16,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: AppTextStyles.small(color: AppColors.textWhite.withOpacity(0.85)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.orange, width: 2),
          ),
          child: const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.lightGray,
            child: Icon(Icons.person, color: AppColors.darkGray, size: 28),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryDarkGreen, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrangeDivider() {
    return Container(height: 4, color: AppColors.orange);
  }

  Widget _buildOfficeHours() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.access_time, size: 20, color: AppColors.textDarkGreen),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Monday - Friday, 09.00 WITA - 18.00 WITA',
            style: AppTextStyles.bodyText(color: AppColors.textBlack, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildPhone() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.phone, size: 20, color: AppColors.textDarkGreen),
        const SizedBox(width: 8),
        Text(
          '0411-361-5377 | 0411-363-5158',
          style: AppTextStyles.bodyText(color: AppColors.textBlack, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildInstagram() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt_outlined, size: 20, color: AppColors.textDarkGreen),
        const SizedBox(width: 8),
        Text(
          '@sumbersentuhanemas.official',
          style: AppTextStyles.bodyText(color: AppColors.textBlack, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.map_outlined, size: 48, color: AppColors.darkGray),
      ),
    );
  }
}
