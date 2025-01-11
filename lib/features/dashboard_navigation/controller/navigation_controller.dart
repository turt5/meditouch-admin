import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectedIndex = 5.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
