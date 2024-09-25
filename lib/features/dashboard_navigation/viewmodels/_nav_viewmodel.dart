import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationViewModel extends ChangeNotifier {
  int _selectedIndex = 3;

  int get selectedIndex => _selectedIndex;

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

}

final navigationViewModelProvider = ChangeNotifierProvider((ref) => NavigationViewModel());