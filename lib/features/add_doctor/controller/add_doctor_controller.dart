import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditouch_admin/features/add_doctor/repository/add_doctor_repository.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class AddDoctorController extends GetxController {
  // Date of Birth
  final Rxn<DateTime> dob = Rxn<DateTime>();

  DateTime? get getDob => dob.value;
  set setDob(DateTime? value) => dob.value = value;

  // Image (can be either File or html.File)
  final Rxn<dynamic> image = Rxn<dynamic>();

  dynamic get getImage => image.value;
  set setImage(dynamic value) => image.value = value;

  // Gender selection
  final RxnString selectedGender = RxnString();
  String? get getSelectedGender => selectedGender.value;
  set setSelectedGender(String? value) => selectedGender.value = value;

  final List<String> genderList = ['Male', 'Female', 'Other'];

  // Counter for entries
  final RxInt counter = 0.obs;

  int get getCounter => counter.value;
  set setCounter(int value) {
    counter.value = value;
    _updateControllers();
  }

  // List of TextEditingController lists
  final RxList<List<TextEditingController>> textControllers =
      <List<TextEditingController>>[].obs;

  // Update the list of controllers based on counter
  void _updateControllers() {
    if (textControllers.length < counter.value) {
      // Add more sets of 3 controllers if counter is increased
      textControllers
          .addAll(List.generate(counter.value - textControllers.length, (_) {
        return [
          TextEditingController(), // Institution name
          TextEditingController(), // Passed year
          TextEditingController() // Degree name
        ];
      }));
    } else if (textControllers.length > counter.value) {
      // Remove controllers if counter is decreased
      textControllers.removeRange(counter.value, textControllers.length);
    }
  }

  // Remove an entry by index
  void removeByIndex(int index) {
    if (counter.value > 0) {
      counter.value--;
      textControllers.removeAt(index);
    }
  }

  // Clear all controllers
  void clearControllers() {
    textControllers.clear();

    nameController.clear();
    emailController.clear();
    phoneController.clear();
    districtController.clear();
    licsenseIdController.clear();
    specializationController.clear();
    visitingFeeController.clear();
  }

  // controllers:
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final districtController = TextEditingController();
  final licsenseIdController = TextEditingController();
  final specializationController = TextEditingController();
  final visitingFeeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textControllers.clear();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    districtController.dispose();
    licsenseIdController.dispose();
    specializationController.dispose();
    visitingFeeController.dispose();

    textControllers.forEach((element) {
      element.forEach((controller) {
        controller.dispose();
      });
    });
  }

  Future<void> selectDOB() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setDob = picked;
    }
  }

  // web image picker with html.File
  Future<void> pickImage() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();

    //only accept png and jpeg files
    uploadInput.accept = 'image/png, image/jpeg';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final file = files[0];
      final reader = html.FileReader();
      reader.readAsDataUrl(file);

      reader.onLoadEnd.listen((e) {
        setImage = file;
      });
    });
  }

  var isLoading = false.obs;

  void validate() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        districtController.text.isEmpty ||
        licsenseIdController.text.isEmpty ||
        specializationController.text.isEmpty ||
        visitingFeeController.text.isEmpty ||
        getDob == null ||
        getSelectedGender == null ||
        getImage == null) {
      Get.snackbar('Error', 'Please fill all fields',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // check if at least one degree is added
    if (textControllers.isEmpty) {
      Get.snackbar('Error', 'Please add at least one degree',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // check if all degree fields are filled
    for (var i = 0; i < textControllers.length; i++) {
      if (textControllers[i][0].text.isEmpty ||
          textControllers[i][1].text.isEmpty ||
          textControllers[i][2].text.isEmpty) {
        Get.snackbar('Error', 'Please fill all degree fields',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
    }
  }

  Future<void> registerDoctor() async {
    try {
      // check if all fields are filled
      if (!allFieldsFilled()) {
        Get.snackbar('Error', 'Please fill all fields',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      isLoading(true);

      // create a list of degrees
      final List<Map<String, String>> degrees = [];
      for (var i = 0; i < textControllers.length; i++) {
        degrees.add({
          'institution': textControllers[i][0].text,
          'passedYear': textControllers[i][1].text,
          'degree': textControllers[i][2].text
        });
      }

      // upload image to firebase storage and get the url
      String imageUrl = await AddDoctorRepository().uploadImage(getImage);

      // create a map of doctor data
      final Map<String, dynamic> doctorData = {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'district': districtController.text,
        'dob': getDob!.toIso8601String(),
        'gender': getSelectedGender,
        'degrees': degrees,
        'licenseId': licsenseIdController.text,
        'specialization': specializationController.text,
        'visitingFee': visitingFeeController.text,
        'image': imageUrl,
      };

      // add doctor to firestore
      bool isDone = await AddDoctorRepository().addDoctor(doctorData);

      if (isDone) {
        isLoading(false);
        Get.snackbar('Success', 'Doctor added successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        clearControllers();
        setCounter = 0;
        setDob = null;
        setSelectedGender = null;
        setImage = null;
      } else {
        isLoading(false);
        Get.snackbar('Error', 'Failed to add doctor',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool allFieldsFilled() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        districtController.text.isEmpty ||
        licsenseIdController.text.isEmpty ||
        specializationController.text.isEmpty ||
        visitingFeeController.text.isEmpty ||
        getDob == null ||
        getSelectedGender == null ||
        getImage == null) {
      print('Mandatory fields are missing');
      return false;
    }

    if (textControllers.isEmpty) {
      print('No degrees added');
      return false;
    }

    for (var i = 0; i < textControllers.length; i++) {
      if (textControllers[i][0].text.isEmpty ||
          textControllers[i][1].text.isEmpty ||
          textControllers[i][2].text.isEmpty) {
        print('Degree fields are incomplete at index $i');
        return false;
      }
    }

    return true;
  }
}
