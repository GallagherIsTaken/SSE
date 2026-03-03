import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/models/contact_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../widgets/common/project_location_map.dart';

/// Contact tab body: Marketing list, office info, map.
class ContactTabContent extends StatefulWidget {
  const ContactTabContent({super.key});

  @override
  State<ContactTabContent> createState() => _ContactTabContentState();
}

class _ContactTabContentState extends State<ContactTabContent> {
  final _repository = ProjectRepository();
  final _firebaseService = FirebaseService();
  List<ContactModel> _contacts = [];
  bool _isLoading = true;
  double? _officeLat;
  double? _officeLng;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _repository.getContacts(),
        _firebaseService.getOfficeLocation(),
      ]);
      final contacts = results[0] as List<ContactModel>;
      final location = results[1] as Map<String, double?>;
      setState(() {
        _contacts = contacts;
        _officeLat = location['lat'];
        _officeLng = location['lng'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openWhatsApp(ContactModel contact) async {
    final url = Uri.parse(contact.whatsappUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo-only header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Image.asset(
              'assets/icons/logo.png',
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback: Show app name if logo not found
                return const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: AppColors.textDarkGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                const SizedBox(height: 40), // Increased spacing
                Text(
                  'Marketing Kami',
                  style:
                      AppTextStyles.sectionHeading(color: AppColors.textBlack),
                ),
                const SizedBox(height: 16),

                // Loading or contacts list
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_contacts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'No contacts available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ..._contacts.map((contact) => _buildMarketingCard(contact)),

                const SizedBox(height: 24),
                _buildOrangeDivider(),
                const SizedBox(height: 16),
                _buildOfficeHours(),
                const SizedBox(height: 8),
                _buildPhone(),
                const SizedBox(height: 8),
                _buildInstagram(),
                const SizedBox(height: 16),
                _buildOfficeMap(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppStrings.contact,
          style: AppTextStyles.extraLargeHeading(color: AppColors.textBlack),
        ),
        const SizedBox(width: 8),
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColors.orange,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildMarketingCard(ContactModel contact) {
    return InkWell(
      onTap: () => _openWhatsApp(contact),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primaryDarkGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(contact),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: AppTextStyles.bodyText(
                      color: AppColors.textWhite,
                      fontSize: 16,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.description,
                    style: AppTextStyles.small(
                        color: AppColors.textWhite.withOpacity(0.85)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ContactModel contact) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.orange, width: 2),
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.lightGray,
            backgroundImage: contact.profilePictureUrl.isNotEmpty
                ? NetworkImage(contact.profilePictureUrl)
                : null,
            child: contact.profilePictureUrl.isEmpty
                ? const Icon(Icons.person, color: AppColors.darkGray, size: 28)
                : null,
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
            style: AppTextStyles.bodyText(
                color: AppColors.textBlack, fontSize: 14),
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
          style:
              AppTextStyles.bodyText(color: AppColors.textBlack, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildInstagram() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt_outlined,
            size: 20, color: AppColors.textDarkGreen),
        const SizedBox(width: 8),
        Text(
          '@sumbersentuhanemas.official',
          style:
              AppTextStyles.bodyText(color: AppColors.textBlack, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildOfficeMap() {
    if (_officeLat != null && _officeLng != null) {
      return ProjectLocationMap(
        latitude: _officeLat!,
        longitude: _officeLng!,
        projectName: 'Kantor Sumber Sentuhan Emas',
        height: 200,
      );
    }
    // Fallback placeholder
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
