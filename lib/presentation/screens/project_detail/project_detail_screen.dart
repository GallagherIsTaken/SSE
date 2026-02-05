import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/project_model.dart';

/// Full project detail page opened when tapping a project listing.
class ProjectDetailScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailScreen({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  /// 0 = Type 138, 1 = Type 105
  int _selectedUnitTypeIndex = 0;
  int _selectedLocationFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textBlack,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Rumah Baru',
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMainImage(),
            _buildOrangeDivider(),
            _buildPriceAndInfoSection(),
            _buildSectionDivider(),
            _buildLocationSection(),
            _buildSectionDivider(),
            _buildUnitTypeSection(),
            _buildSectionDivider(),
            _buildSitePlanSection(),
            _buildSectionDivider(),
            _buildSpecsAndFacilitiesSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildStickyFooter(),
    );
  }

  /// Thick orange divider below hero image (and between other major blocks as in design).
  Widget _buildOrangeDivider() {
    return Container(height: 4, color: AppColors.orange);
  }

  /// Thin divider between dark green sections.
  Widget _buildSectionDivider() {
    return Container(
      height: 1,
      color: AppColors.textWhite.withOpacity(0.12),
    );
  }

  /// Sticky footer with Share, Brosur, Chat. Dark green background.
  Widget _buildStickyFooter() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryDarkGreen,
        border: Border(
          top: BorderSide(color: AppColors.orange, width: 2),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SafeArea(
        top: false,
        child: _buildDetailActions(),
      ),
    );
  }

  Widget _buildMainImage() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.asset(
        widget.project.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: AppColors.lightGray,
          child: const Center(
            child: Icon(Icons.home, size: 72, color: AppColors.darkGray),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceAndInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryDarkGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rp406,1 Jt - Rp1,1 M',
            style: AppTextStyles.projectName(),
          ),
          const SizedBox(height: 12),
          Container(height: 2, color: AppColors.orange),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.white,
                    child: Text(
                      'G',
                      style: TextStyle(
                        color: AppColors.primaryDarkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.project.name,
                    style: AppTextStyles.bodyText(
                      color: AppColors.textWhite,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by PT Sumber Sentuhan Emas',
                    style: AppTextStyles.small(
                      color: AppColors.textWhite.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kec. Tamalate, Sulawesi Selatan',
                    style: AppTextStyles.small(
                      color: AppColors.textWhite.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '4 KT   •   LT 100 m²   •   LB 105-138 m²   •   HGB',
                    style: AppTextStyles.small(
                      color: AppColors.textWhite.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Promo badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'PROMO 17 AN\n(BATU TUJUAN)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'CASH BACK\nUP TO 300 JT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'FREE',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryDarkGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lokasi',
            style: AppTextStyles.sectionHeading(color: AppColors.textWhite),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: AppColors.textWhite, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Jl. Cendrawasih No 89, Tamalate, Makassar, Sulawesi Selatan',
                  style: AppTextStyles.bodyText(
                    color: AppColors.textWhite.withOpacity(0.95),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Pusat Perbelanjaan', 'Pendidikan', 'Kesehatan', 'Transportasi']
                  .asMap()
                  .entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            e.value,
                            style: const TextStyle(fontSize: 12, color: AppColors.textWhite),
                          ),
                          selected: _selectedLocationFilterIndex == e.key,
                          onSelected: (_) => setState(() => _selectedLocationFilterIndex = e.key),
                          selectedColor: AppColors.orange,
                          backgroundColor: AppColors.primaryDarkGreen,
                          side: BorderSide(
                            color: _selectedLocationFilterIndex == e.key
                                ? AppColors.orange
                                : AppColors.textWhite.withOpacity(0.5),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Map placeholder
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.secondaryDarkGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(Icons.map_outlined, size: 48, color: AppColors.textWhite.withOpacity(0.5)),
            ),
          ),
          const SizedBox(height: 12),
          _buildNearbyItem('Alfamidi Cendrawasih 2', '1.7 KM'),
          _buildNearbyItem('Trans Studio Mall', '10 MENIT'),
          _buildNearbyItem('RS Hermina', '5 MENIT'),
        ],
      ),
    );
  }

  Widget _buildNearbyItem(String name, String distance) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.place, color: AppColors.textWhite, size: 18),
          const SizedBox(width: 8),
          Text(
            name,
            style: AppTextStyles.bodyText(
              color: AppColors.textWhite.withOpacity(0.95),
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            distance,
            style: AppTextStyles.small(color: AppColors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailActions() {
    const btnPadding = EdgeInsets.symmetric(vertical: 12);
    const btnShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)));
    const btnMinSize = Size(0, 48);

    return Row(
      children: [
        IconButton.outlined(
          onPressed: () {},
          icon: const Icon(Icons.share, color: AppColors.textWhite),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.textWhite),
            shape: const CircleBorder(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: AppColors.textWhite,
              padding: btnPadding,
              minimumSize: btnMinSize,
              shape: btnShape,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: const Text('Chat Dengan Marketing Kami', maxLines: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitTypeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryDarkGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilihan Tipe Unit',
            style: AppTextStyles.sectionHeading(color: AppColors.textWhite),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildUnitTypeChip('Type 138', 0),
              const SizedBox(width: 12),
              _buildUnitTypeChip('Type 105', 1),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.project.imageUrl,
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 100,
                      height: 80,
                      color: AppColors.lightGray,
                      child: const Icon(Icons.home, color: AppColors.darkGray),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedUnitTypeIndex == 0 ? 'Rp401 Jt' : 'Rp350 Jt',
                        style: AppTextStyles.projectName(color: AppColors.textWhite),
                      ),
                      const SizedBox(height: 12),
                      _buildSpecRow('Luas Tanah', '104 m²'),
                      _buildSpecRow('Luas Bangunan', '138 m²'),
                      _buildSpecRow('Kamar Tidur', '3'),
                      _buildSpecRow('Kamar Mandi', '2'),
                      _buildSpecRow('Jumlah Lantai', '2'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitTypeChip(String label, int index) {
    final selected = _selectedUnitTypeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedUnitTypeIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.orange : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.orange,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.label(
              color: AppColors.textWhite,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.small(color: AppColors.textWhite.withOpacity(0.85)),
          ),
          Text(
            value,
            style: AppTextStyles.small(color: AppColors.textWhite),
          ),
        ],
      ),
    );
  }

  Widget _buildSitePlanSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryDarkGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDarkGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.map, size: 48, color: AppColors.textWhite.withOpacity(0.5)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Site Plan',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.project.name,
                      style: TextStyle(
                        color: AppColors.textWhite.withOpacity(0.9),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Keterangan:',
                      style: TextStyle(
                        color: AppColors.textWhite.withOpacity(0.9),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _buildLegendItem('Kuning: Open For Sale'),
                    _buildLegendItem('Biru: Rumah Contoh'),
                    _buildLegendItem('Merah: Booked'),
                    _buildLegendItem('Hijau: Sold'),
                    const SizedBox(height: 12),
                    Text(
                      'www.sumbersentuhanemas.com',
                      style: TextStyle(
                        color: AppColors.textWhite.withOpacity(0.8),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textWhite.withOpacity(0.85),
          fontSize: 9,
        ),
      ),
    );
  }

  Widget _buildSpecsAndFacilitiesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryDarkGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spesifikasi dan Fasilitas',
            style: AppTextStyles.sectionHeading(color: AppColors.textWhite),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.textWhite.withOpacity(0.6)),
              const SizedBox(width: 6),
              Text(
                'Fasilitas bisa berbeda tiap cluster',
                style: AppTextStyles.small(color: AppColors.textWhite.withOpacity(0.6)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
              6,
              (_) => _buildFacilityChip('Keamanan 24 jam'),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat, color: AppColors.orange, size: 20),
              label: const Text(
                'Tanya Detail Fasilitas',
                style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.orange),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityChip(String label) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textWhite.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.check_circle, color: AppColors.orange, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.small(color: AppColors.textWhite).copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
