import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ytocr/pages/Home/controller.dart';

Widget card(String text, {required Widget child}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
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

  String? formatDate(String? dateStr) {
    // 2024-08-31T11:22:18.4846088+08:00
    if (dateStr == null) return null;
    if (dateStr.isEmpty) return null;
    try {
      // final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
      final date = DateTime.parse(dateStr).toUtc();
      final format = DateFormat('yyyy-MM-dd HH:mm:ss');
      return format.format(date);
    } catch (_) {
      return null;
    }
  }

  Widget _item(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Text(title),
          Expanded(
            child: Text(
              subtitle,
              style: const TextStyle(color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }

  Widget _rightView() {
    return card(
      'OCR结果',
      child: GetBuilder<HomeController>(
          id: 'result',
          builder: (controller) {
            final result = controller.ocrResult;
            final total = result['total'];
            final succ = result['success'] ?? 0;
            final fail = result['fail'] ?? 0;
            String status = "-";
            if (total != null && total > 0) {
              if (total == (succ + fail)) {
                status =
                    "识别完成  成功率:${((succ / total) * 100).toStringAsFixed(2)}%";
              } else {
                status = "识别中";
              }
            }
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _item('当前识别路径：', controller.resultPath.value),
                  if (result.isNotEmpty) ...[
                    Text(
                        "共${total ?? '-'}条数据，成功${succ ?? '-'}条，失败${fail ?? '-'}条"),
                    _item("识别状态：", status ?? '-'),
                    _item("更新时间：", formatDate(result['updateAt']) ?? '-'),
                    _item("创建时间：", formatDate(result['createAt']) ?? '-'),
                  ] else if (controller.resultPath.value.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Center(
                          child: Text(
                        '未查询到识别记录',
                        style: TextStyle(color: Colors.grey),
                      )),
                    )
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
                      child: TextButton(
                          onPressed: () {
                            controller.download1(result['taskId']);
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '下载结果文件',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.cloud_download_outlined),
                            ],
                          )),
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
