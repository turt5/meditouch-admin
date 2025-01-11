import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditouch_admin/features/add_doctor/controller/add_doctor_controller.dart';
import 'package:meditouch_admin/shared/widgets/_custom_button.dart';
import 'package:meditouch_admin/shared/widgets/_custom_textfield.dart';

class AddDoctorPage extends StatelessWidget {
  AddDoctorPage({super.key});

  final AddDoctorController controller = Get.find<AddDoctorController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        surfaceTintColor: theme.surface,
        shadowColor: theme.primary.withOpacity(.1),
        toolbarHeight: 90,
        title: Text('Add Doctor',
            style: TextStyle(
                color: theme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 610;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildTopBar(theme),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Insert doctor details below:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      _buildResponsiveTextField(
                        hint: 'Name',
                        controller: controller.nameController,
                        isWide: isWide,
                        theme: theme,
                      ),
                      const SizedBox(height: 10),
                      _buildResponsiveTextField(
                        hint: 'Email',
                        controller: controller.emailController,
                        isWide: isWide,
                        theme: theme,
                      ),
                      const SizedBox(height: 10),
                      _buildResponsiveTextField(
                        hint: 'Phone',
                        controller: controller.phoneController,
                        isWide: isWide,
                        theme: theme,
                      ),
                      const SizedBox(height: 10),
                      buildGenderPicker(isWide, theme, controller),
                      const SizedBox(height: 10),
                      _buildResponsiveTextField(
                        hint: 'District',
                        controller: controller.districtController,
                        isWide: isWide,
                        theme: theme,
                      ),
                      const SizedBox(height: 10),
                      _buildResponsiveTextField(
                        hint: 'License ID',
                        controller: controller.licsenseIdController,
                        isWide: isWide,
                        theme: theme,
                      ),
                      const SizedBox(height: 10),
                      _buildResponsiveTextField(
                        hint: 'Visit Fee',
                        controller: controller.visitingFeeController,
                        isWide: isWide,
                        theme: theme,
                      ),
                      const SizedBox(height: 10),
                      _buildResponsiveTextField(
                        hint: 'Specialization',
                        controller: controller.specializationController,
                        isWide: isWide,
                        theme: theme,
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          controller.selectDOB();
                        },
                        child: Container(
                          width: isWide ? 400 : double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child:
                              GetX<AddDoctorController>(builder: (context) {
                            return Text(controller.dob.value == null
                                ? "Select DOB"
                                : controller.dob.value
                                    .toString()
                                    .split(" ")[0]);
                          })),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          controller.pickImage();
                        },
                        child: Container(
                          width: isWide ? 400 : double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child:
                              GetX<AddDoctorController>(builder: (context) {
                            return Text(controller.image.value == null
                                ? "Select Image"
                                : controller.image.value.name
                                    .toString()
                                    .split(" ")[0]);
                          })),
                        ),
                      ),
                      buildDegreeField(constraints.maxWidth, theme, controller),
                      const SizedBox(height: 20),
                      CustomButton(
                        onTap: () =>
                            controller.setCounter = controller.getCounter + 1,
                        label: 'Add a degree',
                        bgColor: theme.secondary,
                        fgColor: theme.onSecondary,
                        width: isWide ? 400 : double.infinity,
                        height: 50,
                      ),
                      const SizedBox(height: 20),
                      GetX<AddDoctorController>(builder: (registerController) {
                        return CustomButton(
                          onTap: () {
                            controller.registerDoctor();
                          },
                          label: 'Add Doctor',
                          bgColor: theme.primary,
                          fgColor: theme.onPrimary,
                          width: isWide ? 400 : double.infinity,
                          height: 50,
                          isLoading: registerController.isLoading.value,
                        );
                      }),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Obx buildGenderPicker(
      bool isWide, ColorScheme theme, AddDoctorController controller) {
    return Obx(() {
      return Container(
        width: isWide ? 400 : double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: theme.primary.withOpacity(.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text(
              'Select gender',
              style: TextStyle(
                fontSize: 13,
                color: theme.onSurface.withOpacity(.5),
              ),
            ),
            value: controller.getSelectedGender,
            icon: Icon(Icons.arrow_drop_down, color: theme.primary),
            onChanged: (String? newValue) {
              controller.setSelectedGender = newValue;
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
        ),
      );
    });
  }

  Widget _buildResponsiveTextField({
    required String hint,
    required TextEditingController controller,
    required bool isWide,
    required ColorScheme theme,
  }) {
    return CustomTextField(
      height: 50,
      hint: hint,
      width: isWide ? 400 : double.infinity,
      controller: controller,
      bgColor: theme.primary.withOpacity(.1),
      hintColor: theme.onSurface.withOpacity(.5),
      textColor: theme.onSurface,
    );
  }

  Obx buildDegreeField(
      double width, ColorScheme theme, AddDoctorController controller) {
    return Obx(() {
      return Column(
        children: List.generate(controller.getCounter, (index) {
          final isWide = width >= 610;

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
              (width < 610)
                  ? Row(
                      children: [
                        Expanded(
                          flex: isWide ? 3 : 5,
                          child: CustomTextField(
                            width: 300,
                            height: 50,
                            hint: 'Degree',
                            controller: controller.textControllers[index][0],
                            bgColor: theme.primary.withOpacity(.1),
                            hintColor: theme.onSurface.withOpacity(.5),
                            textColor: theme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: isWide ? 1 : 3,
                          child: CustomTextField(
                            width: 300,
                            height: 50,
                            hint: 'Year',
                            controller: controller.textControllers[index][1],
                            bgColor: theme.primary.withOpacity(.1),
                            hintColor: theme.onSurface.withOpacity(.5),
                            textColor: theme.onSurface,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        CustomTextField(
                          width: 300,
                          height: 50,
                          hint: 'Degree',
                          controller: controller.textControllers[index][0],
                          bgColor: theme.primary.withOpacity(.1),
                          hintColor: theme.onSurface.withOpacity(.5),
                          textColor: theme.onSurface,
                        ),
                        const SizedBox(width: 10),
                        CustomTextField(
                          width: 100,
                          height: 50,
                          hint: 'Year',
                          controller: controller.textControllers[index][1],
                          bgColor: theme.primary.withOpacity(.1),
                          hintColor: theme.onSurface.withOpacity(.5),
                          textColor: theme.onSurface,
                        ),
                      ],
                    ),
              const SizedBox(height: 10),
              width > 610
                  ? Row(
                      children: [
                        CustomTextField(
                          width: 300,
                          height: 50,
                          hint: 'Institution',
                          controller: controller.textControllers[index][2],
                          bgColor: theme.primary.withOpacity(.1),
                          hintColor: theme.onSurface.withOpacity(.5),
                          textColor: theme.onSurface,
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.removeByIndex(index);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.error,
                              foregroundColor: theme.onError,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Remove'),
                          ),
                        )
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            width: 300,
                            height: 50,
                            hint: 'Institution',
                            controller: controller.textControllers[index][2],
                            bgColor: theme.primary.withOpacity(.1),
                            hintColor: theme.onSurface.withOpacity(.5),
                            textColor: theme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.removeByIndex(index);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.error,
                              foregroundColor: theme.onError,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Remove'),
                          ),
                        )
                      ],
                    ),
            ],
          );
        }),
      );
    });
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
}
