import 'package:flutter/material.dart';
import 'package:realtime_object_zoom/models/recognition.dart';

class BoxWidget extends StatelessWidget {

  final Recognition result;
  const BoxWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: result.renderLocation.width,
      height: result.renderLocation.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 3),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: FittedBox(
          child: Container(
            color: Colors.red,
            child: Text('${result.label} ${result.score.toStringAsFixed(2)}')
          ),
        ),
      ),
    );
  }
}
