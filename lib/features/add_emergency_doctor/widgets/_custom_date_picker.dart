import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewmodels/_add_emergency_doctor_vm.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    super.key,
    required this.label,
    required this.width,
    required this.height,
    required this.bgColor,
    required this.fgColor,
    required this.hasBorder,
    this.borderColor,
  });

  final String label;
  final double width;
  final double height;
  final Color bgColor;
  final Color fgColor;
  final bool hasBorder;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final AddEmergencyDoctorController controller = Get.find();

    void _pickDate() async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: controller.dob.value ?? DateTime.now(), // Use the controller's dob
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

      // If a valid date is picked, update it in the controller
      if (picked != null) {
        controller.setDob(picked); // Update the controller's dob value
      }
    }

    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
          border: hasBorder && borderColor != null
              ? Border.all(color: borderColor!, width: 2)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Obx(  // Use Obx instead of GetBuilder to listen to the dob value
            () {
              final selectedDate = controller.dob.value;
              return Text(
                selectedDate == null
                    ? label
                    : "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                style: TextStyle(color: fgColor),
              );
            },
          ),
        ),
      ),
    );
  }
}
