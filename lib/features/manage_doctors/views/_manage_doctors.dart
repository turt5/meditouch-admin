import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../models/_doctor_model.dart';
import '../services/_doctor_service2.dart';

class ManageDoctor extends StatefulWidget {
  ManageDoctor({super.key, required this.width});

  final double width;

  @override
  _ManageDoctorState createState() => _ManageDoctorState();
}

class _ManageDoctorState extends State<ManageDoctor> {
  final TextEditingController _filterController = TextEditingController();
  List<DoctorModel> _filteredDoctors = [];
  List<DoctorModel> _allDoctors = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(theme, widget.width),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder<List<DoctorModel>>(
              future: DoctorService2().getDoctors(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 5, // Show 5 shimmer placeholders
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(
                            bottom: 10), // Space between cards
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Shimmer for image
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: theme.primary.withOpacity(.3),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Shimmer for text placeholders
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor:
                                        theme.primary.withOpacity(.3),
                                    child: Container(
                                      height: 20,
                                      width: double.infinity,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor:
                                        theme.primary.withOpacity(.3),
                                    child: Container(
                                      height: 16,
                                      width: double.infinity,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor:
                                        theme.primary.withOpacity(.3),
                                    child: Container(
                                      height: 16,
                                      width: double.infinity,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor:
                                        theme.primary.withOpacity(.3),
                                    child: Container(
                                      height: 16,
                                      width: double.infinity,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                // Once data is loaded, we filter it based on the search query
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final doctors = snapshot.data!;
                  _allDoctors = doctors;

                  // Apply filter
                  _filteredDoctors = _filterDoctors(_filterController.text);

                  if (_filteredDoctors.isEmpty) {
                    return Center(child: Text('No search results found.'));
                  }

                  return _buildDoctorInfoCard(
                      theme, _filteredDoctors, widget.width);
                } else {
                  return Center(child: Text('No doctors available.'));
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Function to filter doctors based on search query
  List<DoctorModel> _filterDoctors(String query) {
    if (query.isEmpty) {
      return _allDoctors;
    }
    return _allDoctors.where((doctor) {
      final searchLower = query.toLowerCase();
      return doctor.name.toLowerCase().contains(searchLower) ||
          doctor.email.toLowerCase().contains(searchLower) ||
          doctor.phone.toLowerCase().contains(searchLower) ||
          doctor.district.toLowerCase().contains(searchLower) ||
          doctor.licenceId.toLowerCase().contains(searchLower) ||
          doctor.gender.toLowerCase().contains(searchLower) ||
          doctor.speciality.toLowerCase().contains(searchLower);
    }).toList();
  }

  // Widget to build the search bar and title
  Widget _buildTopBar(ColorScheme theme, double width) {
    return Container(
      height: 100,
      width: double.infinity,
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
            'Doctors',
            style: TextStyle(
              fontSize: 20,
              color: theme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: width * .4,
            child: CupertinoTextField(
              controller: _filterController,
              placeholderStyle:
                  TextStyle(color: theme.onSurface.withOpacity(.5)),
              placeholder: 'Search by name, email, phone, etc.',
              onChanged: (value) {
                setState(() {
                  _filteredDoctors = _filterDoctors(value);
                });
              },
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
    ColorScheme theme,
    List<DoctorModel> doctors,
    double width,
  ) {
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return LayoutBuilder(
          builder: (context, constraints) {
            // Determine if the width is wide or narrow
            bool isWideScreen = constraints.maxWidth > 600;

            return Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 10), // Space between cards
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Adjust image size based on screen width
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primary.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: theme.secondary.withOpacity(0.7),
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.network(
                        doctor.image,
                        width: isWideScreen
                            ? 150
                            : 120, // Adjust width for wider screens
                        height: isWideScreen
                            ? 150
                            : 120, // Adjust height for wider screens
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, color: Colors.red);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return SizedBox(
                            width: isWideScreen ? 150 : 120,
                            height: isWideScreen ? 150 : 120,
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
                  ),
                  const SizedBox(width: 20),
                  // Adjust the column layout based on screen width
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          doctor.speciality,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.primary),
                        ),
                        const SizedBox(height: 10),
                        _buildInfo(theme, 'Licence ID:', doctor.licenceId),
                        const SizedBox(height: 5),
                        _buildInfo(theme, 'Email:', doctor.email),
                        const SizedBox(height: 5),
                        _buildInfo(theme, 'Gender', doctor.gender),
                        const SizedBox(height: 5),
                        _buildInfo(theme, 'Phone:', doctor.phone),
                        const SizedBox(height: 5),
                        _buildInfo(theme, 'District:', doctor.district),
                        const SizedBox(height: 5),
                        _buildInfo(
                            theme, 'Date of Birth:', doctor.dob.toString()),
                        SizedBox(height: 5),
                        Text(
                          'Degrees:',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.onSurface.withOpacity(.5),
                          ),
                        ),
                        const SizedBox(height: 5),
                        ...doctor.degrees.map((degree) {
                          return Text(
                            '${degree.degree} from ${degree.institution} (${degree.year})',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          );
                        }),
                        const SizedBox(height: 10),
                        Text(
                          'Available Time Slots:',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.onSurface.withOpacity(.5),
                          ),
                        ),
                        if (doctor.timeSlots.isEmpty)
                          const Text(
                            'Not added yet!',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ...doctor.timeSlots.map((slot) {
                          return Text(
                            slot,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfo(ColorScheme theme, String label, String text) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.onSurface.withOpacity(.5),
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
            child: Tooltip(
          message: text,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ),
        )),
      ],
    );
  }
}
