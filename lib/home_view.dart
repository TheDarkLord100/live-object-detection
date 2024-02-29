import 'package:flutter/material.dart';
import 'detector_widget.dart';
import 'models/screen_params.dart';

class HomeViewScreen extends StatelessWidget {
  const HomeViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(title: const Text("Realtime Object Detection"),
      ),
      body: const DetectorWidget(),
    );
  }
}
