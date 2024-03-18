import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DividerC extends StatelessWidget {
  const DividerC({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: context.theme.textTheme.bodySmall!.color);
  }
}
