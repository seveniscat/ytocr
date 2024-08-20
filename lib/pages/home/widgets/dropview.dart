import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class DragAndDropWidget extends StatefulWidget {
  @override
  _DragAndDropWidgetState createState() => _DragAndDropWidgetState();
}

class _DragAndDropWidgetState extends State<DragAndDropWidget> {
  late DropzoneViewController _controller;
  String? _droppedDirectory;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DropzoneView(
          onCreated: (controller) => _controller = controller,
          onDrop: (dynamic droppedFile) async {
            // Get the file name and check if it is a directory
            String fileName = await _controller.getFilename(droppedFile);
            bool isDirectory = !fileName.contains('.');
            if (isDirectory) {
              setState(() {
                _droppedDirectory = fileName;
              });
              print('Dropped folder: $_droppedDirectory');
            } else {
              print('Not a folder');
            }
          },
        ),
        Center(
          child: _droppedDirectory != null
              ? Text('Dropped folder: $_droppedDirectory')
              : Text('Drag a folder here'),
        ),
      ],
    );
  }
}
