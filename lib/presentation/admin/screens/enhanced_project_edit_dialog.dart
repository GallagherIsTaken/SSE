import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/project_model.dart';
import '../../../../data/models/unit_type_model.dart';
import '../../../../data/models/nearby_location_model.dart';
import '../widgets/admin_image_picker.dart';

class EnhancedProjectEditDialog extends StatefulWidget {
  final ProjectModel? project;
  final Function(ProjectModel) onSave;

  const EnhancedProjectEditDialog({
    super.key,
    this.project,
    required this.onSave,
  });

  @override
  State<EnhancedProjectEditDialog> createState() =>
      _EnhancedProjectEditDialogState();
}

class _EnhancedProjectEditDialogState extends State<EnhancedProjectEditDialog> {
  final _formKey = GlobalKey<FormState>();

  // Basic Info Controllers
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _statusController;
  String _imageUrl = '';
  String _adImageUrl = '';
  String _profileImageUrl = '';
  bool _isFeatured = false;

  // Projects Page Fields
  late TextEditingController _subtitleController;
  late TextEditingController _stockController;
  late TextEditingController _installmentController;
  late TextEditingController _brochureUrlController;

  // Price & Property Details Controllers
  late TextEditingController _priceMinController;
  late TextEditingController _priceMaxController;
  late TextEditingController _bedroomsController;
  late TextEditingController _landAreaController;
  late TextEditingController _buildingAreaController;
  late TextEditingController _certificateController;
  late TextEditingController _developerController;

  // Location Controllers
  late TextEditingController _addressController;
  late TextEditingController _districtController;
  late TextEditingController _cityController;
  late TextEditingController _provinceController;

  // State
  List<UnitTypeModel> _unitTypes = [];
  List<NearbyLocationModel> _nearbyLocations = [];
  List<String> _facilities = [];
  List<String> _imageGallery = [];
  String _selectedLocationCategory = 'Pusat Perbelanjaan';
  int _selectedUnitTypeIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final p = widget.project;

    // Basic Info
    _nameController = TextEditingController(text: p?.name ?? '');
    _descController = TextEditingController(text: p?.description ?? '');
    _statusController =
        TextEditingController(text: p?.status ?? 'On Going Project');
    _imageUrl = p?.imageUrl ?? '';
    _adImageUrl = p?.adImageUrl ?? '';
    _profileImageUrl = p?.profileImageUrl ?? '';
    _isFeatured = p?.isFeatured ?? false;

    // Projects Page Fields
    _subtitleController = TextEditingController(text: p?.subtitle ?? '');
    _stockController =
        TextEditingController(text: p?.stockRemaining?.toString() ?? '');
    _installmentController =
        TextEditingController(text: p?.installmentStarting?.toString() ?? '');
    _brochureUrlController = TextEditingController(text: p?.brochureUrl ?? '');

    // Price & Property Details
    _priceMinController =
        TextEditingController(text: p?.priceMin?.toString() ?? '');
    _priceMaxController =
        TextEditingController(text: p?.priceMax?.toString() ?? '');
    _bedroomsController =
        TextEditingController(text: p?.bedrooms?.toString() ?? '');
    _landAreaController =
        TextEditingController(text: p?.landArea?.toString() ?? '');
    _buildingAreaController =
        TextEditingController(text: p?.buildingArea?.toString() ?? '');
    _certificateController =
        TextEditingController(text: p?.certificateType ?? '');
    _developerController = TextEditingController(text: p?.developerName ?? '');

    // Location
    _addressController = TextEditingController(text: p?.fullAddress ?? '');
    _districtController = TextEditingController(text: p?.district ?? '');
    _cityController = TextEditingController(text: p?.city ?? '');
    _provinceController = TextEditingController(text: p?.province ?? '');

