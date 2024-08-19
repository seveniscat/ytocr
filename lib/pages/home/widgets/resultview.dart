import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ytocr/pages/Home/index.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: TextButton(
            onPressed: () {
              Get.find<HomeController>().showPage(0);
              ;
            },
            child: Text('返回')),
      ),
    );
  }
}
