import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditouch_admin/features/add_agent/viewmodels/_agent_viewmodel.dart';

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
    // Create a file input element for web
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Accept image files only
    uploadInput.click(); // Trigger the file picker

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final file = files[0];
      final reader = html.FileReader();
      reader.readAsDataUrl(file); // Read the file as a data URL

      reader.onLoadEnd.listen((e) {
        // Set the image in your state management
        ref.read(agentViewModelProvider).setImage=file; // Assuming your provider can accept an html.File
        print('Image name: ${file.name}'); // Display the image name
      });
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(agentViewModelProvider).getImage;

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
