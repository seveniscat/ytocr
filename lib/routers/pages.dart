import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:ytocr/pages/Home/index.dart';

import 'names.dart';

class RoutePages {
  // 列表
  static List<GetPage> list = [
    GetPage(
      name: RouteNames.main,
      page: () => const HomePage(),
    )
  ];
}
