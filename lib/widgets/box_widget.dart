import 'package:flutter/material.dart';
import 'package:realtime_object_zoom/models/recognition.dart';

class BoxWidget extends StatelessWidget {
  final Recognition result;
  final Color randColor;
  const BoxWidget({super.key, required this.result, required this.randColor});

  @override
  Widget build(BuildContext context) {
    final int percent = (result.score * 100).toInt();
    return Container(
      width: result.renderLocation.width,
      height: result.renderLocation.height,
      decoration: BoxDecoration(
          border: Border.all(color: randColor, width: 3),
          borderRadius: BorderRadius.circular(8)),
      child: Align(
        alignment: Alignment.topLeft,
        child: FittedBox(
          child: Container(
              color: randColor, child: Text('${result.label} - $percent%')),
        ),
      ),
    );
  }
}
