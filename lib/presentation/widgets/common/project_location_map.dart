import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/models/nearby_location_model.dart';

/// Reusable map widget for displaying project location
class ProjectLocationMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String projectName;
  final List<NearbyLocationModel> nearbyLocations;
  final double height;

  const ProjectLocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.projectName,
    this.nearbyLocations = const [],
    this.height = 180,
  });

  @override
  State<ProjectLocationMap> createState() => _ProjectLocationMapState();
}

class _ProjectLocationMapState extends State<ProjectLocationMap> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    // Add project marker
    _markers.add(
      Marker(
        markerId: const MarkerId('project_location'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: widget.projectName,
          snippet: 'Project Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );

    // Add nearby location markers
    for (var i = 0; i < widget.nearbyLocations.length; i++) {
      final location = widget.nearbyLocations[i];
      if (location.latitude != null && location.longitude != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('nearby_$i'),
            position: LatLng(location.latitude!, location.longitude!),
            infoWindow: InfoWindow(
              title: location.name,
              snippet: '${location.distance} ${location.distanceUnit}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              _getMarkerColor(location.category),
            ),
          ),
        );
      }
    }
  }

  double _getMarkerColor(String category) {
    switch (category) {
      case 'Pusat Perbelanjaan':
        return BitmapDescriptor.hueBlue;
      case 'Pendidikan':
        return BitmapDescriptor.hueGreen;
      case 'Kesehatan':
        return BitmapDescriptor.hueRed;
      case 'Transportasi':
        return BitmapDescriptor.hueViolet;
      default:
        return BitmapDescriptor.hueAzure;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 15,
          ),
          markers: _markers,
          onMapCreated: (controller) {
            _mapController = controller;
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          mapToolbarEnabled: false,
          compassEnabled: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
