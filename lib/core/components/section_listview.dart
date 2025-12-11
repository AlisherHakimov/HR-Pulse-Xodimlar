import 'package:flutter/material.dart';
import 'package:hr_plus/core/core.dart';

class SectionListView extends StatelessWidget {
  const SectionListView(
      {super.key,
      required this.height,
      this.spacing,
      this.padding,
      required this.itemBuilder,
      required this.itemCount});

  final double height;
  final EdgeInsetsGeometry? padding;
  final int itemCount;
  final double? spacing;

  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: context.width,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
        separatorBuilder: (context, index) => SizedBox(
          width: spacing ?? 16,
        ),
      ),
    );
  }
}
