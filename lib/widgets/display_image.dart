import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../utils/snackbar.dart';

class DisplayImageWidget extends StatefulWidget {
  const DisplayImageWidget({super.key, required this.imageBytes});

  final Uint8List imageBytes;

  @override
  State<DisplayImageWidget> createState() => _DisplayImageWidgetState();
}

class _DisplayImageWidgetState extends State<DisplayImageWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Preview'),
      ),
      body: Image.memory(widget.imageBytes),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isLoading) {
            return;
          }
          setState(() {
            isLoading = true;
          });
          final result = await ImageGallerySaver.saveImage(widget.imageBytes);
          debugPrint(result);
          if (result['isSuccess']) {
            showSnack('File saved successfully to ${result['filePath']}');
          } else {
            showSnack('Error: ${result['errorMessage']}');
          }
          setState(() {
            isLoading = false;
          });
        },
        child: const Icon(Icons.save_alt),
      ),
    );
  }

  void showSnack(String msg) {
    Snackbar.displaySnackbar(context, msg);
  }
}