    // Lists
    _unitTypes = List.from(p?.unitTypes ?? []);
    _nearbyLocations = List.from(p?.nearbyLocations ?? []);
    _facilities = List.from(p?.features ?? []);
    _imageGallery = List.from(p?.imageGallery ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _statusController.dispose();
    _priceMinController.dispose();
    _priceMaxController.dispose();
    _bedroomsController.dispose();
    _landAreaController.dispose();
    _buildingAreaController.dispose();
    _certificateController.dispose();
    _developerController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _subtitleController.dispose();
    _stockController.dispose();
    _installmentController.dispose();
    _brochureUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: isMobile
            ? MediaQuery.of(context).size.width * 0.95
            : MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.edit_document, color: Colors.grey[700], size: 28),
                const SizedBox(width: 12),
                Text(
                  widget.project == null ? 'Add New Project' : 'Edit Project',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // Scrollable Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(),
                    const SizedBox(height: 40),
                    _buildImageGallerySection(),
                    const SizedBox(height: 40),
                    _buildPriceDetailsSection(),
                    const SizedBox(height: 40),
                    _buildLocationSection(),
                    const SizedBox(height: 40),
                    _buildFacilitiesSection(),
                    const SizedBox(height: 40),
                    _buildUnitTypesSection(),
                    const SizedBox(height: 100), // Space for buttons
                  ],
                ),
              ),
            ),
          ),
          // Bottom Action Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Main Form Area
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit_document,
                          color: Colors.grey[700], size: 28),
                      const SizedBox(width: 12),
                      Text(
                        widget.project == null
                            ? 'Add New Project'
                            : 'Edit Project',
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey[600]),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                // Scrollable Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBasicInfoSection(),
                          const SizedBox(height: 40),
                          _buildImageGallerySection(),
                          const SizedBox(height: 40),
                          _buildPriceDetailsSection(),
                          const SizedBox(height: 40),
                          _buildLocationSection(),
                          const SizedBox(height: 40),
                          _buildFacilitiesSection(),
                          const SizedBox(height: 40),
                          _buildUnitTypesSection(),
                          const SizedBox(height: 100), // Space for buttons
                        ],
                      ),
                    ),
                  ),
                ),
                // Bottom Action Buttons
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDarkGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Save Project',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Advertisement Image Sidebar
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80), // Align with content
              Text(
                'Advertisement Banner',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload a promotional image for this project',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              AdminImagePicker(
                initialImageUrl: _adImageUrl,
                onImageChanged: (url) => setState(() => _adImageUrl = url),
                label: 'Ad Image',
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Recommended: 400x600px',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
        const SizedBox(height: 20),
        Divider(color: Colors.grey[200], height: 1),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    String? prefixText,
    String? suffixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixText: prefixText,
            suffixText: suffixText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: AppColors.primaryDarkGreen, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          maxLines: maxLines,
          validator: validator,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Basic Information',
          subtitle: 'Essential project details and main image',
        ),
        AdminImagePicker(
          initialImageUrl: _imageUrl,
          onImageChanged: (url) => setState(() => _imageUrl = url),
          label: 'Project Image',
        ),
        const SizedBox(height: 20),
        AdminImagePicker(
          initialImageUrl: _profileImageUrl,
          onImageChanged: (url) => setState(() => _profileImageUrl = url),
          label: 'Profile Picture (Circle Avatar)',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _nameController,
          label: 'Project Name',
          hint: 'Enter the project name',
          validator: (v) => v!.isEmpty ? 'Project name is required' : null,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _subtitleController,
          label: 'Subtitle (Projects Page)',
          hint: 'e.g., "Rumah Tahap 1"',
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _stockController,
                label: 'Stock Remaining',
                hint: 'e.g., 4',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _installmentController,
                label: 'Installment Starting (Juta/bln)',
                hint: 'e.g., 3.29',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _brochureUrlController,
          label: 'Brochure URL',
          hint: 'External link for brochure button',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _descController,
          label: 'Description',
          hint: 'Provide a detailed description of the project',
          maxLines: 4,
          validator: (v) => v!.isEmpty ? 'Description is required' : null,
        ),
        const SizedBox(height: 20),
        // Status and Featured in responsive layout
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 400;

            if (isMobile) {
              // Stack vertically on mobile
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusField(),
                  const SizedBox(height: 20),
                  _buildFeaturedField(),
                ],
              );
            } else {
              // Side by side on desktop
              return Row(
                children: [
                  Expanded(child: _buildStatusField()),
                  const SizedBox(width: 20),
                  Expanded(child: _buildFeaturedField()),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _statusController.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: 'On Going Project',
              child: Text('On Going Project'),
            ),
            DropdownMenuItem(
              value: 'Completed',
              child: Text('Completed'),
            ),
          ],
          onChanged: (v) => setState(() => _statusController.text = v!),
        ),
      ],
    );
  }

  Widget _buildFeaturedField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                _isFeatured ? Icons.star : Icons.star_border,
                color: _isFeatured ? AppColors.orange : Colors.grey[400],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _isFeatured ? 'Featured Project' : 'Not Featured',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
              ),
              Switch(
                value: _isFeatured,
                onChanged: (v) => setState(() => _isFeatured = v),
                activeColor: AppColors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Image Gallery (Galeri Gambar)',
          subtitle: 'Add multiple images for carousel display',
        ),
        if (_imageGallery.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'No gallery images added yet',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _imageGallery.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _imageGallery[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image, color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 20),
                      onPressed: () {
                        setState(() {
                          _imageGallery.removeAt(index);
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.8),
                        padding: const EdgeInsets.all(4),
                        minimumSize: const Size(28, 28),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _addGalleryImage,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Add Gallery Image'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryDarkGreen,
            side: BorderSide(color: AppColors.primaryDarkGreen),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ],
    );
  }

  void _addGalleryImage() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Gallery Image'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter image URL',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _imageGallery.add(controller.text.trim());
                });
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Price & Property Details',
          subtitle: 'Pricing and property specifications',
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _priceMinController,
                label: 'Minimum Price (Juta)',
                hint: '500',
                prefixText: 'Rp ',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildTextField(
                controller: _priceMaxController,
                label: 'Maximum Price (Milyar)',
                hint: '1.5',
                prefixText: 'Rp ',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _bedroomsController,
                label: 'Bedrooms (KT)',
                hint: '3',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildTextField(
                controller: _landAreaController,
                label: 'Land Area',
                hint: '120',
                suffixText: 'm²',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _buildingAreaController,
                label: 'Building Area',
                hint: '90',
                suffixText: 'm²',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildTextField(
                controller: _certificateController,
                label: 'Certificate Type',
                hint: 'HGB, SHM, etc.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _developerController,
          label: 'Developer Name',
          hint: 'Enter developer company name',
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Location (Lokasi)',
          subtitle: 'Address and nearby points of interest',
        ),
        _buildTextField(
          controller: _addressController,
          label: 'Full Address',
          hint: 'Enter complete address',
          maxLines: 2,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _districtController,
                label: 'District (Kecamatan)',
                hint: 'e.g., Serpong',
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildTextField(
                controller: _cityController,
                label: 'City',
                hint: 'e.g., Tangerang Selatan',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _provinceController,
          label: 'Province',
          hint: 'e.g., Banten',
        ),
        const SizedBox(height: 32),
        Text(
          'Nearby Locations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 16),
        _buildCategoryTabs(),
        const SizedBox(height: 16),
        _buildNearbyLocationsList(),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _addNearbyLocation,
          icon: const Icon(Icons.add),
          label: const Text('Add Location'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryDarkGreen,
            side: BorderSide(color: AppColors.primaryDarkGreen),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    final categories = [
      'Pusat Perbelanjaan',
      'Pendidikan',
      'Kesehatan',
      'Transportasi',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = _selectedLocationCategory == category;
        return ChoiceChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() => _selectedLocationCategory = category);
            }
          },
          selectedColor: AppColors.orange,
          backgroundColor: Colors.grey[100],
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
      }).toList(),
    );
  }

  Widget _buildNearbyLocationsList() {
    final filteredLocations = _nearbyLocations
        .where((loc) => loc.category == _selectedLocationCategory)
        .toList();

    if (filteredLocations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'No locations added yet',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ),
      );
    }

    return Column(
      children: filteredLocations.map((location) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey[600], size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[900],
                      ),
                    ),
                    Text(
                      '${location.distance} ${location.distanceUnit}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _nearbyLocations.remove(location);
                  });
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _addNearbyLocation() {
    showDialog(
      context: context,
      builder: (context) => _NearbyLocationDialog(
        category: _selectedLocationCategory,
        onAdd: (location) {
          setState(() {
            _nearbyLocations.add(location);
          });
        },
      ),
    );
  }

  Widget _buildFacilitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Specifications and Facilities (Spesifikasi dan Fasilitas)',
          subtitle: 'Add facilities and amenities available in this project',
        ),
        if (_facilities.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'No facilities added yet',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _facilities.map((facility) {
              return Chip(
                label: Text(facility),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  setState(() {
                    _facilities.remove(facility);
                  });
                },
                backgroundColor: AppColors.orange.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: AppColors.primaryDarkGreen,
                  fontWeight: FontWeight.w500,
                ),
                deleteIconColor: AppColors.primaryDarkGreen,
              );
            }).toList(),
          ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _addFacility,
          icon: const Icon(Icons.add),
          label: const Text('Add Facility'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryDarkGreen,
            side: BorderSide(color: AppColors.primaryDarkGreen),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ],
    );
  }

  void _addFacility() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Facility'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., Keamanan 24 jam, Kolam Renang',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _facilities.add(controller.text.trim());
                });
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unit Types (Pilihan Tipe Unit)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Different unit configurations available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: _addUnitType,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Unit Type'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryDarkGreen,
                side: BorderSide(color: AppColors.primaryDarkGreen),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Divider(color: Colors.grey[200], height: 1),
        const SizedBox(height: 20),
        if (_unitTypes.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'No unit types added yet',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
          )
        else
          Column(
            children: [
              _buildUnitTypeTabs(),
              const SizedBox(height: 16),
              _buildUnitTypeDetails(),
            ],
          ),
      ],
    );
  }

  Widget _buildUnitTypeTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_unitTypes.length, (index) {
          final isSelected = _selectedUnitTypeIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_unitTypes[index].name),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedUnitTypeIndex = index);
                }
              },
              selectedColor: AppColors.orange,
              backgroundColor: Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUnitTypeDetails() {
    if (_unitTypes.isEmpty) return const SizedBox.shrink();

    final unitType = _unitTypes[_selectedUnitTypeIndex];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                unitType.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: () => _editUnitType(_selectedUnitTypeIndex),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _unitTypes.removeAt(_selectedUnitTypeIndex);
                        if (_selectedUnitTypeIndex >= _unitTypes.length &&
                            _unitTypes.isNotEmpty) {
                          _selectedUnitTypeIndex = _unitTypes.length - 1;
                        }
                      });
                    },
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
          Divider(color: Colors.grey[300], height: 24),
          _buildUnitTypeInfoRow(
              'Price', 'Rp ${unitType.price.toStringAsFixed(0)}'),
          _buildUnitTypeInfoRow('Land Area', '${unitType.landArea} m²'),
          _buildUnitTypeInfoRow('Building Area', '${unitType.buildingArea} m²'),
          _buildUnitTypeInfoRow('Bedrooms', '${unitType.bedrooms}'),
          _buildUnitTypeInfoRow('Bathrooms', '${unitType.bathrooms}'),
          _buildUnitTypeInfoRow('Floors', '${unitType.floors}'),
        ],
      ),
    );
  }

  Widget _buildUnitTypeInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }

  void _addUnitType() {
    showDialog(
      context: context,
      builder: (context) => _UnitTypeDialog(
        onAdd: (unitType) {
          setState(() {
            _unitTypes.add(unitType);
            _selectedUnitTypeIndex = _unitTypes.length - 1;
          });
        },
      ),
    );
  }

  void _editUnitType(int index) {
    showDialog(
      context: context,
      builder: (context) => _UnitTypeDialog(
        unitType: _unitTypes[index],
        onAdd: (unitType) {
          setState(() {
            _unitTypes[index] = unitType;
          });
        },
      ),
    );
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final newProject = ProjectModel(
      id: widget.project?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      description: _descController.text,
      imageUrl: _imageUrl,
      imageGallery: _imageGallery,
      profileImageUrl: _profileImageUrl.isEmpty ? null : _profileImageUrl,
      status: _statusController.text,
      isFeatured: _isFeatured,
      features: _facilities,
      // Projects Page Fields
      subtitle:
          _subtitleController.text.isEmpty ? null : _subtitleController.text,
      stockRemaining: int.tryParse(_stockController.text),
      installmentStarting: double.tryParse(_installmentController.text),
      lastUpdated: DateTime.now(), // Auto-set to current time
      brochureUrl: _brochureUrlController.text.isEmpty
          ? null
          : _brochureUrlController.text,
      priceMin: double.tryParse(_priceMinController.text),
      priceMax: double.tryParse(_priceMaxController.text),
      bedrooms: int.tryParse(_bedroomsController.text),
      landArea: double.tryParse(_landAreaController.text),
      buildingArea: double.tryParse(_buildingAreaController.text),
      certificateType: _certificateController.text.isEmpty
          ? null
          : _certificateController.text,
      developerName:
          _developerController.text.isEmpty ? null : _developerController.text,
      fullAddress:
          _addressController.text.isEmpty ? null : _addressController.text,
      district:
          _districtController.text.isEmpty ? null : _districtController.text,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      province:
          _provinceController.text.isEmpty ? null : _provinceController.text,
      adImageUrl: _adImageUrl.isEmpty ? null : _adImageUrl,
      nearbyLocations: _nearbyLocations,
      unitTypes: _unitTypes,
    );

    widget.onSave(newProject);
    Navigator.of(context).pop();
  }
}

