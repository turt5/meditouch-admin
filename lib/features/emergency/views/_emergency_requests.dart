import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:meditouch_admin/core/utils/_datetimeformat.dart';
import 'package:meditouch_admin/features/emergency/models/_emergency_service_model.dart';
import 'package:meditouch_admin/features/emergency/services/_emergency_services.dart';
import 'package:shimmer/shimmer.dart';

class EmergencyRequests extends StatefulWidget {
  const EmergencyRequests({super.key, required this.width});

  final double width;
  @override
  _ManageNurseState createState() => _ManageNurseState();
}

class _ManageNurseState extends State<EmergencyRequests> {
  final TextEditingController _filterController = TextEditingController();
  List<EmergencyServiceModel> _filteredRequests = [];
  List<EmergencyServiceModel> _allRequests = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(theme),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StreamBuilder<List<EmergencyServiceModel>>(
              stream: EmergencyServices().getEmergencyRequests(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 10, // Number of shimmer cards to display
                    itemBuilder: (context, index) {
                      return buildShimmerCard(
                          widget.width, 120, theme); // Adjust height as needed
                    },
                  );
                }

                // Filter out the done requests
                final requests = snapshot.data ?? [];
                requests.removeWhere((element) => element.status == 'done');

                // Sort the list by request time
                requests.sort((a, b) => b.requestTime.compareTo(a.requestTime));

                if (requests.isNotEmpty) {
                  _allRequests = requests;

                  // Apply filter
                  _filteredRequests = _filterRequest(_filterController.text);

                  // Check if any nurses match the search criteria
                  if (_filteredRequests.isEmpty) {
                    return Center(child: Text('No search results found.'));
                  }

                  return _buildDoctorInfoCard(
                      theme, _filteredRequests, widget.width);
                } else {
                  return Center(child: Text('No requests found!'));
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  List<EmergencyServiceModel> _filterRequest(String query) {
    if (query.isEmpty) {
      return _allRequests;
    }
    return _allRequests.where((request) {
      final searchLower = query.toLowerCase();
      return request.name.toLowerCase().contains(searchLower) ||
          request.email.toLowerCase().contains(searchLower) ||
          request.phone.toLowerCase().contains(searchLower);
    }).toList();
  }

  // Widget to build the search bar and title
  Widget _buildTopBar(ColorScheme theme) {
    return Container(
      height: 100,
      width: widget.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Emergency Requests',
            style: TextStyle(
              fontSize: 20,
              color: theme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: widget.width * .4,
            child: CupertinoTextField(
              controller: _filterController,
              placeholder: 'Search by name, email, phone, etc.',
              onChanged: (value) {
                setState(() {
                  _filteredRequests = _filterRequest(value);
                });
              },
              placeholderStyle:
                  TextStyle(color: theme.onSurface.withOpacity(.5)),
              prefix: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(Icons.search, color: theme.primary),
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Doctor info card builder
  Widget _buildDoctorInfoCard(
      ColorScheme theme, List<EmergencyServiceModel> requests, double width) {
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        final bool hasValidLocation =
            request.latitude != 0.0 && request.longitude != 0.0;

        // Determine if it's a small or large screen
        final bool isWide = width > 800;

        return Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildDoctorCardContent(
                      theme, request, width, isWide, hasValidLocation),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildDoctorCardContent(
                      theme, request, width, isWide, hasValidLocation),
                ),
        );
      },
    );
  }

  Widget buildShimmerCard(double width, double height, ColorScheme theme) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: theme.primary.withOpacity(0.3),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  List<Widget> _buildDoctorCardContent(
      ColorScheme theme,
      EmergencyServiceModel request,
      double width,
      bool isWide,
      bool hasValidLocation) {
    return [
      // Profile Image
      ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: CachedNetworkImage(
          imageUrl: request.image,
          width: isWide ? 200 : width * 0.3,
          height: isWide ? 200 : width * 0.3,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, child, loadingProgress) {
            return SizedBox(
              width: isWide ? 120 : 80,
              height: isWide ? 120 : 80,
              child: Center(
                child: CupertinoActivityIndicator(
                  radius: 12,
                  color: theme.onSurface,
                ),
              ),
            );
          },
        ),
      ),

      const SizedBox(
        width: 20,
        height: 20,
      ),

      // Text Information
      Expanded(
        flex: isWide ? 2 : 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.name,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            _buildInfoRow('Email:', request.email, theme),
            _buildInfoRow('Phone:', request.phone, theme),
            _buildInfoRow('Service:', request.service, theme),
            _buildInfoRow(
              'Request Time:',
              AppDateTimeFormat().formatTimestamp(request.requestTime),
              theme,
            ),
            _buildInfoRow(
              'Status:',
              request.status.toUpperCase(),
              theme,
              customStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: request.status == 'pending' ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(
        width: 30,
        height: 30,
      ),
      // Map and Complete Button
      if (isWide)
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasValidLocation) _buildMap(request),
              const SizedBox(height: 10),
              _buildCompleteButton(request.emergencyId, width),
            ],
          ),
        )
      else
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasValidLocation) _buildMap(request),
            const SizedBox(height: 10),
            _buildCompleteButton(request.emergencyId, width),
          ],
        ),
    ];
  }

  Widget _buildInfoRow(String label, String value, ColorScheme theme,
      {TextStyle? customStyle}) {
    return Row(
      children: [
        Text(
          '$label ',
          style: TextStyle(
            color: theme.onSurface.withOpacity(.5),
            fontSize: 13,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: customStyle ??
                const TextStyle(
                  fontSize: 13,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteButton(String id, double width) {
    final bool isWide = width > 800; // Adjust button size based on screen width

    return GestureDetector(
      onTap: () async {
        // Update the status of the request to done
        await EmergencyServices().updateEmergencyRequestStatus(id, 'done');
      },
      child: Container(
        width: isWide ? 200 : width * 0.5,
        height: isWide ? 45 : 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Mark as done',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(EmergencyServiceModel request) {
    // Fallback values for latitude and longitude
    double latitude = request.latitude != 0.0
        ? request.latitude
        : 37.4219983; // Example default lat
    double longitude = request.longitude != 0.0
        ? request.longitude
        : -122.084; // Example default lng

    return GestureDetector(
      onTap: () {
        print('Tapped on map');
        // Show fullscreen map when tapped
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ShowFullScreenMap(location: LatLng(latitude, longitude)),
          ),
        );
      },
      child: Container(
        width: 200,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Center(
            child: Text('View Location on Map',
                style: TextStyle(color: Colors.black))),
      ),
    );
  }
}

class ShowFullScreenMap extends StatelessWidget {
  const ShowFullScreenMap({super.key, required this.location});

  final LatLng location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: location,
          initialZoom: 15.0,
          maxZoom: 18.0,
          minZoom: 5.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: location,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
