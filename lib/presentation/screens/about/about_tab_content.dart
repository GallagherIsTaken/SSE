import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../providers/navigation_provider.dart';

/// About Us tab: hero, Siapa Kami, Visi, Misi.
class AboutTabContent extends ConsumerWidget {
  const AboutTabContent({super.key});

  static const String _heroImage = 'assets/images/hero/SSEHero1.png';

  static const String _motto1 = 'RUMAH UNTUK SEMUA';
  static const String _motto2 = 'merupakan motto dan misi kami untuk';
  static const String _motto3 = 'membangun perumahan';
  static const String _motto4 = 'untuk berbagai kalangan,';
  static const String _motto5 = 'baik minimalis maupun mewah, baik subsidi';
  static const String _motto6 = 'maupun komersil.';
  static const String _breadcrumbs = 'Home > About';

  static const String _siapaKamiTitle = 'Siapa Kami?';
  static const String _siapaKamiSubtitle =
      'Kami adalah Perusahaan yang bergerak di bisnis Property';
  static const String _siapaKamiBody =
      'PT. Harapan Gowa Jaya memulai bisnisnya sejak tahun 1994 di bidang Developer, Kontraktor, dan Real Estate. Pada tahun 2008 PT. Harapan Gowa Jaya berkembang menjadi PT. Sumber Sentuhan Emas yang kemudian lebih dikenal dengan sebutan PT. SSE. PT. SSE membangun perumahan dari rumah sederhana hingga rumah kelas menengah ke atas. Hal ini sesuai dengan tagline kami "Rumah Untuk Semua". Kami memiliki komitmen memenuhi kebutuhan rumah untuk masyarakat Indonesia dari berbagai kalangan dan golongan. PT. SSE bangga ikut aktif sebagai anggota DPP REI Sulawesi Selatan. Perusahaan ini telah mengembangkan sayap ke ranah bisnis lain di bawah bendera PT. SSE yaitu logistic, travel, restoran, dan recycling.';
  static const String _ctaLabel = 'Hubungi Sekarang';

  static const String _visiTitle = 'Visi Perusahaan';
  static const String _visiText =
      'Menjadi perusahaan yang kuat, berkembang dan bermultiplikasi';

  static const String _misiTitle = 'Misi Perusahaan';
  static const List<({String title, String desc, IconData icon})> _misiItems = [
    (
      title: 'Profit',
      desc:
          'Menghasilkan profit yang didukung oleh produk yang berkualitas, aman, dan sehat serta mengutamakan konsep Green Home Environment.',
      icon: Icons.paid,
    ),
    (
      title: 'Kesejahteraan',
      desc:
          'Meningkatkan kesejahteraan karyawan, mitra, dan masyarakat sekitar melalui program tanggung jawab sosial.',
      icon: Icons.volunteer_activism,
    ),
    (
      title: 'Excellent',
      desc:
          'Menjadi perusahaan yang memiliki standar excellent dalam setiap bidang.',
      icon: Icons.emoji_events,
    ),
    (
      title: 'Integritas',
      desc:
          'Menjadi perusahaan yang berintegritas (memiliki loyalitas dan kepercayaan).',
      icon: Icons.workspace_premium,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: _buildTitle(),
          ),
          _buildHero(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: _buildSiapaKami(ref),
          ),
          _buildVisi(),
          _buildMisi(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppStrings.aboutUs,
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

  Widget _buildHero(BuildContext context) {
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            _heroImage,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryDarkGreen.withOpacity(0.5),
                  AppColors.primaryDarkGreen.withOpacity(0.75),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      AppStrings.aboutUs,
                      style: AppTextStyles.sectionHeading(
                        color: AppColors.orange,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _motto1,
                      style: AppTextStyles.bodyText(
                        color: AppColors.textWhite,
                        fontSize: 14,
                      ).copyWith(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ...[_motto2, _motto3, _motto4, _motto5, _motto6].map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          line,
                          style: AppTextStyles.bodyText(
                            color: AppColors.textWhite.withOpacity(0.95),
                            fontSize: 12,
                          ).copyWith(fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  _breadcrumbs,
                  style: AppTextStyles.small(color: AppColors.textWhite),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSiapaKami(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _siapaKamiTitle,
          style: AppTextStyles.sectionHeading(color: AppColors.textDarkGreen),
        ),
        const SizedBox(height: 6),
        Text(
          _siapaKamiSubtitle,
          style: AppTextStyles.bodyText(
            color: AppColors.orange,
            fontSize: 14,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Text(
          _siapaKamiBody,
          style: AppTextStyles.bodyText(color: AppColors.textBlack, fontSize: 14),
        ),
        const SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  ref.read(navigationProvider.notifier).setCurrentIndex(2),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.textWhite,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _ctaLabel,
                style: AppTextStyles.buttonText(color: AppColors.textWhite),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisi() {
    return Container(
      width: double.infinity,
      color: AppColors.primaryDarkGreen,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        children: [
          Text(
            _visiTitle,
            style: AppTextStyles.sectionHeading(color: AppColors.orange),
          ),
          const SizedBox(height: 12),
          Icon(Icons.business, size: 48, color: AppColors.orange),
          const SizedBox(height: 12),
          Text(
            _visiText,
            style: AppTextStyles.bodyText(
              color: AppColors.textWhite,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMisi() {
    return Container(
      width: double.infinity,
      color: AppColors.primaryDarkGreen,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      child: Column(
        children: [
          Text(
            _misiTitle,
            style: AppTextStyles.sectionHeading(color: AppColors.orange),
          ),
          const SizedBox(height: 20),
          ..._misiItems.map(_buildMisiItem),
        ],
      ),
    );
  }

  Widget _buildMisiItem(
      ({String title, String desc, IconData icon}) item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Icon(item.icon, size: 40, color: AppColors.orange),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: AppTextStyles.bodyText(
              color: AppColors.orange,
              fontSize: 16,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            item.desc,
            style: AppTextStyles.bodyText(
              color: AppColors.textWhite,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
