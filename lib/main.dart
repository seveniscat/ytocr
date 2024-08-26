import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ytocr/routers/index.dart';
import 'dart:io';

import 'init_bindings.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialBinding: InitBindings(),
    initialRoute: RouteNames.main,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: Platform.isWindows ? "微软雅黑" : null,
    ),
    defaultTransition: Transition.fade,
    getPages: RoutePages.list,
  ));
}
