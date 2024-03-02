import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:realtime_object_zoom/models/recognition.dart';
import 'package:realtime_object_zoom/models/screen_params.dart';
import 'package:realtime_object_zoom/service/detector_service.dart';

import 'box_widget.dart';

class DetectorWidget extends StatefulWidget {
  const DetectorWidget({super.key});

  @override
  State<DetectorWidget> createState() => _DetectorWidgetState();
}

class _DetectorWidgetState extends State<DetectorWidget>
    with WidgetsBindingObserver {
  late List<CameraDescription> cameras;

  CameraController? camController;
  Detector? _detector;
  StreamSubscription? _subscription;
  bool isZoomedIn = false;
  List<Recognition>? results;
  get controller => camController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initAsync();
  }

  void _initAsync() async {
    _initializeCamera();

    Detector.start().then((value) {
      setState(() {
        _detector = value;
        _subscription = value.resultStream.stream.listen((event) {
          setState(() {
            results = event['recognitions'];
          });
        });
      });
    });
  }

  void _initializeCamera() async {
    cameras = await availableCameras();
    camController =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false)
          ..initialize().then((value) async {
            await controller.startImageStream(onLatestImageAvailable);
            controller.setZoomLevel(1.0);
            setState(() {});
            ScreenParams.previewSize = controller.value.previewSize!;
          });
  }

  @override
  Widget build(BuildContext context) {
    if (camController == null || !controller.value.isInitialized) {
      return const SizedBox.shrink();
    }
    var aspect = 1 / controller.value.aspectRatio;
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: aspect,
          child: GestureDetector(
              onDoubleTap: () {
                if (isZoomedIn) {
                  controller.setZoomLevel(1.0);
                  isZoomedIn = false;
                }
                setState(() {});
              },
              child: CameraPreview(controller)),
        ),
        AspectRatio(
          aspectRatio: aspect,
          child: _boundingBoxes(),
        )
      ],
    );
  }

  Widget _boundingBoxes() {
    if (results == null) {
      return const SizedBox.shrink();
    } else {
      return Stack(
        children: results!
            .map((result) => Positioned(
                  left: result.renderLocation.left,
                  top: result.renderLocation.top,
                  width: result.renderLocation.width,
                  height: result.renderLocation.height,
                  child: GestureDetector(
                    onDoubleTap: () {
                      if (isZoomedIn) {
                        controller.setZoomLevel(1.0);
                        isZoomedIn = false;
                      } else {
                        double w = ScreenParams.screenSize.width /
                            result.renderLocation.width;
                        double h = ScreenParams.screenSize.height /
                            result.renderLocation.height;
                        double zoom = min(w, h);
                        controller.setZoomLevel(zoom);
                        isZoomedIn = true;
                      }
                      setState(() {});
                    },
                    child: BoxWidget(
                        result: result,
                        randColor: Colors.primaries[
                            Random().nextInt(Colors.primaries.length)]),
                  ),
                ))
            .toList(),
      );
    }
  }

  void onLatestImageAvailable(CameraImage cameraImage) async {
    _detector?.processFrame(cameraImage);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        camController?.stopImageStream();
        _detector?.stop();
        _subscription?.cancel();
        break;
      case AppLifecycleState.resumed:
        _initAsync();
        break;
      default:
    }
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
    camController?.dispose();
    _detector?.stop();
    _subscription?.cancel();
  }
}
