import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditouch_admin/features/add_doctor/viewmodels/_add_doctor_vm.dart';

class CustomImagePicker extends ConsumerWidget {
  const CustomImagePicker({
    super.key,
    required this.width,
    required this.height,
    required this.bgColor,
    required this.fgColor,
    required this.hasBorder,
    this.borderColor,
  });

  final double width;
  final double height;
  final Color bgColor;
  final Color fgColor;
  final bool hasBorder;
  final Color? borderColor;

  Future<void> _pickImage(WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      ref.read(addDoctorViewModelProvider).setImage = image;
      print('Image path: ${image.path}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(addDoctorViewModelProvider).getImage;

    return InkWell(
      onTap: () => _pickImage(ref),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: bgColor,
          border: hasBorder && borderColor != null
              ? Border.all(color: borderColor!, width: 2)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: imageState == null
              ? Text(
            'Pick an image',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: fgColor),
          )
              : Text(
                imageState.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: fgColor),
              ),
        ),
      ),
    );
  }
}
