import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:realtime_object_zoom/utils/snackbar.dart';
import 'package:realtime_object_zoom/utils/widget_extension.dart';
import 'package:realtime_object_zoom/widgets/display_image.dart';
import 'detector_widget.dart';
import '../models/screen_params.dart';

class HomeViewScreen extends StatefulWidget {
  const HomeViewScreen({super.key});

  @override
  State<HomeViewScreen> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeViewScreen> {
  final GlobalKey _globalKey = GlobalKey();
  bool isLoading = false;

  void showSnack(String msg) {
    Snackbar.displaySnackbar(context, msg);
  }

  void navigate(Uint8List data) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DisplayImageWidget(imageBytes: data)));
  }

  void _takeScreenshot() async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      navigate(byteData.buffer.asUint8List());
    } else {
      showSnack('Error saving snapshot!!');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text("Realtime Object Detection"),
      ),
      body: Stack(
        children: [
          RepaintBoundary(key: _globalKey, child: const DetectorWidget()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              height: 120,
              child: Row(
                children: [
                  const Column(
                    children: [
                      Text(
                        'Double Tap on any detected object to zoom on it.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Click on the screenshot icon to take a snapshot of the current screen.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )
                    ],
                  ).asExpanded(5),
                  IconButton(
                          onPressed: _takeScreenshot,
                          icon: isLoading
                              ? const CircularProgressIndicator()
                              : const Icon(
                                  Icons.camera_outlined,
                                  size: 50,
                                ))
                      .wrapCenter()
                      .asExpanded(2),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
