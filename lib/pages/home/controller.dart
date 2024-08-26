import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final pageIdx = 0.obs;
  var startPickerValue = RxList<DateTime?>.from([DateTime.now()]);
  var endPickerValue = RxList<DateTime?>.from([DateTime.now()]);

  final dirs = <String>[].obs;
  final resultPath = ''.obs;
  final ocrResult = <String, dynamic>{}.obs;
  final recordResult = <dynamic>[].obs;

  final dio = Dio(BaseOptions(baseUrl: 'http://119.45.248.52:8080'));

  HomeController();

  _initData() {
    update(["home"]);
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
      final res = await dio.post<Map<String, dynamic>>('/api/v1/task/submit',
          data: {'filedir': path});
      final taskId = res.data?['taskId'] as String?;
      if (taskId != null && taskId.isNotEmpty) {
        resultPath.value = path;
        queryOcrResult(taskId);
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
  queryOcrRecords() async {
    final res = await dio
        .get('api/v1/task/list', queryParameters: {"pageSize": 50, "page": 1});
    final list = res.data?['list']?['items'] as List?;
    recordResult.value = list ?? [];
  }

  // 下载识别结果
  download(String taskId) async {
    final res = await dio.get('api/v1/task/:taskId/download',
        queryParameters: {"taskId": taskId});
    print(res);
  }

  checkRecordPage() {
    showPage(1);
    queryOcrRecords();
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
}