// Helper Dialog for Adding Nearby Locations
class _NearbyLocationDialog extends StatefulWidget {
  final String category;
  final Function(NearbyLocationModel) onAdd;

  const _NearbyLocationDialog({
    required this.category,
    required this.onAdd,
  });

  @override
  State<_NearbyLocationDialog> createState() => _NearbyLocationDialogState();
}

class _NearbyLocationDialogState extends State<_NearbyLocationDialog> {
  final _nameController = TextEditingController();
  final _distanceController = TextEditingController();
  String _distanceUnit = 'KM';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Nearby Location'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Location Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _distanceController,
                  decoration: const InputDecoration(
                    labelText: 'Distance',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _distanceUnit,
                items: const [
                  DropdownMenuItem(value: 'KM', child: Text('KM')),
                  DropdownMenuItem(value: 'MENIT', child: Text('MENIT')),
                ],
                onChanged: (value) {
                  setState(() => _distanceUnit = value!);
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _distanceController.text.isNotEmpty) {
              widget.onAdd(
                NearbyLocationModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  category: widget.category,
                  distance: double.parse(_distanceController.text),
                  distanceUnit: _distanceUnit,
                ),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// Helper Dialog for Adding/Editing Unit Types
class _UnitTypeDialog extends StatefulWidget {
  final UnitTypeModel? unitType;
  final Function(UnitTypeModel) onAdd;

  const _UnitTypeDialog({
    this.unitType,
    required this.onAdd,
  });

  @override
  State<_UnitTypeDialog> createState() => _UnitTypeDialogState();
}

class _UnitTypeDialogState extends State<_UnitTypeDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _landAreaController;
  late TextEditingController _buildingAreaController;
  late TextEditingController _bedroomsController;
  late TextEditingController _bathroomsController;
  late TextEditingController _floorsController;

  @override
  void initState() {
    super.initState();
    final u = widget.unitType;
    _nameController = TextEditingController(text: u?.name ?? '');
    _priceController = TextEditingController(text: u?.price.toString() ?? '');
    _landAreaController =
        TextEditingController(text: u?.landArea.toString() ?? '');
    _buildingAreaController =
        TextEditingController(text: u?.buildingArea.toString() ?? '');
    _bedroomsController =
        TextEditingController(text: u?.bedrooms.toString() ?? '');
    _bathroomsController =
        TextEditingController(text: u?.bathrooms.toString() ?? '');
    _floorsController =
        TextEditingController(text: u?.floors.toString() ?? '1');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.unitType == null ? 'Add Unit Type' : 'Edit Unit Type'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Unit Type Name (e.g., Type 138)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price (Rp)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _landAreaController,
                    decoration: const InputDecoration(
                      labelText: 'Land Area (m²)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _buildingAreaController,
                    decoration: const InputDecoration(
                      labelText: 'Building Area (m²)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _bedroomsController,
                    decoration: const InputDecoration(
                      labelText: 'Bedrooms',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _bathroomsController,
                    decoration: const InputDecoration(
                      labelText: 'Bathrooms',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _floorsController,
              decoration: const InputDecoration(
                labelText: 'Number of Floors',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onAdd(
                UnitTypeModel(
                  id: widget.unitType?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  price: double.tryParse(_priceController.text) ?? 0,
                  landArea: double.tryParse(_landAreaController.text) ?? 0,
                  buildingArea:
                      double.tryParse(_buildingAreaController.text) ?? 0,
                  bedrooms: int.tryParse(_bedroomsController.text) ?? 0,
                  bathrooms: int.tryParse(_bathroomsController.text) ?? 0,
                  floors: int.tryParse(_floorsController.text) ?? 1,
                ),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
