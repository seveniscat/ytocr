import 'package:get/get.dart';

class HomeController extends GetxController {
  final pageIdx = 0.obs;
  var startPickerValue = RxList<DateTime?>.from([DateTime.now()]);
  var endPickerValue = RxList<DateTime?>.from([DateTime.now()]);

  HomeController();

  _initData() {
    update(["home"]);
  }

  void onTap() {}

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  showPage(int idx) {
    pageIdx.value = idx;
    update(["home"]);
  }
}
