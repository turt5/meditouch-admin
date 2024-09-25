import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditouch_admin/features/doctors/models/_doctor_model.dart';
import 'package:meditouch_admin/features/doctors/services/_doctor_service2.dart';

class ManageDoctor extends StatelessWidget {
  const ManageDoctor({super.key});

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
                  return SingleChildScrollView(
                    scrollDirection:
                    Axis.horizontal, // Handle horizontal overflow
                    child: DataTableTheme(
                      data: DataTableThemeData(
                        headingRowColor: MaterialStateProperty.resolveWith(
                              (states) => theme.primary.withOpacity(0.1),
                        ),
                        headingTextStyle: TextStyle(
                          color: theme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        dataTextStyle: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      child: DataTable(
                        dataRowHeight: 80,
                        border: TableBorder.all(
                          color: theme.primary.withOpacity(0.3),
                          width: 1,
                        ),
                        columns: _buildColumns(),
                        rows: _buildRows(doctors),
                      ),
                    ),
                  );
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

  // Helper to build the columns of the DataTable
  List<DataColumn> _buildColumns() {
    return [
      const DataColumn(label: Text('Image')),
      const DataColumn(label: Text('ID')),
      const DataColumn(label: Text('Name')),
      const DataColumn(label: Text('Email')),
      const DataColumn(label: Text('Gender')),
      const DataColumn(label: Text('Phone')),
      const DataColumn(label: Text('Licence ID')),
      const DataColumn(label: Text('Speciality')),
      const DataColumn(label: Text('District')),
      const DataColumn(label: Text('Visit Fee')),
    ];
  }

  // Helper to build the rows of the DataTable from the list of DoctorModel
  List<DataRow> _buildRows(List<DoctorModel> doctors) {
    return doctors.map((doctor) {
      return DataRow(cells: [
        DataCell(CachedNetworkImage(
          imageUrl: doctor.image,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, a, b) {
            return Center(
                child: CupertinoActivityIndicator(
                  radius: 12,
                  color: Colors.blue,
                ));
          },
        )),
        DataCell(Text(doctor.id)),
        DataCell(Text(doctor.name)),
        DataCell(Text(doctor.email)),
        DataCell(Text(doctor.gender)),
        DataCell(Text(doctor.phone)),
        DataCell(Text(doctor.licenceId)),
        DataCell(Text(doctor.speciality)),
        DataCell(Text(doctor.district)),
        DataCell(Text(doctor.visitFee.toString())),
      ]);
    }).toList();
  }
}
