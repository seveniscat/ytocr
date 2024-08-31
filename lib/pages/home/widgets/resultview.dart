import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ytocr/pages/Home/index.dart';
import 'package:ytocr/pages/home/widgets/ocrview.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final homeController = Get.find<HomeController>();
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: 'records',
      builder: (controller) {
        final records = controller.recordResult ?? [];
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: card('识别记录',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () => controller.showPage(0),
                      icon: const Icon(Icons.arrow_back)),
                  Expanded(
                    child: records.isNotEmpty
                        ? ListView.builder(
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              final item =
                                  records[index] as Map<String, dynamic>?;
                              final total = item?['total'];
                              final succ = item?['success'] ?? 0;
                              final fail = item?['fail'] ?? 0;
                              String status = "-";
                              if (total != null && total > 0) {
                                if (total == (succ + fail)) {
                                  final rate = ((succ / total) * 100);
                                  final str = NumberFormat("#,##0.00")
                                      .format(rate)
                                      .replaceAll(".00", '');
                                  status = "识别已完成  成功率:$str%";
                                } else {
                                  status = "识别中";
                                }
                              }

                              return ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('批次号: ${item?['taskId']}'),
                                        TextButton(
                                            onPressed: () {},
                                            child: Icon(Icons.copy)),
                                      ],
                                    ),
                                    Text(
                                        "共${total ?? '-'}条数据，成功${succ ?? '-'}条，失败${fail ?? '-'}条"),
                                    Text(status)
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    const Text('识别时间：'),
                                    Text(formatDate(item?['createAt']) ?? '-'),
                                  ],
                                ),
                              );
                            })
                        : const Center(child: Text('未查询到识别记录')),
                  ),
                ],
              )),
        );
      },
    );
  }
}
