import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch_admin/features/add_doctor/services/_doctor_service.dart';
import 'package:meditouch_admin/features/add_emergency_doctor/widgets/_custom_date_picker.dart';
import 'package:meditouch_admin/features/add_emergency_doctor/widgets/_custom_image_picker.dart';
import 'package:meditouch_admin/shared/widgets/_custom_alert.dart';
import 'package:meditouch_admin/shared/widgets/_custom_button.dart';
import 'package:meditouch_admin/shared/widgets/_custom_loading.dart';
import 'package:meditouch_admin/shared/widgets/_custom_textfield.dart';

import '../../../shared/services/_email_verifier.dart';
import '../services/_add_emergency_doctor_service.dart';
import '../viewmodels/_add_emergency_doctor_vm.dart';

class AddEmergencyDoctorPage extends StatelessWidget {
  AddEmergencyDoctorPage({super.key});

  final AddEmergencyDoctorController controller = Get.put(AddEmergencyDoctorController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTopBar(theme),
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
                    'Insert Emergency Doctor details below:',
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
                  Container(
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 500,
                    child: Obx(() {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text('Select gender',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: theme.onSurface.withOpacity(.5))),
                          value: controller.selectedGender.value,
                          icon: Icon(Icons.arrow_drop_down, color: theme.primary),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.setSelectedGender(newValue);
                            }
                          },
                          items: controller.genderList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: theme.onSurface, fontSize: 13),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ),
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
                      hint: 'Speciality',
                      width: 500,
                      controller: specialityController,
                      bgColor: theme.primary.withOpacity(.1),
                      hintColor: theme.onSurface.withOpacity(.5),
                      textColor: theme.onSurface),
                  const SizedBox(height: 10),
                  CustomTextField(
                      height: 50,
                      hint: 'Charge per visit',
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
                  CustomButton(
                      onTap: () {
                        controller.incrementCounter();
                      },
                      label: 'Add a degree',
                      bgColor: theme.primary.withOpacity(.1),
                      fgColor: theme.onSurface,
                      width: 500,
                      height: 50),
                  const SizedBox(height: 20),
                  Obx(() {
                    return SizedBox(
                      width: 550,
                      child: Column(
                        children: List.generate(controller.counter.value, (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
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
                                                  controller: controller.textControllers[index][0],
                                                  bgColor: theme.primary.withOpacity(.1),
                                                  hintColor: theme.onSurface.withOpacity(.5),
                                                  textColor: theme.onSurface),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: CustomTextField(
                                                  height: 50,
                                                  hint: 'Year',
                                                  width: double.infinity,
                                                  controller: controller.textControllers[index][1],
                                                  bgColor: theme.primary.withOpacity(.1),
                                                  hintColor: theme.onSurface.withOpacity(.5),
                                                  textColor: theme.onSurface),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextField(
                                            height: 50,
                                            hint: 'Institution',
                                            width: double.infinity,
                                            controller: controller.textControllers[index][2],
                                            bgColor: theme.primary.withOpacity(.1),
                                            hintColor: theme.onSurface.withOpacity(.5),
                                            textColor: theme.onSurface),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: theme.error),
                                    onPressed: () {
                                      controller.removeByIndex(index);
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
                  CustomImagePicker(
                      width: 500,
                      height: 50,
                      bgColor: theme.primary.withOpacity(.2),
                      fgColor: theme.onSurface,
                      hasBorder: false),
                  const SizedBox(height: 20),
                  CustomButton(
                    onTap: () async {
                      String name = nameController.text.trim();
                      String email = emailController.text.trim();
                      String phone = phoneController.text.trim();
                      String district = districtController.text.trim();
                      String charge = visitingFeeController.text.trim();
                      String speciality = specialityController.text.trim();

                      String? gender = controller.selectedGender.value;
                      DateTime? dob = controller.dob.value;

                      dynamic image = controller.image.value;
                      List<List<TextEditingController>> controllers = controller.textControllers;
                      List<Map<String, String>> degrees = controllers.map((e) {
                        return {
                          'degree': e[0].text.trim(),
                          'year': e[1].text.trim(),
                          'institution': e[2].text.trim()
                        };
                      }).toList();

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
                          !validateField(charge, 'Charge per hour')||
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

                      if (!await EmailVerifier().verify(email)) {
                        Navigator.pop(context);
                        showCustomAlert(context, 'Invalid email address!', theme.error, theme.onError);
                        return;
                      }

                      // Upload image and check result
                      String imageUrl = await DoctorService().uploadImage(image);

                      if (imageUrl.isEmpty || imageUrl == '') {
                        Navigator.pop(context);
                        showCustomAlert(context, 'Something went wrong, please try again later!', theme.error, theme.onError);
                        return;
                      }

                      // Prepare the data for adding doctor
                      await EmergencyDoctorService().addEmergencyDoctor({
                        'name': name,
                        'email': email,
                        'phone': phone,
                        'district': district,
                        'charge': int.parse(charge),
                        'gender': gender,
                        'dob': dob,
                        'image': imageUrl,
                        'createdAt': DateTime.now().toString(),
                        'speciality': speciality,
                        'role': 'ed',
                        'degrees': degrees.map((e) {
                          return {
                            'degree': e['degree'],
                            'year': e['year'],
                            'institution': e['institution'],
                          };
                        }).toList(),
                      });

                      Navigator.pop(context);
                    },
                    label: 'Add Emergency Doctor',
                    bgColor: theme.primary,
                    fgColor: theme.onPrimary,
                    width: 500,
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController specialityController = TextEditingController();
  final TextEditingController visitingFeeController = TextEditingController();
    
}









Widget buildTopBar(ColorScheme theme) {
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
            'Add an Emergency Doctor',
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