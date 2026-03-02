import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/project_model.dart';
import '../../widgets/common/project_location_map.dart';

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
  int _selectedUnitTypeIndex = 0;
  int _selectedLocationFilterIndex = 0;
  int _currentImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
    // Gallery images only – adImageUrl is shown separately in the info section
    final List<String> allImages = widget.project.imageGallery.isNotEmpty
        ? widget.project.imageGallery
        : (widget.project.imageUrl.isNotEmpty ? [widget.project.imageUrl] : []);

    if (allImages.isEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: AppColors.lightGray,
          child: const Center(
            child: Icon(Icons.home, size: 72, color: AppColors.darkGray),
          ),
        ),
      );
    }

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: _pageController,
            itemCount: allImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = allImages[index];
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.lightGray,
                  child: const Center(
                    child:
                        Icon(Icons.home, size: 72, color: AppColors.darkGray),
                  ),
                ),
              );
            },
          ),
        ),
        if (allImages.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                allImages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? AppColors.orange
                        : AppColors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceAndInfoSection() {
    // Format price range
    String priceText = 'Price not available';
    if (widget.project.priceMin != null && widget.project.priceMax != null) {
      priceText =
          'Rp${widget.project.priceMin!.toStringAsFixed(1)} Jt - Rp${widget.project.priceMax!.toStringAsFixed(1)} M';
    } else if (widget.project.priceMin != null) {
      priceText = 'From Rp${widget.project.priceMin!.toStringAsFixed(1)} Jt';
    }

    // Format property details
    final List<String> details = [];
    if (widget.project.bedrooms != null)
      details.add('${widget.project.bedrooms} KT');
    if (widget.project.landArea != null)
      details.add('LT ${widget.project.landArea!.toStringAsFixed(0)} m²');
    if (widget.project.buildingArea != null)
      details.add('LB ${widget.project.buildingArea!.toStringAsFixed(0)} m²');
    if (widget.project.certificateType != null)
      details.add(widget.project.certificateType!);
    final detailsText =
        details.isNotEmpty ? details.join('   •   ') : 'Details not available';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryDarkGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            priceText,
            style: AppTextStyles.projectName(),
          ),
          const SizedBox(height: 12),
          Container(height: 2, color: AppColors.orange),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    widget.project.profileImageUrl != null &&
                            widget.project.profileImageUrl!.isNotEmpty
                        ? CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                NetworkImage(widget.project.profileImageUrl!),
                            backgroundColor: AppColors.white,
                          )
                        : CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.white,
                            child: Text(
                              widget.project.name.isNotEmpty
                                  ? widget.project.name[0].toUpperCase()
                                  : 'G',
                              style: const TextStyle(
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
                      'by ${widget.project.developerName ?? "PT Sumber Sentuhan Emas"}',
                      style: AppTextStyles.small(
                        color: AppColors.textWhite.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.project.district != null &&
                              widget.project.province != null
                          ? '${widget.project.district}, ${widget.project.province}'
                          : widget.project.fullAddress ??
                              'Location not specified',
                      style: AppTextStyles.small(
                        color: AppColors.textWhite.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      detailsText,
                      style: AppTextStyles.small(
                        color: AppColors.textWhite.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              // Advertisement Image
              if (widget.project.adImageUrl != null &&
                  widget.project.adImageUrl!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.orange, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.project.adImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.lightGray,
                        child:
                            const Icon(Icons.image, color: AppColors.darkGray),
                      ),
                    ),
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
              const Icon(Icons.location_on,
                  color: AppColors.textWhite, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.project.fullAddress ?? 'Address not specified',
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
              children: [
                'Pusat Perbelanjaan',
                'Pendidikan',
                'Kesehatan',
                'Transportasi'
              ]
                  .asMap()
                  .entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            e.value,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textWhite),
                          ),
                          selected: _selectedLocationFilterIndex == e.key,
                          onSelected: (_) => setState(
                              () => _selectedLocationFilterIndex = e.key),
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
          // Map - show real Google Map if coordinates are available
          widget.project.latitude != null && widget.project.longitude != null
              ? ProjectLocationMap(
                  latitude: widget.project.latitude!,
                  longitude: widget.project.longitude!,
                  projectName: widget.project.name,
                  nearbyLocations: widget.project.nearbyLocations
                      .where((loc) =>
                          loc.category ==
                          [
                            'Pusat Perbelanjaan',
                            'Pendidikan',
                            'Kesehatan',
                            'Transportasi'
                          ][_selectedLocationFilterIndex])
                      .toList(),
                  height: 180,
                )
              : Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDarkGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined,
                            size: 48,
                            color: AppColors.textWhite.withOpacity(0.5)),
                        const SizedBox(height: 8),
                        Text(
                          'Location not set',
                          style: TextStyle(
                            color: AppColors.textWhite.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          const SizedBox(height: 12),
          // Nearby locations filtered by category
          ...() {
            final categoryMap = {
              0: 'Pusat Perbelanjaan',
              1: 'Pendidikan',
              2: 'Kesehatan',
              3: 'Transportasi',
            };
            final selectedCategory =
                categoryMap[_selectedLocationFilterIndex] ??
                    'Pusat Perbelanjaan';
            final filteredLocations = widget.project.nearbyLocations
                .where((loc) => loc.category == selectedCategory)
                .toList();

            if (filteredLocations.isEmpty) {
              return [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No locations in this category',
                    style: AppTextStyles.small(
                      color: AppColors.textWhite.withOpacity(0.6),
                    ),
                  ),
                ),
              ];
            }

            return filteredLocations
                .map((loc) => _buildNearbyItem(
                    loc.name, '${loc.distance} ${loc.distanceUnit}'))
                .toList();
          }(),
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
    const btnShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)));
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
    final unitTypes = widget.project.unitTypes;

    if (unitTypes.isEmpty) {
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'No unit types available',
                  style: AppTextStyles.small(
                    color: AppColors.textWhite.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Ensure selected index is valid
    if (_selectedUnitTypeIndex >= unitTypes.length) {
      _selectedUnitTypeIndex = 0;
    }

    final selectedUnit = unitTypes[_selectedUnitTypeIndex];

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
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
              unitTypes.length,
              (index) => _buildUnitTypeChip(unitTypes[index].name, index),
            ),
          ),
          const SizedBox(height: 16),
          // Large image at top
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: widget.project.imageUrl.startsWith('http')
                  ? Image.network(
                      widget.project.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.lightGray,
                        child: const Icon(Icons.home,
                            size: 72, color: AppColors.darkGray),
                      ),
                    )
                  : Image.asset(
                      widget.project.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.lightGray,
                        child: const Icon(Icons.home,
                            size: 72, color: AppColors.darkGray),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          // White card with price and specs
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rp${selectedUnit.price.toStringAsFixed(0)} Jt',
                  style: const TextStyle(
                    color: AppColors.primaryDarkGreen,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSpecRowDark('Luas Tanah',
                    '${selectedUnit.landArea.toStringAsFixed(0)}M^2'),
                const SizedBox(height: 8),
                _buildSpecRowDark('Luas Bangunan',
                    '${selectedUnit.buildingArea.toStringAsFixed(0)}M^2'),
                const SizedBox(height: 8),
                _buildSpecRowDark('Kamar Tidur', '${selectedUnit.bedrooms}'),
                const SizedBox(height: 8),
                _buildSpecRowDark('Kamar Mandi', '${selectedUnit.bathrooms}'),
                const SizedBox(height: 8),
                _buildSpecRowDark('Jumlah Lantai', '${selectedUnit.floors}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRowDark(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textBlack,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textBlack,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
            style: AppTextStyles.small(
                color: AppColors.textWhite.withOpacity(0.85)),
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
    final sitemapUrl = widget.project.sitemapUrl;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryDarkGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sitemapUrl != null && sitemapUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                sitemapUrl,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _buildSitePlanPlaceholder(),
              ),
            )
          else
            _buildSitePlanPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildSitePlanPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.secondaryDarkGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.map,
            size: 48, color: AppColors.textWhite.withOpacity(0.5)),
      ),
    );
  }

  Widget _buildSpecsAndFacilitiesSection() {
    final facilities = widget.project.features;

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
              Icon(Icons.info_outline,
                  size: 16, color: AppColors.textWhite.withOpacity(0.6)),
              const SizedBox(width: 6),
              Text(
                'Fasilitas bisa berbeda tiap cluster',
                style: AppTextStyles.small(
                    color: AppColors.textWhite.withOpacity(0.6)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (facilities.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.secondaryDarkGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'No facilities added yet',
                  style: AppTextStyles.small(
                      color: AppColors.textWhite.withOpacity(0.6)),
                ),
              ),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: facilities
                  .map((facility) => _buildFacilityChip(facility))
                  .toList(),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat, color: AppColors.orange, size: 20),
              label: const Text(
                'Tanya Detail Fasilitas',
                style: TextStyle(
                    color: AppColors.orange, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.orange),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a facility chip. Accepts either a plain String name or a Map {name, imageUrl}.
  Widget _buildFacilityChip(dynamic feature) {
    final String label = feature is Map
        ? ((feature['name'] as String?) ?? '')
        : feature.toString();
    final String? imageUrl =
        feature is Map ? (feature['imageUrl'] as String?) : null;
    final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textWhite.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.check_circle,
                          color: AppColors.orange,
                          size: 28),
                    ),
                  )
                : const Center(
                    child: Icon(Icons.check_circle,
                        color: AppColors.orange, size: 28)),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.small(color: AppColors.textWhite)
                .copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
