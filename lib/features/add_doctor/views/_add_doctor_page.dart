import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch_admin/features/add_doctor/services/_doctor_service.dart';
import 'package:meditouch_admin/features/add_doctor/widgets/_date_picker.dart';
import 'package:meditouch_admin/features/add_doctor/widgets/_imagepicker.dart';
import 'package:meditouch_admin/shared/services/_email_verifier.dart';
import 'package:meditouch_admin/shared/widgets/_custom_alert.dart';
import 'package:meditouch_admin/shared/widgets/_custom_button.dart';
import 'package:meditouch_admin/shared/widgets/_custom_loading.dart';
import 'package:meditouch_admin/shared/widgets/_custom_textfield.dart';

import '../viewmodels/_add_doctor_vm.dart';

class AddDoctorPage extends StatelessWidget {
  AddDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(theme),
        const SizedBox(height: 20),
        Expanded(
            child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Insert doctor details below:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                    height: 50,
                    hint: 'Name',
                    width: 500,
                    controller: nameController,
                    bgColor: theme.primary.withOpacity(.1),
                    hintColor: theme.onSurface.withOpacity(.5),
                    textColor: theme.onSurface),
                const SizedBox(height: 10),
                CustomTextField(
                    height: 50,
                    hint: 'Email',
                    width: 500,
                    controller: emailController,
                    bgColor: theme.primary.withOpacity(.1),
                    hintColor: theme.onSurface.withOpacity(.5),
                    textColor: theme.onSurface),
                const SizedBox(height: 10),
                CustomTextField(
                    height: 50,
                    hint: 'Phone',
                    width: 500,
                    controller: phoneController,
                    bgColor: theme.primary.withOpacity(.1),
                    hintColor: theme.onSurface.withOpacity(.5),
                    textColor: theme.onSurface),
                const SizedBox(height: 10),
                Consumer(builder: (context, ref, child) {
                  final read = ref.watch(addDoctorViewModelProvider);
                  final write = ref.read(addDoctorViewModelProvider.notifier);
                  return Container(
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 500,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text('Select gender',
                            style: TextStyle(
                                fontSize: 13,
                                color: theme.onSurface.withOpacity(.5))),
                        value: read.selectedGender == null
                            ? null
                            : read.selectedGender,
                        icon: Icon(Icons.arrow_drop_down, color: theme.primary),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            write.selectedGender = newValue;
                          }
                        },
                        items: read.genderList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: theme.onSurface, fontSize: 13),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                CustomTextField(
                    height: 50,
                    hint: 'District',
                    width: 500,
                    controller: districtController,
                    bgColor: theme.primary.withOpacity(.1),
                    hintColor: theme.onSurface.withOpacity(.5),
                    textColor: theme.onSurface),
                const SizedBox(height: 10),
                CustomTextField(
                    height: 50,
                    hint: 'Licence ID',
                    width: 500,
                    controller: licenceIdController,
                    bgColor: theme.primary.withOpacity(.1),
                    hintColor: theme.onSurface.withOpacity(.5),
                    textColor: theme.onSurface),
                const SizedBox(height: 10),
                CustomTextField(
                    height: 50,
                    hint: 'Visiting Fee',
                    width: 500,
                    controller: visitingFeeController,
                    bgColor: theme.primary.withOpacity(.1),
                    hintColor: theme.onSurface.withOpacity(.5),
                    textColor: theme.onSurface),
                const SizedBox(height: 10),
                CustomDatePicker(
                    label: 'Select date of birth',
                    width: 500,
                    height: 50,
                    bgColor: theme.primary.withOpacity(.1),
                    fgColor: theme.onSurface,
                    hasBorder: false),
                const SizedBox(height: 10),
                CustomTextField(
                    height: 50,
                    hint: 'Speciality',
                    width: 500,
                    controller: specialityController,
                    bgColor: theme.primary.withOpacity(.1),
                    hintColor: theme.onSurface.withOpacity(.5),
                    textColor: theme.onSurface),
                const SizedBox(height: 10),
                Consumer(builder: (context, ref, child) {
                  final read = ref.watch(addDoctorViewModelProvider);
                  final write = ref.read(addDoctorViewModelProvider.notifier);
                  return CustomButton(
                      onTap: () {
                        write.counter = read.counter + 1;
                      },
                      label: 'Add a degree',
                      bgColor: theme.primary.withOpacity(.1),
                      fgColor: theme.onSurface,
                      width: 500,
                      height: 50);
                }),
                const SizedBox(height: 20),
                Consumer(builder: (context, ref, child) {
                  final read = ref.watch(addDoctorViewModelProvider);
                  final write = ref.read(addDoctorViewModelProvider.notifier);

                  return SizedBox(
                    width: 550,
                    child: Column(
                      children: List.generate(read.counter, (index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Degree ${index + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                                height: 50,
                                                hint: 'Degree',
                                                width: double.infinity,
                                                controller: read
                                                    .textControllers[index][0],
                                                bgColor: theme.primary
                                                    .withOpacity(.1),
                                                hintColor: theme.onSurface
                                                    .withOpacity(.5),
                                                textColor: theme.onSurface),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: CustomTextField(
                                                height: 50,
                                                hint: 'Year',
                                                width: double.infinity,
                                                controller: read
                                                    .textControllers[index][1],
                                                bgColor: theme.primary
                                                    .withOpacity(.1),
                                                hintColor: theme.onSurface
                                                    .withOpacity(.5),
                                                textColor: theme.onSurface),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      CustomTextField(
                                          height: 50,
                                          hint: 'Institution',
                                          width: double.infinity,
                                          controller:
                                              read.textControllers[index][2],
                                          bgColor:
                                              theme.primary.withOpacity(.1),
                                          hintColor:
                                              theme.onSurface.withOpacity(.5),
                                          textColor: theme.onSurface),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(Icons.delete, color: theme.error),
                                  onPressed: () {
                                    write.removeByIndex(index);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(width: 15),
                          ],
                        );
                      }),
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Consumer(builder: (context, ref, child) {
                  return CustomImagePicker(
                      width: 500,
                      height: 50,
                      bgColor: theme.primary.withOpacity(.2),
                      fgColor: theme.onSurface,
                      hasBorder: false);
                }),
                const SizedBox(height: 20),
                Consumer(builder: (context, ref, child) {
                  final read = ref.watch(addDoctorViewModelProvider);
                  final write = ref.read(addDoctorViewModelProvider);

                  return CustomButton(
                    onTap: () async {
                      String name = nameController.text.trim();
                      String email = emailController.text.trim();
                      String phone = phoneController.text.trim();
                      String district = districtController.text.trim();
                      String licenceId = licenceIdController.text.trim();
                      String visitingFee = visitingFeeController.text.trim();
                      String speciality = specialityController.text.trim();

                      String? gender = read.selectedGender;
                      DateTime? dob = read.dob;

                      // String name = 'Dr. Suman Chakrabarty';
                      // String email = 'musfiqm77@gmail.com';
                      // String phone = '01700000000';
                      // String district = 'Dhaka';
                      // String licenceId = '123456';
                      // String visitingFee = '500';
                      // String speciality = 'Cardiologist';
                      // String gender= 'Male';
                      // DateTime dob = DateTime.parse('1990-01-01');





                      XFile? image = read.image;
                      List<List<TextEditingController>> controllers = read.textControllers;
                      List<Map<String, String>> degrees = controllers.map((e) {
                        return {
                          'degree': e[0].text.trim(),
                          'year': e[1].text.trim(),
                          'institution': e[2].text.trim()
                        };
                      }).toList();


                      // List<Map<String, String>> degrees = [
                      //   {
                      //     'degree': 'MBBS',
                      //     'year': '2015',
                      //     'institution': 'Dhaka Medical College'
                      //   },
                      //   {
                      //     'degree': 'MD',
                      //     'year': '2019',
                      //     'institution': 'BSMMU'
                      //   }
                      // ];

                      // Define a validation helper function
                      bool validateField(String value, String fieldName) {
                        if (value.isEmpty) {
                          showCustomAlert(context, '$fieldName cannot be empty', theme.error, theme.onError);
                          return false;
                        }
                        return true;
                      }

                      // Validate required fields
                      if (!validateField(name, 'Name') ||
                          !validateField(email, 'Email') ||
                          !validateField(phone, 'Phone') ||
                          !validateField(district, 'District') ||
                          !validateField(licenceId, 'Licence') ||
                          !validateField(visitingFee, 'Visiting fee') ||
                          !validateField(speciality, 'Speciality')) {
                        return;
                      }

                      if (gender == null) {
                        showCustomAlert(context, 'Please select gender', theme.error, theme.onError);
                        return;
                      }

                      if (dob == null) {
                        showCustomAlert(context, 'Please select date of birth', theme.error, theme.onError);
                        return;
                      }

                      if (image == null) {
                        showCustomAlert(context, 'Please select an image', theme.error, theme.onError);
                        return;
                      }

                      if (degrees.isEmpty) {
                        showCustomAlert(context, 'Please add at least one degree', theme.error, theme.onError);
                        return;
                      }

                      showCustomLoadingDialog(context);

                      if(!await EmailVerifier().verify(email)){
                        Navigator.pop(context);
                        showCustomAlert(
                            context,
                            'Invalid email address!',
                            theme.error,
                            theme.onError
                        );
                        return;
                      }

                      // Upload image and check result
                      String imageUrl = await DoctorService().uploadImage(image);

                      if (imageUrl.isEmpty || imageUrl == '') {
                        Navigator.pop(context);
                        showCustomAlert(
                            context,
                            'Something went wrong, please try again later!',
                            theme.error,
                            theme.onError
                        );
                        return;
                      }




                      // Prepare the data for adding doctor
                      bool response = await DoctorService().addDoctor({
                        'name': name,
                        'email': email,
                        'phone': phone,
                        'district': district,
                        'licenceId': licenceId,
                        'visitingFee': int.parse(visitingFee),
                        'speciality': speciality,
                        'gender': gender,
                        'dob': dob,
                        'image': imageUrl,
                        'degrees': degrees.map((e) {
                          return {
                            'degree': e['degree'],
                            'year': e['year'],
                            'institution': e['institution']
                          };
                        }).toList(),
                        'createdAt': DateTime.now().toString(),
                        'time-slot': []
                      });

                      Navigator.pop(context);

                      if (response) {
                        showCustomAlert(context, 'Doctor added successfully', theme.primary, theme.onPrimary);

                        // Clear the form fields
                        nameController.clear();
                        emailController.clear();
                        phoneController.clear();
                        districtController.clear();
                        licenceIdController.clear();
                        visitingFeeController.clear();
                        specialityController.clear();
                        write.dob = null;
                        write.selectedGender = null;
                        write.image = null;
                        write.counter = 0;
                        write.clearControllers();
                      } else {
                        showCustomAlert(context, 'Something went wrong, please try again later!', theme.error, theme.onError);
                      }
                    },
                    label: "Register Doctor",
                    bgColor: theme.primary,
                    fgColor: theme.onPrimary,
                    width: 500,
                    height: 50,
                  );

                }),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ))
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
            'Register a doctor',
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

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController licenceIdController = TextEditingController();
  TextEditingController visitingFeeController = TextEditingController();
  TextEditingController specialityController = TextEditingController();
}
