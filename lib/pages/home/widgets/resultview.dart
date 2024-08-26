import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ytocr/pages/Home/index.dart';
import 'package:ytocr/pages/home/widgets/ocrview.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        final records = controller.recordResult.value ?? [];
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: card('识别记录',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final item = records[index] as Map<String, dynamic>?;
                          return ListTile(
                            title: Text(item?['taskId']),
                            subtitle: Text(item?['createAt']),
                          );
                        }),
                  ),
                  IconButton(
                      onPressed: () => controller.showPage(0),
                      icon: Icon(Icons.arrow_back))
                ],
              )),
        );
      },
    );
  }
}
