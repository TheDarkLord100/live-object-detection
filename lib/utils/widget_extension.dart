import 'package:flutter/material.dart';

extension CustomExt on Widget {
  Padding paddingForAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );
  Expanded asExpanded(int flex) => Expanded(
        flex: flex,
        child: this,
      );
  Center wrapCenter() => Center(
        child: this,
      );
}
