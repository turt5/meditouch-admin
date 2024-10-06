import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditouch_admin/features/add_agent/viewmodels/_agent_viewmodel.dart';
import 'package:meditouch_admin/features/add_nurse/viewmodels/_add_nurse_vm.dart';


class CustomDatePicker extends ConsumerWidget {
  const CustomDatePicker(
      {super.key,
        required this.label,
        required this.width,
        required this.height,
        required this.bgColor,
        required this.fgColor,
        required this.hasBorder,
        this.borderColor});

  final String label;
  final double width;
  final double height;
  final Color bgColor;
  final Color fgColor;
  final bool hasBorder;
  final Color? borderColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime? selectedDate = ref.watch(agentViewModelProvider).dob;

    void _pickDate() async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

      // If a valid date is picked, update it in the ViewModel
      if (picked != null && picked != selectedDate) {
        ref.read(agentViewModelProvider).setDob = picked;
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
          child: Text(
            selectedDate == null
                ? label
                : "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
            style: TextStyle(color: fgColor),
          ),
        ),
      ),
    );
  }
}