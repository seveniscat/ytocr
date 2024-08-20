import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:ytocr/pages/home/widgets/dropview.dart';
// import 'package:flutter/foundation.dart';

class OcrView extends StatefulWidget {
  const OcrView({super.key});

  @override
  State<OcrView> createState() => _OcrViewState();
}

class _OcrViewState extends State<OcrView> {
  Directory? selectedDirectory;
  Widget _leftView() {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // _pickDirectory(Get.context!);
                _getDirectoryPath(Get.context!);
              },
              child: const Text('选择文件夹'),
            ),
            selectedDirectory != null
                ? Text("选择的文件夹 : ${selectedDirectory!.path}")
                : Text("选择的文件夹 : -"),
            ElevatedButton(
              onPressed: () {},
              child: const Text('开始识别'),
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
    print("_getDirectoryPath");

    if (directoryPath == null) {
      // Operation was canceled by the user.
      return;
    }
    if (context.mounted) {
      await showDialog<void>(
        context: context,
        builder: (context) {
          return Text(directoryPath);
        },
      );
    }
  }

  // Future<void> _pickDirectory(BuildContext context) async {
  //   Directory? directory = selectedDirectory;
  //   directory ??= Directory(FolderPicker.rootPath);
  //   Directory? newDirectory = await FolderPicker.pick(
  //     context: context,
  //     rootDirectory: directory,
  //     // shape: RoundedRectangleBorder(
  //     //     borderRadius: BorderRadius.all(Radius.circular(10))),
  //   );

  //   // Directory newDirectory = await FolderPicker.pick(
  //   //     allowFolderCreation: true,
  //   //     context: context,
  //   //     rootDirectory: directory,
  //   //     shape: RoundedRectangleBorder(
  //   //         borderRadius: BorderRadius.all(Radius.circular(10))));
  //   setState(() {
  //     selectedDirectory = newDirectory;
  //     print(selectedDirectory);
  //   });
  // }

  Widget _rightView() {
    return Container(
        color: Colors.blue,
        child: Center(
          child: DragAndDropWidget(),
        ));
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
