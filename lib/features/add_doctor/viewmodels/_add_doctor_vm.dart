import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddDoctorviewModel extends ChangeNotifier {
  DateTime? dob;

  DateTime? get getDob => dob;

  set setDob(DateTime? value) {
    dob = value;
    notifyListeners();
  }


  dynamic image; // This can be either File or html.File
  dynamic get getImage => image;

  set setImage(dynamic value) {
    image = value;
    notifyListeners();
  }


  String? _selectedGender;
  String? get selectedGender => _selectedGender;
  set selectedGender(String? value) {
    _selectedGender = value;
    notifyListeners();
  }

  List<String> genderList = ['Male','Female','Other'];

  int _counter = 0;

  // List of lists to store 3 controllers for each entry
  List<List<TextEditingController>> _textControllers = [];

  // Getter for counter
  int get counter => _counter;

  // Setter for counter
  set counter(int value) {
    _counter = value;
    _updateControllers();
    notifyListeners();
  }

  // Getters for the list of TextEditingControllers
  List<List<TextEditingController>> get textControllers => _textControllers;

  // Update the list of controllers based on counter
  void _updateControllers() {
    if (_textControllers.length < _counter) {
      // Add more sets of 3 controllers if counter is increased
      _textControllers.addAll(List.generate(_counter - _textControllers.length, (_) {
        return [
          TextEditingController(), // Institution name
          TextEditingController(), // Passed year
          TextEditingController()  // Degree name
        ];
      }));
    } else if (_textControllers.length > _counter) {
      // Remove controllers if counter is decreased
      _textControllers.removeRange(_counter, _textControllers.length);
    }
  }

  void removeByIndex(int index) {
    _counter--;
    _textControllers.removeAt(index);
    notifyListeners();
  }

  void clearControllers() {
    _textControllers.clear();
    notifyListeners();
  }
}

final addDoctorViewModelProvider =
    ChangeNotifierProvider<AddDoctorviewModel>((ref) => AddDoctorviewModel());
