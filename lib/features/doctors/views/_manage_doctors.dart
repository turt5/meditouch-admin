import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditouch_admin/features/doctors/models/_doctor_model.dart';
import 'package:meditouch_admin/features/doctors/services/_doctor_service2.dart';

class ManageDoctor extends StatelessWidget {
  ManageDoctor({super.key});

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
            child: StreamBuilder<List<DoctorModel>>(
              stream: DoctorService2().getDoctors(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CupertinoActivityIndicator(
                      radius: 12,
                      color: theme.primary,
                    ),
                  );
                }

                // Once data is loaded, we display it in a DataTable
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final doctors = snapshot.data!;

                  if (doctors.length == 0) {
                    return Center(child: Text('No doctors available.'));
                  }

                  return _buildDoctorInfoCard(theme, doctors);
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

  Widget _buildDoctorInfoCard(ColorScheme theme, List<DoctorModel> doctors) {
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
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
                      color: theme.secondary.withOpacity(0.7), width: 2),
                ),
                padding: const EdgeInsets.all(3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.network(
                    doctor.image,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, color: Colors.red);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return SizedBox(
                        width: 120,
                        height: 120,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(doctor.speciality,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: theme.primary)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('License Id:',
                          style: TextStyle(
                              color: theme.onSurface.withOpacity(.5),
                              fontSize: 16)),
                      const SizedBox(width: 5),
                      Text(doctor.licenceId),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Email:',
                          style: TextStyle(
                              color: theme.onSurface.withOpacity(.5),
                              fontSize: 16)),
                      const SizedBox(width: 5),
                      Text(doctor.email),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Gender:',
                          style: TextStyle(
                              color: theme.onSurface.withOpacity(.5),
                              fontSize: 16)),
                      const SizedBox(width: 5),
                      Text(doctor.gender),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Phone:',
                          style: TextStyle(
                              color: theme.onSurface.withOpacity(.5),
                              fontSize: 16)),
                      const SizedBox(width: 5),
                      Text(doctor.phone),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('District:',
                          style: TextStyle(
                              color: theme.onSurface.withOpacity(.5),
                              fontSize: 16)),
                      const SizedBox(width: 5),
                      Text(doctor.district),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Visiting Fee:',
                          style: TextStyle(
                              color: theme.onSurface.withOpacity(.5),
                              fontSize: 16)),
                      const SizedBox(width: 5),
                      Text(doctor.visitFee.toString()),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text('Degrees:',
                      style: TextStyle(
                          fontSize: 16,
                          color: theme.onSurface.withOpacity(.5))),
                  const SizedBox(height: 5),
                  ...doctor.degrees.map((degree) {
                    return Text(
                      '${degree.degree} from ${degree.institution} (${degree.year})',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    );
                  }),
                  const SizedBox(height: 10),
                  Text('Available Time Slots:',
                      style: TextStyle(
                          fontSize: 16,
                          color: theme.onSurface.withOpacity(.5))),
                  if (doctor.timeSlots.isEmpty)
                    const Text('Not added yet!',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  ...doctor.timeSlots.map((slot) {
                    return Text(
                      slot,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    );
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(ColorScheme theme) {
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

        ],
      ),
    );
  }


  final TextEditingController _filterController = TextEditingController();

  final List<String> columns = [
    "Image",
    "License ID",
    "Name",
    "Gender",
    "Email",
    "Phone",
    "Speciality",
    "District",
    "Visit Fee",
    "Time Slots",
    "Degrees"
  ];
}
