import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_folder_picker/FolderPicker.dart';

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
                _pickDirectory(Get.context!);
              },
              child: const Text('选择文件夹'),
            ),
            selectedDirectory != null
                ? Text("选择的文件夹 : ${selectedDirectory!.path}")
                : Text("选择的文件夹 : -"),
            ElevatedButton(
              onPressed: () async {
                // _pickDirectory(Get.context!);
              },
              child: const Text('开始识别'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDirectory(BuildContext context) async {
    Directory? directory = selectedDirectory;
    directory ??= Directory(FolderPicker.rootPath);
    Directory? newDirectory = await FolderPicker.pick(
      context: context,
      rootDirectory: directory,
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(10))),
    );

    // Directory newDirectory = await FolderPicker.pick(
    //     allowFolderCreation: true,
    //     context: context,
    //     rootDirectory: directory,
    //     shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.all(Radius.circular(10))));
    setState(() {
      selectedDirectory = newDirectory;
      print(selectedDirectory);
    });
  }

  Widget _rightView() {
    return Container(
      color: Colors.blue,
      child: Center(child: Text('识别结果')),
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
