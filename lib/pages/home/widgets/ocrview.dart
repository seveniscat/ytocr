import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ytocr/pages/Home/controller.dart';

Widget card(String text, {required Widget child}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(text),
      const SizedBox(
        height: 15,
      ),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  // blurStyle: BlurStyle.normal,
                  // offset: Offset.zero,
                  // spreadRadius: 8,
                )
              ]),
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          child: child,
        ),
      )
    ],
  );
}

class OcrView extends StatefulWidget {
  const OcrView({super.key});

  @override
  State<OcrView> createState() => _OcrViewState();
}

class _OcrViewState extends State<OcrView> {
  Directory? selectedDirectory;

  Widget _leftView() {
    return card(
      '选择文件夹',
      child: Center(
        child: Column(
          children: [
            // Expanded(
            //   child: GetBuilder<HomeController>(
            //     id: 'dirs',
            //     builder: (controller) {
            //       final arr = controller.dirs.value;
            //       return ListView.builder(
            //         itemCount: arr.length,
            //         itemBuilder: (context, index) {
            //           return ListTile(
            //             title: Text(arr[index]),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),
            GetBuilder<HomeController>(
              id: 'dirs',
              builder: (controller) {
                final arr = controller.dirs;
                if (arr.isEmpty) return const SizedBox();
                return ListTile(
                  title: Text(arr[0] ?? ''),
                );
                // return ListView.builder(
                //   itemCount: arr.length,
                //   itemBuilder: (context, index) {
                //     return ListTile(
                //       title: Text(arr[index]),
                //     );
                //   },
                // );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // _pickDirectory(Get.context!);
                    _getDirectoryPath(Get.context!);
                  },
                  child: const Text('点击添加文件夹'),
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Get.find<HomeController>().startOCR();
                  },
                  child: const Text(
                    '开始识别',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getDirectoryPath(BuildContext context) async {
    const String confirmButtonText = 'Choose';
    final String? directoryPath = await getDirectoryPath(
      confirmButtonText: confirmButtonText,
    );
    if (directoryPath == null) {
      return;
    }
    final controller = Get.find<HomeController>();
    controller.addPath(directoryPath);
  }

  Widget _rightView() {
    return card(
      'OCR结果',
      child: GetBuilder<HomeController>(
          id: 'result',
          builder: (controller) {
            final result = controller.ocrResult;
            return Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('文件夹路径：${controller.resultPath.value}'),
                  if (result != null) ...[
                    TextButton(onPressed: () {}, child: const Text('下载结果文件')),
                    Text(
                        "共${result['total'] ?? '-'}条数据，成功${result['success'] ?? '-'}条，失败${result['fail'] ?? '-'}条"),
                    Text("更新时间:${result['updateAt'] ?? '-'}")
                  ],
                  const SizedBox(
                    height: 50,
                  ),
                  TextButton(
                    child: const Text('查看识别日志'),
                    onPressed: () {
                      controller.checkRecordPage();
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.find<HomeController>().startOCR();
                        },
                        child: const Text(
                          '保存到本地',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Expanded(child: _leftView()),
          const SizedBox(
            width: 30,
          ),
          Expanded(child: _rightView()),
        ],
      ),
    );
  }
}
