import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectedIndex = 4.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
