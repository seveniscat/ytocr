import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ytocr/pages/home/inter.dart';

class HomeController extends GetxController {
  final pageIdx = 0.obs;
  var startPickerValue = RxList<DateTime?>.from([DateTime.now()]);
  var endPickerValue = RxList<DateTime?>.from([DateTime.now()]);

  final dirs = <String>[].obs;
  final resultPath = ''.obs;
  final ocrResult = <String, dynamic>{}.obs;
  final recordResult = <dynamic>[].obs;

  final dio = Dio(BaseOptions(
    //
    // baseUrl: 'http://119.45.248.52:8080/',
    baseUrl: 'http://127.0.0.1:8080/',
    receiveDataWhenStatusError: true,
  ));

  HomeController();

  _initData() {
    update(["home"]);
    dio.interceptors.add(CustomLogInterceptor());
  }

  void onTap() {}

  addPath(String path) {
    // if (dirs.contains(path)) {
    //   dirs.remove(path);
    // }
    // dirs.add(path);
    dirs.value = [path];
    update(['dirs']); //result
  }

  startOCR() async {
    if (dirs.isEmpty) return;
    try {
      final path = dirs[0];
      // const path = 'C:\\Users\\李子晴\\Desktop\\images';
      final param = {'filedir': path}; // C:\Users\李子晴\Desktop\images
      final res = await dio.post<Map<String, dynamic>>('/api/v1/task/submit',
          queryParameters: param);
      final taskId = res.data?['taskId'] as String?;
      if (taskId != null && taskId.isNotEmpty) {
        resultPath.value = path;
        queryOcrResult(taskId);
      } else {
        resultPath.value = path;
        update(['result']);
      }
    } catch (e) {
      print(e);
    }
  }

  // 查询识别状态
  queryOcrResult(String taskId) async {
    final res = await dio.get<Map<String, dynamic>>('api/v1/task/$taskId');
    final resData = res.data;
    final result = resData?['task'] as Map<String, dynamic>;
    ocrResult.value = result;
    update(['result']);
  }

  // 识别日志列表
  queryOcrRecords({String? start, String? end}) async {
    final res = await dio.get('api/v1/task/list', queryParameters: {
      "pageSize": 100,
      "page": 1,
      if (start != null) ...{'start_time': start},
      if (end != null) ...{'end_time': end},
    });
    final list = res.data?['list']?['items'] as List?;
    recordResult.value = list ?? [];
  }

  checkRecordPage({String? start, String? end}) async {
    await queryOcrRecords(start: start, end: end);
    showPage(1);
    update(["records"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  showPage(int idx) {
    pageIdx.value = idx;
    update(["home"]);
  }

  download1(String? taskId) async {
    if (taskId == null) return;
    if (taskId.isEmpty) return;
    final url = 'api/v1/task/$taskId/download';
    try {
      final response = await dio.get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false, // 避免自动重定向，以便我们可以检查 Content-Disposition
            validateStatus: (status) => status! < 500,
            receiveTimeout: const Duration(seconds: 10), // 设置接收超时时间
          ),
          onReceiveProgress: _onDownloadProgress);
      final filename =
          '${'票据识别-$taskId-${DateTime.now().toString()}'.replaceAll(RegExp(r'[ .]'), '_')}.xlsx';
      final directory = await _getDownloadDirectory();
      // C:\Users\李子晴\Downloads\票据识别-hEmWryZaDg-2024-08-21 21_18_28.xlsx
      final str = Platform.isWindows ? '\\' : '/';
      final filePath = '${directory.path}$str$filename';
      final file = File(filePath);
      await file.writeAsBytes(response.data);
      Get.showSnackbar(GetSnackBar(
        title: '文件下载成功',
        message: '请前往文件目录：$filePath 查看',
        duration: const Duration(seconds: 2),
      ));
      await launchUrl(Uri.file(directory.path));
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: '${dio.options.baseUrl}api/v1/task/$taskId/download'));
      Get.showSnackbar(GetSnackBar(
        title: '下载失败 - 下载链接已复制，可前往浏览器粘贴链接并下载',
        message: '失败原因: $e',
        duration: const Duration(seconds: 6),
      ));
    }
  }

  void _onDownloadProgress(int count, int total) {
    if (total != -1) {
      print('已下载 ${count ~/ 1024} KB / ${total ~/ 1024} KB');
    }
  }

  Future<Directory> _getDownloadDirectory() async {
    // 获取下载目录，这里使用了 path_provider 库来获取文档目录
    final directory = await getDownloadsDirectory();
    if (directory == null) {
      return await getApplicationDocumentsDirectory();
    }
    return directory;
  }
}
