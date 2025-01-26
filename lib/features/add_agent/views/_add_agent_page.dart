import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditouch_admin/features/add_agent/services/_agent_add_service.dart';
import 'package:meditouch_admin/features/add_agent/widgets/_date_picker_agent.dart';
import 'package:meditouch_admin/features/add_agent/widgets/_image_picker_agent.dart';
import 'package:meditouch_admin/features/manage_agents/models/_agent_model.dart';
import 'package:meditouch_admin/shared/services/_email_verifier.dart';
import 'package:meditouch_admin/shared/widgets/_custom_alert.dart';
import 'package:meditouch_admin/shared/widgets/_custom_button.dart';
import 'package:meditouch_admin/shared/widgets/_custom_loading.dart';
import 'package:meditouch_admin/shared/widgets/_custom_textfield.dart';

import '../viewmodels/_agent_viewmodel.dart';


class AddAgentPage extends StatelessWidget {
  AddAgentPage({super.key});

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
                      'Insert agent details below:',
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
                      final read = ref.watch(agentViewModelProvider);
                      final write = ref.read(agentViewModelProvider.notifier);
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
                            value: read.selectedGender,
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
                        hint: 'Address',
                        width: 500,
                        controller: districtController,
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
                      final read = ref.watch(agentViewModelProvider);
                      final write = ref.read(agentViewModelProvider);

                      return CustomButton(
                        onTap: () async {
                          String name = nameController.text.trim();
                          String email = emailController.text.trim();
                          String phone = phoneController.text.trim();
                          String district = districtController.text.trim();
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





                          dynamic image = read.image;


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
                              !validateField(district, 'District')) {
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
                          String imageUrl = await AgentAddService().uploadImage(image);

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
                          await AgentAddService().addAgent({
                            'name': name,
                            'email': email,
                            'phone': phone,
                            'dob': dob.toString(),
                            'address': district,
                            'gender':gender,
                            'image': imageUrl,
                            // 'role': 'ag',
                          }).then((_){
                            showCustomAlert(context, 'Agent added successfully', theme.primary, theme.onPrimary);

                            // Clear the form fields
                            nameController.clear();
                            emailController.clear();
                            phoneController.clear();
                            districtController.clear();
                            licenceIdController.clear();
                            write.dob = null;
                            write.selectedGender = null;
                            write.image = null;
                            write.counter = 0;
                            write.clearControllers();
                          }).catchError((e){
                            showCustomAlert(context, 'Something went wrong, please try again later!', theme.error, theme.onError);
                          });

                          Navigator.pop(context);
                        },
                        label: "Register Agent",
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
            'Add an agent',
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
}
