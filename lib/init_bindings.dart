import 'package:get/get.dart';
import 'package:ytocr/pages/Home/controller.dart';

class InitBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(HomeController(), permanent: true);
  }
}
