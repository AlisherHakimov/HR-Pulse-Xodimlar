import 'package:flutter/cupertino.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, this.height, this.width, this.color});

  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(child: CupertinoActivityIndicator()),
    );
  }
}
