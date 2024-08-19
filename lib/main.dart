import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ytocr/routers/index.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: RouteNames.main,
    theme: ThemeData(useMaterial3: true),
    defaultTransition: Transition.fade,
    getPages: RoutePages.list,
  ));
}
